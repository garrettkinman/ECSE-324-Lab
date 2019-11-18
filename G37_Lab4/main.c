#include <stdio.h>
#include "./drivers/inc/VGA.h"
// TODO: more imports for other drivers

void test_char() {
	int x, y;
	char c = 0;

	for (y = 0; y <= 59; y++) {
		for (x = 0; x <=79; x++) {
			VGA_write_char(x, y, c++);
		}
	}
}