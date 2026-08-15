#include <iostream>

struct Greeter {
    Greeter()  { std::cout << "[ctor]" << std::endl; }
    ~Greeter() { std::cout << "[dtor]" << std::endl; }
};

static Greeter g;   // global: ctor before main (XI), dtor after main (YI)

int main()
{
    int n = 255;
    std::cout << "dec=" << n << " hex=" << std::hex << n << std::dec << std::endl;
    std::cout << "str=" << "abc" << " char=" << '!' << std::endl;
    long big = 100000L;
    std::cout << "long=" << big << std::endl;
    return 0;
}
