CC = gcc
CFLAGS = -Iunity
all: install_unittest testing_result
testing_result: test/test_errno.c Unity/src/unity.c
	$(CC) $(CFLAGS) -o testing_result test/test_errno.c Unity/src/unity.c
install_unittest:
	git clone https://github.com/ThrowTheSwitch/Unity


# ! DO NOT CHANGE
clean:
	rm -rf testing_result
	rm -rf Unity
