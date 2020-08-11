/*
 * 3D sprite
 */


#import "mVec3.h"
#import <OpenGL/gl.h>


typedef struct { 
    mVec3 pos;
    double depthSq;
	float p[12];	// position and textures for 4 points
    float t[8];
} sgBillboard; 


void bbSet(sgBillboard *b, mVec3 *e, mVec3 *up, mVec3 *p, float sz, int tx, int ty);

void bbUpdate(sgBillboard *b, mVec3 *e, mVec3 *up, mVec3 *viewDir, mVec3 *p, float sz);

/* ********************** drawing */

float bbDoDraw(sgBillboard *b, mVec3 *dir); 

void bbDrawBillboard(sgBillboard *b);
