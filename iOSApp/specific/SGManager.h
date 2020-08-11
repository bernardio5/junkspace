
// Neal McDonald 2009

// owner of the scene graph
// traverses for rendering, updates for animation, deletes, optimizes?

 
 
 
#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
 
#import <UIKit/UIKit.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import "mVec3.h"
#import "SGBillboard.h"


#define MAX_BILLS 12000

@interface sgManager : NSObject {
    mVec3 up, dir, COI, eyept; 
    float xrez, yrez, scale; 
	float near, far, angle; 
    
    
    GLKBaseEffect *effect;
    GLKTextureInfo *texture;
    
	sgBillboard bills[MAX_BILLS];
    int billShow[MAX_BILLS]; 
    int billCt; 
    	
	mVec3 bgColor; 
	
	int theTexture; 
}  


- (void)loadTexture:(NSString*)fname;
- (void)useTexture:(int)asWhich; 

// screen rez defaults to 320x480. want more? call me. 
- (void) setScreen:(int)wid:(int)height:(int)speedSwitch;
- (int) getWidth;
- (GLKBaseEffect *)getEffect;

// void sgmAddVert(sgManagerPtr p, short which, :(mVec3*)pos, :(mVec3*)uv);

- (int) addBillboard:(mVec3*)pos :(float) sz :(int) tx:(int)ty;
- (void) updateBillboard:(int)which:(mVec3*)pos:(float)sz;
- (void) hideBillboard:(int)which;
- (void) unhideBillboard:(int)which;

// if you're not giving all 3 all the time, you're a putz, apparently
- (void) setCameraPUD:(mVec3*)pos:(mVec3*)up:(mVec3*)dir;

// call before setting up camera
- (void) start3D; 

// redraw everything in 3D
- (void) redraw; // redraw everything! 

@end

