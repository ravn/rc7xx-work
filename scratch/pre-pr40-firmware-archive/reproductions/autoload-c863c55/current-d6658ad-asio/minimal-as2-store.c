typedef unsigned char uint8_t;

void write_port(void) {
  *(volatile __attribute__((address_space(2))) uint8_t *)5 = 0x42;
}
