/*
 modes: sell/play, play/regular,  game over?
 */

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


#import "sgManager.h"

#import "sprite.h"
#import "starSource.h" 
#import "satSource.h"
#import "eearth.h"



/// comment out to use accel/compass. 
/// #define USE_TOUCH 1



@interface gameObject : NSObject <CLLocationManagerDelegate> {
    float touchDX, touchStartX, touchDY, touchStartY, startingHead, startingOri; 
    float scx, scy; /// where the screen is; 
    
    // from GPS and compass
    CLLocationManager *locMan; 
    float lat, lon;
    int isVert, isLookingUp; 
    float orientationAngle, lastHeading; 
    float heading, turnsAdded; 
    
    eearth *theEearth;
    // sanity-checkers
    int horiz[70];
    
    starBall *theStars;
    starSource *theStarSource;
    satBall *theSats;
    satSource *theSatSource; 
    double yearFract; 
    
    sgManager *sgm; 
    int GPSIsOn; 
    
	int gameMode;	
	int modeTimer; // timer for fake player explosions

    int speedup;
    int showStars;
    int showHorizon;
    int settingsFlag; 
}


@property (nonatomic, retain) CLLocationManager *locMan;


- (void)takeSGM:(sgManager*)theSGM; 


// operate game and redraw visual elements
- (int)update;

// - (void)changeMode:(int)which;

// many messages; see menuObject.m for the list
- (void)takeMessage:(int)which;

// set difficulty by setting the starting time
- (void)setStartTime:(float)toWhat;

// do all control from acclerometer. nice!
- (void)takeAccel:(float*)xyz;

- (void)takeTouch:(int)type:(float)tx : (float)ty;

// take screen dimensions from EAGL
- (void)takeScreenDim:(int)wid:(int)height:(float)scaleFactor;

- (void)takeSettings: (bool)st: (bool)ho: (int)sup;

// if a call to hasNewName rets 1, call "getName"
- (int)hasNewName; 

- (NSString*)getName; 
- (int)getID; 

@end
