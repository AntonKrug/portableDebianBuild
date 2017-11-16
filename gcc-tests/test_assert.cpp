#include <type_traits>
#include <iostream>
 
struct A {
 int foo;
};
 
struct B {
 int foo = 0;
};
 
template <typename T>
void print(const T& a){
 static_assert(std::is_pod<T>::value);
 std::cout << a.foo << '\n';
}
 
int main() {
 A x{1};
 B y{2};
 B z;
 
 print<A>(x);
 print<B>(y);
 print<B>(z);
 
 return 0;
}