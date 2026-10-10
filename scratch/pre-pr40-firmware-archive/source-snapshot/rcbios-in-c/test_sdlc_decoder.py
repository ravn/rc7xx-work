#!/usr/bin/env python3
"""test_sdlc_decoder.py — synthetic round-trip test for sdlc_receiver.

Builds an ideal SDLC bit stream for a known payload (matching what a
Z80-SIO in SDLC mode with auto-CRC + NRZI + flag-idle would put on the
wire), oversamples it the way the FT2232D would capture it, then runs
the result through the same decode pipeline sdlc_receiver.py uses
against real captures.

Goal: confirm the decoder correctly recovers the payload and validates
the CRC on a known-good bit stream, and catch regressions to
find_frames / samples_to_bits / crc_ccitt.
"""
from __future__ import annotations

import random
import sys

from sdlc_receiver import (
    crc_ccitt,
    samples_to_bits,
    nrzi_decode,
    find_frames,
    bits_to_bytes,
)


# --- Synthetic SDLC encoder ---------------------------------------

def byte_to_lsb_bits(b: int) -> list[int]:
    return [(b >> i) & 1 for i in range(8)]


def bytes_to_lsb_bits(bs: bytes) -> list[int]:
    out: list[int] = []
    for b in bs:
        out.extend(byte_to_lsb_bits(b))
    return out


def hdlc_stuff(bits: list[int]) -> list[int]:
    """Insert a 0 after every 5 consecutive 1s."""
    out: list[int] = []
    ones = 0
    for b in bits:
        out.append(b)
        if b == 1:
            ones += 1
            if ones == 5:
                out.append(0)
                ones = 0
        else:
            ones = 0
    return out


def build_frame_bits(payload: bytes) -> list[int]:
    """Payload → [flag][stuffed(data+CRC)][flag]. CRC as Z80-SIO emits:
    low byte then high byte, both inverted (i.e. crc_ccitt() result)."""
    cv = crc_ccitt(payload)
    crc_bytes = bytes([cv & 0xFF, (cv >> 8) & 0xFF])
    data = payload + crc_bytes
    data_bits = bytes_to_lsb_bits(data)
    stuffed = hdlc_stuff(data_bits)
    flag = byte_to_lsb_bits(0x7E)       # 0 1 1 1 1 1 1 0
    return flag + stuffed + flag


def nrzi_encode(bits: list[int], start_level: int = 1) -> list[int]:
    """NRZI line levels: 0 in = transition, 1 in = no transition.
    Returns the sequence of line levels, one per bit cell."""
    level = start_level
    out: list[int] = []
    for b in bits:
        if b == 0:
            level ^= 1
        out.append(level)
    return out


def oversample(levels: list[int], sps: int, rxd_bit: int = 1,
               leading_idle: int = 0, trailing_idle: int = 0) -> bytes:
    """levels (one per bit cell) → FTDI-sample bytes at `sps` samples
    per bit cell, with RxD on ADBUS`rxd_bit`, other pins high.

    leading_idle / trailing_idle are extra bit cells of line-high (NRZI
    idle = continuous 1s = no transitions, steady level).
    """
    rxd_mask = 1 << rxd_bit
    other = 0xFF ^ rxd_mask  # keep other pins high
    out = bytearray()
    for _ in range(leading_idle * sps):
        out.append(other | rxd_mask)
    for lvl in levels:
        byte_hi = other | rxd_mask
        byte_lo = other
        b = byte_hi if lvl else byte_lo
        for _ in range(sps):
            out.append(b)
    for _ in range(trailing_idle * sps):
        out.append(other | rxd_mask)
    return bytes(out)


def build_capture(payload: bytes, sps: int = 8,
                  leading_flags: int = 4, trailing_flags: int = 4,
                  leading_idle: int = 20, trailing_idle: int = 20,
                  rxd_bit: int = 1) -> bytes:
    """Full synthetic capture: idle → flags → frame → flags → idle."""
    frame = build_frame_bits(payload)
    flag = byte_to_lsb_bits(0x7E)
    pre_flags: list[int] = []
    for _ in range(leading_flags):
        pre_flags.extend(flag)
    post_flags: list[int] = []
    for _ in range(trailing_flags):
        post_flags.extend(flag)
    all_bits = pre_flags + frame + post_flags
    levels = nrzi_encode(all_bits, start_level=1)
    return oversample(levels, sps=sps, rxd_bit=rxd_bit,
                      leading_idle=leading_idle,
                      trailing_idle=trailing_idle)


# --- Tests --------------------------------------------------------

def decode_and_check(samples: bytes, expected: bytes, sps: float,
                     rxd_bit: int = 1) -> tuple[bool, str]:
    rxd_mask = 1 << rxd_bit
    bits = samples_to_bits(samples, rxd_mask, sps)
    data_bits = nrzi_decode(bits)
    frames = find_frames(data_bits)
    if not frames:
        return False, f"no frame candidates ({len(data_bits)} data bits)"
    for idx, fb in enumerate(frames):
        n = len(fb) // 8
        frame = bits_to_bytes(fb[: n * 8])
        if len(frame) < 2:
            continue
        data, crc_rx = frame[:-2], frame[-2:]
        cv = crc_ccitt(data)
        cb = bytes([cv & 0xFF, (cv >> 8) & 0xFF])
        ok = cb == crc_rx
        if ok and data == expected:
            return True, f"frame {idx}: {len(data)}B CRC OK, payload matches"
        if data == expected:
            return False, (f"frame {idx}: payload matches but CRC mismatch "
                           f"rx={crc_rx.hex()} calc={cb.hex()}")
    # No perfect match — report best candidate
    summaries = []
    for idx, fb in enumerate(frames):
        n = len(fb) // 8
        frame = bits_to_bytes(fb[: n * 8])
        if len(frame) < 2:
            summaries.append(f"  cand {idx}: {len(frame)}B too short")
            continue
        data, crc_rx = frame[:-2], frame[-2:]
        cv = crc_ccitt(data)
        cb = bytes([cv & 0xFF, (cv >> 8) & 0xFF])
        summaries.append(
            f"  cand {idx}: {len(data)}B rx_crc={crc_rx.hex()} calc={cb.hex()} "
            f"data={data.hex()}"
        )
    return False, "no matching frame:\n" + "\n".join(summaries)


