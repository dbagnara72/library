/*
 * SPDX-License-Identifier: MIT
 * Copyright (c) 2025 Davide Bagnara
 */

/* six pulses rectifier */

#include <math.h>
#include <math_f.h>


typedef struct sprc_s {
    float ramp_1; float ramp_2; float ramp_3; 
	float ramp_4; float ramp_5; float ramp_6;  
	
	int synch_A1; int synch_A2; int synch_A3; 
	int synch_A4; int synch_A5; int synch_A6;	
	
	int synch_B1; int synch_B2; int synch_B3; 
	int synch_B4; int synch_B5; int synch_B6;

	int synch_1; int synch_2; int synch_3;
	int synch_4; int synch_5; int synch_6;
} sprc_t;

typedef struct spr_p_s {
	int p1;
	int p2;
	int p3;
	int p4;
	int p5;
	int p6;
} spr_p_t;

float sprcProcess(sprc_t *spr, const float wt, const float alpha, const int block, spr_p_t *p);

void sprcProcessSimulink(const float wt, const float alpha, const int block, spr_p_t *p);
