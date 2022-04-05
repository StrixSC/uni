all: *.o
	g++ -Wall -Wextra -Werror $^ -o build/$@

%.o: %.cpp
	g++ -Wall -Wextra -Werror $< -o build/$@

clean:
	rm -rf *.o *.out build/* main