﻿/*The stars are out there. I'm going to fix the celestial sphere at 20 AU. 1 AU = 149,597,870.7km149597870700 m20 AU  = 2 991 957 414 000 mthree trillion meters. */#import <Foundation/Foundation.h>#import "mVec3.h"// #define AU20 2 991 957 414 000.0// #define EARTH_R 6371.0#define STAR_FAR 18000.0#define NUM_STARS 890@interface star : NSObject {    float ra, dc, mag;     int con;    mVec3 p;     }- (void)reset:(int)con:(float)ra:(float)dc:(float)mag; - (void)getVec:(mVec3 *)p; - (float)getMag; - (int)getCon; @end