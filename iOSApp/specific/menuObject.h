
#import "sprite.h"
#import "gameObject.h"

// number of menu buttons on all screens
#define NUM_BUTTONS 11


@interface menuObject : NSObject {
	sprite menuSpr[NUM_BUTTONS];		// all the menu sprites
	float t; 
	
	int sprVisible[NUM_BUTTONS];
	int whichScreen;		// current screen number
	float gxs[NUM_BUTTONS]; // target positions of the current menu screen
	
	float acc[3];			// current accelerometer readings
	float screenW, screenH, screenS; 
	
	gameObject *theGame;
	sgManager *sgm; 
	NSString *theString; 
}

- (void)takeSGM:(sgManager*)theSGM; 


// set current menu to "toWhat". buttons will be offscreen, 
// but "update" soon will move them into place. 
- (void) changeScreen:(int)toWhat; 

// init is already declared

- (void)update; // draw to active EAGL view; update game state

/// input
- (void)setAccel:(float*)ac; // an array of 3 floats: xyz accelerometer readings

// event types: 1:begin touch, 2:move touch 3:end touch 4:cancel touch(?)
- (void)touchEvent:(float*)ts:(int)nt:(int)evType;


// take screen dimensions from EAGL
- (void)takeScreenDim:(int)wid:(int)height:(float)scaleFactor; 

// if a call to hasNewName rets 1, call "getName"
- (int)hasNewName; 

- (NSString*)getName; 
- (int)getID; 


- (void)getSprite:(int)which:(sprite*)it;

- (void)takeEndTouch:(int)which;

@end
