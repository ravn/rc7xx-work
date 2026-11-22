typedef unsigned char uint8_t;
typedef unsigned short uint16_t;

volatile uint8_t rx_status = 0;
uint8_t packet_errors = 0;

__attribute__((noinline))
uint8_t parse_packet(uint8_t *base, uint16_t offset, uint8_t len, uint8_t delim, uint8_t *flags) {
    if (rx_status & 0x01) {
        packet_errors++;
        return 0;
    }

    uint8_t *ptr = base + offset;
    uint8_t matches = 0;

    for (uint8_t i = len; i != 0; --i) {
        if (*ptr == delim) {
            matches++;
            *flags |= 0x80;
        } else {
            (*flags)++;
        }
        ptr++;
    }

    return matches;
}

int main(void) {
    uint8_t buffer[16] = {
        0x10, 0x20, 0x30, 0x40,
        'A', 'B', 'X', 'C', 'X', 'D', 'X', 0x55,
        0x66, 0x77, 0x88, 0x99
    };
    uint8_t flags = 0;

    uint8_t count = parse_packet(buffer, 4, 7, 'X', &flags);
    if (count != 3)
        return 1;
    if (flags != 0x84)
        return 2;

    flags = 0x10;
    count = parse_packet(buffer, 4, 0, 'X', &flags);
    if (count != 0)
        return 3;
    if (flags != 0x10)
        return 4;

    rx_status = 1;
    packet_errors = 0;
    count = parse_packet(buffer, 4, 7, 'X', &flags);
    if (count != 0)
        return 5;
    if (packet_errors != 1)
        return 6;

    return 0;
}
