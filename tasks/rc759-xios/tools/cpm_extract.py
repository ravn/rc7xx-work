"""
Extract files from CP/M-86 disk images (RC759 Piccoline format).
"""
import os, sys

def extract_file(img_path, filename):
    with open(img_path, 'rb') as f:
        data = f.read()
    seclen, sectrk, trk_size = 1024, 8, 8192
    boottrk, boot_offset = 4, 32768
    blocksize, maxdir = 2048, 512
    dir_size = maxdir * 32
    dir_data = data[boot_offset : boot_offset + dir_size]
    extents = []
    
    fn_u = filename.upper()
    target_name, target_ext = fn_u.split('.', 1) if '.' in fn_u else (fn_u, '')
    target_name = target_name.ljust(8)[:8]
    target_ext = target_ext.ljust(3)[:3]
    
    for i in range(maxdir):
        entry = dir_data[i*32 : (i+1)*32]
        if entry[0] > 15:
            continue
        name = bytes([b & 0x7F for b in entry[1:9]]).decode('ascii', errors='ignore')
        ext = bytes([b & 0x7F for b in entry[9:12]]).decode('ascii', errors='ignore')
        if name == target_name and ext == target_ext:
            xl, bc, s2, rc = entry[12], entry[13], entry[14], entry[15]
            blocks = list(entry[16:32])
            w_blocks = [blocks[j] | (blocks[j+1] << 8) for j in range(0, 16, 2)]
            extents.append((xl, s2, rc, bc, w_blocks))
            
    if not extents:
        return None
    extents.sort(key=lambda x: (x[1], x[0]))
    file_bytes = bytearray()
    for xl, s2, rc, bc, w_blocks in extents:
        ext_bytes = bytearray()
        for blk in w_blocks:
            if blk == 0:
                break
            blk_offset = boot_offset + blk * blocksize
            ext_bytes.extend(data[blk_offset : blk_offset + blocksize])
        actual_len = rc * 128
        if bc != 0 and bc <= 128:
            if actual_len > 0:
                actual_len = (rc - 1) * 128 + bc
        file_bytes.extend(ext_bytes[:actual_len])
    return bytes(file_bytes)

def list_files(img_path):
    with open(img_path, 'rb') as f:
        data = f.read()
    boot_offset = 4 * 8 * 1024
    maxdir = 512
    dir_data = data[boot_offset : boot_offset + maxdir * 32]
    files = {}
    for i in range(maxdir):
        entry = dir_data[i*32 : (i+1)*32]
        user = entry[0]
        if user > 15:
            continue
        name = bytes([b & 0x7F for b in entry[1:9]]).decode('ascii', errors='ignore').strip()
        ext = bytes([b & 0x7F for b in entry[9:12]]).decode('ascii', errors='ignore').strip()
        fn = f'{name}.{ext}' if ext else name
        rc = entry[15]
        files[fn] = files.get(fn, 0) + rc * 128
    return files

if __name__ == '__main__':
    if len(sys.argv) < 3:
        print('Usage: cpm_extract.py <img_path> <filename> [out_path]')
        sys.exit(1)
    img_path = sys.argv[1]
    filename = sys.argv[2]
    out_path = sys.argv[3] if len(sys.argv) > 3 else os.path.basename(filename)
    b = extract_file(img_path, filename)
    if b is None:
        print(f'File {filename} not found in {img_path}')
        sys.exit(2)
    with open(out_path, 'wb') as f:
        f.write(b)
    print(f'Extracted {filename} ({len(b)} bytes) -> {out_path}')
