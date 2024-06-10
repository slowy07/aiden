CC = gcc
CFLAGS = -Iunity
all: install_unittest testing_result
testing_result:
	$(CC) $(CFLAGS) -o testing_result test/main_test.c Unity/src/unity.c
install_unittest:
	git clone https://github.com/ThrowTheSwitch/Unity


# ! DO NOT CHANGE
clean:
	rm -rf testing_result
	rm -rf Unity
