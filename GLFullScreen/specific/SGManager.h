
// Neal McDonald 2009

// owner of the scene graph
// traverses for rendering, updates for animation, deletes, optimizes?

 // in this version, it's only here to draw billboards
 
 
#import "mVec3.h"
#import "SGBillboard.h"
#import <OpenGL/gl.h>


#define MAX_BILLS 12000




@interface sgManager : NSObject {
    mVec3 up, dir, COI, eyept; 

	sgBillboard bills[MAX_BILLS];
    int depthPlace[MAX_BILLS];
    int billCt;
    
    int doFirstSort; 
    	
}  


- (int) addBillboard:(mVec3*)pos :(float) sz :(int) tx:(int)ty;
- (void) updateBillboard:(int)which:(mVec3*)pos:(float)sz;


// if you're not giving all 3 all the time, you're a putz, apparently
- (void) setCameraPUD:(mVec3*)pos:(mVec3*)up:(mVec3*)dir;


// redraw everything in 3D
- (void) redraw; // redraw everything! 

@end

