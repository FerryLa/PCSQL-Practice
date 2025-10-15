#include <iostream>

int main() {
    int number;
std::cin >> number;

int answer = 0;
while (number > 0) {
answer += number % 100;
number /= 100;
}
std::cout << answer << std::endl;
}
