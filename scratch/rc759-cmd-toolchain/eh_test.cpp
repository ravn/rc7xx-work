#include <iostream>

struct Res {
    const char *name;
    Res( const char *n ) : name( n ) { std::cout << "acquire " << name << std::endl; }
    ~Res() { std::cout << "release " << name << std::endl; }
};

static void deep()
{
    Res r( "deep" );          // its dtor must run during unwind
    throw 5;
}

int main()
{
    try {
        Res r( "main" );
        deep();
        std::cout << "unreachable" << std::endl;
    } catch( int e ) {
        std::cout << "caught " << e << std::endl;
    }
    std::cout << "done" << std::endl;
    return 0;
}
