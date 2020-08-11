/*
 there is only one gameObject
 
 there are three modes for the game object
 0- displaying horizontally, one screen -- startup and Zero1, one screen
 1- displaying vertically, one screen -- ISEA
 2- displaying horizontally, one screen -- zero1, two screens
 
 for the first one, no changes. 
 for the second one, the only change is a 90 ccw rotation of the up vector? 
 
 for the third, 
    there are two eearths, one for each heading
        they maintain the two cameras
    sats and stars are the same
    there are two drawing functions, 
 
 */

#import <Cocoa/Cocoa.h>

#import "sgManager.h"

#import "satSource.h"
#import "eearth.h"



/// comment out to use accel/compass. 
/// #define USE_TOUCH 1



@interface gameObject : NSObject {
    float touchDX, touchStartX, touchDY, touchStartY, startingHead, startingOri; 
    float scx, scy; /// where the screen is; 
    
    // from GPS and compass
    int isVert, isLookingUp; 
    
    eearth *theEearth, *earth2;
    // sanity-checkers
    int sunBoard, northwards, eastwards, westwards, upwards, VEwards; 
    int horiz[64]; 
    
    // black panels to crop top and bottom? or view thingies? eh. 
    int topBlock, botBlock; 
    
    satBall *theSats;
    satSource *theSatSource; 
    double yearFract; 
    
    // sgManager *sgm; 
    int GPSIsOn; 
    
	int gameMode;	// 0=horizontal, in window  1=>isea (rotated 90 ccw)  2=>
	int modeTimer; // timer for fake player explosions
    
    sgManager *sgm; 
}



- (void)takeSGM:(sgManager*)theSGM; 

// set camera position and direction relative to Earth
- (void)setPos:(float)lat:(float)lon:(float)heading:(float)inclination; 
- (void)setPos2:(float)lat:(float)lon:(float)heading:(float)inclination; 


// get camera settings in Universe Coords. 
- (void)getCamera:(mVec3*)p:(mVec3*)u:(mVec3*)c;


// move satellites and redraw using theEearth
- (void)update;



// 
- (void)takeMessage:(int)which;

// set difficulty by setting the starting time
- (void)setStartTime:(float)toWhat;

// if a call to hasNewName rets 1, call "getName"
- (int)hasNewName; 

- (NSString*)getName; 
- (int)getID; 




@end
