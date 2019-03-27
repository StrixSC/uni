CXX = g++
INCLUDES = -I./
CXXFLAGS = -g $(INCLUDES)
SRCM = rabais_test.cpp
OBJM = $(SRCM:.cpp=.o)
LINKFLAGS = -lcppunit

test: main.o
		g++ $(CXXFLAGS) -o $@ main.o 

main.o: main.cpp $(SRCM) rabais_test.h
		$(CXX) $(CXXFLAGS) -o $@ -c main.cpp $(SRCM) 
