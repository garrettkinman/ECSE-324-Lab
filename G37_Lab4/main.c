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
		if(read_PB_data_ASM() == PB0){
			if(read_slider_switches_ASM() > 0){
				test_byte();
			}
			else if(read_slider_switches_ASM() == 0){
				test_char();
			}
		}
		else if(read_PB_data_ASM() == PB1){
			test_pixel();
		}
		else if(read_PB_data_ASM() == PB2){
			VGA_clear_charbuff_ASM();
		}
		else if(read_PB_data_ASM() == PB3){
			VGA_clear_pixelbuff_ASM();
		}
	}

	/*
	int x = 0, y = 0, v = 0;
	char *data; // we declare a data pointer to which the keyboard data will be stored
	char c;
	data = &c;
	while(1){
		v = read_PS2_data_ASM(data); 	// we read the data from the keyboard to see if the data is valid
		if(v == 1){ 						// if a key hasn't been pressed, we keep repeating the current loop iteration
			VGA_write_byte_ASM(x,y,c); // once a key has been pressed and the data has been read, we write it to the screen
			x += 3;	
		}
		if(x >= 79){
			x = 0;
			y++;	
		}
		if(y >= 59)
			y=0;
	}
	*/
	return 0;
}
