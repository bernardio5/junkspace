/*
 * 3D sprite
 */


#import "mVec3.h"
//#import <OpenGLES/EAGL.h>
//#import <OpenGLES/ES1/gl.h>
//#import <OpenGLES/ES1/glext.h>


typedef struct { 
    mVec3 pos; 
	float p[20];	// position and textures for 4 points
 //   float t[8];
} sgBillboard; 



void bbSet(sgBillboard *b, mVec3 *e, mVec3 *up, mVec3 *p, float sz, int tx, int ty); 

void bbUpdate(sgBillboard *b, mVec3 *e, mVec3 *up, mVec3 *p, float sz); 

/* ********************** drawing */

float bbDoDraw(sgBillboard *b, mVec3 *dir); 


void bbDrawBillboard(sgBillboard *b);
