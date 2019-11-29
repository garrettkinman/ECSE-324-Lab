#include <stdio.h>
#include "./drivers/inc/vga.h"
#include "./drivers/inc/ISRs.h"
#include "./drivers/inc/LEDs.h"
#include "./drivers/inc/audio.h"
#include "./drivers/inc/HPS_TIM.h"
#include "./drivers/inc/int_setup.h"
#include "./drivers/inc/wavetable.h"
#include "./drivers/inc/pushbuttons.h"
#include "./drivers/inc/ps2_keyboard.h"
#include "./drivers/inc/HEX_displays.h"
#include "./drivers/inc/slider_switches.h"

#define SCREEN_WIDTH 320

//from note mapping table
//A
#define C_FREQUENCY  130.813   
//S
#define D_FREQUENCY  146.832
//D
#define E_FREQUENCY  164.814
//F
#define F_FREQUENCY  174.614
//J
#define G_FREQUENCY  195.998
//K
#define A_FREQUENCY  220.000
//L
#define B_FREQUENCY  246.942
//:
#define C2_FREQUENCY 261.626

// function to generate the output of a signal of a given frequency at a given time
int generateSignal(float frequency, double time) {
    int index  = (int)(frequency * time) % 48000;

    //calling subroutine wave-table
    return sine[index];
}

int main() {

    // interuppt ID of TIM0 & TIM1
	int_setup(2, (int []){199, 200});

	long time = 0;
    // a struct that is used to configure the different parameters of the HPS time (Tim for our audio)
	HPS_TIM_config_t hps_tim_audio;

	hps_tim_audio.tim = TIM0;
	hps_tim_audio.timeout = 10; // in microsec (faster than keyboerd)
	hps_tim_audio.LD_en = 1; // set to 1 to achieve the desired timeout, or 0 for maximum count of tim
	hps_tim_audio.INT_en = 1; // set to 1 to enable interrupts, or 0 to disable interrupt
	hps_tim_audio.enable = 1; // set to 1 to activate the desired timers, or 0 to deactivate them
    
    // configures the timer instances according to the configuration struct stored at the address in argument param. 
    // multiple timers can be configured via the same struct, and the driver handles the different hardware abstractions internally.
	HPS_TIM_config_ASM(&hps_tim_audio);

    // setting the TIM for keyboard
	HPS_TIM_config_t hps_tim_keyboard;

	hps_tim_keyboard.tim = TIM1;
	hps_tim_keyboard.timeout = 20000;
	hps_tim_keyboard.LD_en = 1;
	hps_tim_keyboard.INT_en = 1;
	hps_tim_keyboard.enable = 1;
    
    HPS_TIM_config_ASM(&hps_tim_keyboard);
    
    int amplitude = 100; //MAX volume

	int a_pressed = 0;
	int s_pressed = 0;
	int d_pressed = 0;
	int f_pressed = 0;
	int j_pressed = 0;
	int k_pressed = 0;
	int l_pressed = 0;
	int semicolon_pressed = 0;

	char *key_data = 0;

    while(1) {
        long sample = 0;
        if(hps_tim1_int_flag){
			hps_tim1_int_flag = 0;
            
             // If there is valid data in the PS/2 FIFO, the value in the data field of the PS2_Dataregister is stored 
            //at the address pointed to by the argument char pointer data, and the function returns a value of 1.
           // If there is no valid data in the PS/2 FIFO, the function simply return 0
			if(read_ps2_data_ASM(key_data)){
                //PS2 Keyboard Scan Codes(make code)
                if (*key_data == 0x1C) { a_pressed = 1; }
                else if (*key_data == 0x1B) { s_pressed = 1; }
                else if (*key_data == 0x23) { d_pressed = 1; }
                else if (*key_data == 0x2B) { f_pressed = 1; }
                else if (*key_data == 0x3B) { j_pressed = 1; }
                else if (*key_data == 0x42) { k_pressed = 1; }
                else if (*key_data == 0x4B) { l_pressed = 1; }
                else if (*key_data == 0x4C) { semicolon_pressed = 1; }
                //to turn volume up or down  
                else if (*key_data == 0x55) { amplitude += 10; } // increase volume
                else if (*key_data == 0x4E) { amplitude -= 10; } // decrease volume
                
                // break code once the key is realesed set is_pressed to zero
                else if (*key_data == 0xF0){
                    while(!read_ps2_data_ASM(key_data));

                    if (*key_data == 0x1C) { a_pressed = 0; }
                    else if (*key_data == 0x1B) { s_pressed = 0; }
                    else if (*key_data == 0x23) { d_pressed = 0; }
                    else if (*key_data == 0x2B) { f_pressed = 0; }
                    else if (*key_data == 0x3B) { j_pressed = 0; }
                    else if (*key_data == 0x42) { k_pressed = 0; }
                    else if (*key_data == 0x4B) { l_pressed = 0; }
                    else if (*key_data == 0x4C) { semicolon_pressed = 0; }
                }
            }
		}

        if(hps_tim0_int_flag){
			hps_tim0_int_flag = 0;
		
			if(a_pressed) {
				sample += generateSignal(C_FREQUENCY, time);
			}
			if(s_pressed) {
				sample += generateSignal(D_FREQUENCY, time);
			}
			if(d_pressed) {
				sample += generateSignal(E_FREQUENCY, time);
			}
			if(f_pressed) {
				sample += generateSignal(F_FREQUENCY, time);
			}
			if(j_pressed) {
				sample += generateSignal(G_FREQUENCY, time);
			}
			if(k_pressed) {
				sample += generateSignal(A_FREQUENCY, time);
			}
			if(l_pressed) {
				sample += generateSignal(B_FREQUENCY, time);
			}
			if(semicolon_pressed) {
				sample += generateSignal(C2_FREQUENCY, time);
			}

			sample *= amplitude;
            
			// If there is space in both the left-channel and right-channel write FIFOs, then the value in the arguments leftdata and rightdata 
			// is written to the Leftdata and Rightdata registers respectively, and the function returns a value of 1.
			// If there is no space in either one of the FIFOs, the functions simply returns 0
			if(audio_write_data_ASM(sample, sample)) {
				time++;
			}
			
		}
	}
	

	return 0;
}




