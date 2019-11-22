#include <stdio.h>
#include "./drivers/inc/vga.h"
#include "./drivers/inc/slider_switches.h"
#include "./drivers/inc/pushbuttons.h"
#include "./drivers/inc/ps2_keyboard.h"

void test_char() {
	int x, y;
	char c = 0;

	for(y = 0; y <= 59; y++) {
		for(x = 0; x <= 79; x++) {
			VGA_write_char_ASM(x, y, c++);
		}
	}
}

void test_byte() {
	int x, y;
	char c = 0;

	for(y = 0; y <= 59; y++) {
		for(x = 0; x <= 79; x += 3) {
			VGA_write_byte_ASM(x, y, c++);
		}
	}
}

void test_pixel() {
	int x, y;
	unsigned short color = 0;

	for(y = 0; y <= 239; y++) {
		for(x = 0; x <= 319; x++) {
			VGA_draw_point_ASM(x, y, c++);
		}
	}
}

int main() {
	VGA_clear_charbuff();
	VGA_clear_pixelbuff();

	while(1) {
		// TODO: test depending on which pushbutton is pressed
	}
}