def run_tests() -> int:
    fails = 0

    # Payload exactly matches sioa_sdlc_tx.asm.
    payload = (
        b'SDLC-TX-TEST'
        + bytes([0x00, 0x01, 0x02, 0x03])
        + bytes([0xFF, 0xFF, 0xFF, 0xFF])
        + bytes([0x7E, 0x7E])
        + bytes([0xAA, 0x55, 0xAA, 0x55])
        + bytes([0xDE, 0xAD, 0xBE, 0xEF])
    )
    assert len(payload) == 30

    # --- Test 1: 8 sps, ideal capture ---
    samples = build_capture(payload, sps=8)
    ok, msg = decode_and_check(samples, payload, sps=8)
    print(("PASS" if ok else "FAIL") + f" test1 (sps=8, clean): {msg}")
    fails += 0 if ok else 1

    # --- Test 2: 4 sps, minimum viable oversampling ---
    samples = build_capture(payload, sps=4)
    ok, msg = decode_and_check(samples, payload, sps=4)
    print(("PASS" if ok else "FAIL") + f" test2 (sps=4, clean): {msg}")
    fails += 0 if ok else 1

    # --- Test 3: bit-stuffer stress (all-ones payload) ---
    stuff_payload = bytes([0xFF]) * 16
    samples = build_capture(stuff_payload, sps=8)
    ok, msg = decode_and_check(samples, stuff_payload, sps=8)
    print(("PASS" if ok else "FAIL") + f" test3 (sps=8, 0xFF*16): {msg}")
    fails += 0 if ok else 1

    # --- Test 4: payload with flag-byte literals (0x7E) ---
    flag_payload = bytes([0x7E, 0x7E, 0x7E, 0x7E, 0x7E, 0x7E, 0x7E, 0x7E])
    samples = build_capture(flag_payload, sps=8)
    ok, msg = decode_and_check(samples, flag_payload, sps=8)
    print(("PASS" if ok else "FAIL") + f" test4 (sps=8, 0x7E*8): {msg}")
    fails += 0 if ok else 1

    # --- Test 5: long leading idle (MAX_RUN_BITS cap exercise) ---
    samples = build_capture(payload, sps=8, leading_idle=200, trailing_idle=50)
    ok, msg = decode_and_check(samples, payload, sps=8)
    print(("PASS" if ok else "FAIL") + f" test5 (long idle): {msg}")
    fails += 0 if ok else 1

    # --- Test 6: clock drift tolerance (informational) ---
    # Encoder at 8 sps, decoder guesses wrong. Flags have 6 consecutive
    # 1s on the line; at ~8% drift round(6*8/7.3)=7 which looks like an
    # abort, so the decoder can't sync. Documents the need for
    # auto_decode's sps sweep when CTC rate is unknown.
    samples = build_capture(payload, sps=8)
    for dec_sps in (8.0, 7.8, 7.5, 7.3, 8.3, 8.5):
        ok, _ = decode_and_check(samples, payload, sps=dec_sps)
        print(f"INFO  drift enc=8.0 dec={dec_sps}: "
              f"{'recovers' if ok else 'fails'}")

    # --- Test 7: 10% random sample drops (representative FT2232D loss) ---
    random.seed(42)
    samples = build_capture(payload, sps=16)
    kept = bytearray(b for b in samples if random.random() > 0.10)
    # With drops, effective sps shrinks from 16 to ~14.4.
    ok, msg = decode_and_check(bytes(kept), payload, sps=14.4)
    print(("PASS" if ok else "FAIL") + f" test7 (10% drops @ sps=16): {msg}")
    fails += 0 if ok else 1

    # --- Test 8: degradation curve with random drops (informational) ---
    for drop_p in (0.05, 0.10, 0.20, 0.30, 0.50):
        random.seed(42)
        samples = build_capture(payload, sps=16)
        kept = bytes(b for b in samples if random.random() > drop_p)
        eff_sps = 16 * (1 - drop_p)
        ok, _ = decode_and_check(kept, payload, sps=eff_sps)
        print(f"INFO  drops={drop_p*100:.0f}% eff_sps={eff_sps:.1f}: "
              f"{'recovers' if ok else 'fails'}")

    # --- Test 9: crc_ccitt known answer ("123456789") ---
    # Receiver docstring claims residual 0x1D0F; actual value depends
    # on the "complement" convention. Check the stable value.
    ref = crc_ccitt(b"123456789")
    # CRC-CCITT-X.25 / CRC-16-CCITT-FALSE variants differ; with preset
    # 0xFFFF, reflected, final XOR 0xFFFF (= what crc_ccitt returns)
    # the result on "123456789" is 0x906E (X.25 CRC).
    print(f"INFO  crc_ccitt('123456789') = 0x{ref:04X} "
          f"(expected 0x906E for X.25 reflected CRC)")
    if ref != 0x906E:
        print("FAIL crc known-answer")
        fails += 1

    return fails


if __name__ == "__main__":
    n = run_tests()
    print(f"\n{'ALL PASS' if n == 0 else f'{n} FAILURE(S)'}")
    sys.exit(0 if n == 0 else 1)
