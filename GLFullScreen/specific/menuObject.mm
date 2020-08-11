
#import "menuObject.h"

/*  
 1: title screen: title, start, help, brag
 2: help: help, howto text, video link, go back 
 3: game screen: go back
 */

@implementation menuObject
// link buttons to screens and game start/resume
// which screen do you belong to?
static const int targetScreen[NUM_BUTTONS] = {  1, 1, 1, 1, 1,     2, 2, 2, 2, 2,  3 };
// when clicked, go to what screen? 
static const int nextScreen[NUM_BUTTONS] =  { -1, 3, 2, -1 , -1,   -1, -1, -1, -1, 3,  2   };
// when clicked, say what to the game?  menu-to-game messages :  1:start game 2:jump to video1 
//     3: reset/pause?
static const int gameMessage[NUM_BUTTONS] = {  0, 1, 0, 0, 0,  0,0,0,2,0,  0   };

// what are the onscreen coords? 
// y coords don't change
static const float ys[NUM_BUTTONS] = { 120.0f, 230.0f, 300.0f, 374.0f, 398.0f,   
                            142.0, 184.0f, 226.0f, 292.0f, 366.0f,  32.0f };
// x coords when onscreen
static const float xs[NUM_BUTTONS] = { 16.0f, 16.0f, 46.0f, 110.0f, 120.0f,  
                            16.0f, 16.0, 16.0f, 16.0f, 16.0f,  0.0f};

static const int xsz[NUM_BUTTONS] = { 22, 5, 5, 10, 12, 20, 24, 24, 20, 20,   4  };  // useful!
static const int ysz[NUM_BUTTONS] = { 8, 4, 4, 3, 3,  5, 5, 5, 5, 5,   3  };   // used
static const int tiles[NUM_BUTTONS] = { 0x00, 0x03, 0x05, 0x10, 0x00, 0x0, 0x08, 0x6a, 0x20, 0x03,    0x28, };  // dontcare


- (id)init {
	if ((self = [super init])) {
		int i;
		
		t = 0.0; 
		
		for (i=0; i<NUM_BUTTONS; ++i) { 
			gxs[i] = xs[i]-400.0; // set "goal" x coord to all offscreen
			sprSetPos(&(menuSpr[i]), gxs[i], ys[i]); 
			sprSetSize(&(menuSpr[i]), xsz[i]*30.0f, ysz[i]*16.0f); 
			sprSetMultiTile(&(menuSpr[i]), tiles[i], xsz[i], ysz[i]); 
			
			sprSetRot(&(menuSpr[i]), 0.0f); 
			sprVisible[i] = 1;
		}

		[self changeScreen:3];	
		
		theGame = [[gameObject alloc] init];
	}	
	return self;
}


- (void)takeSGM:(sgManager*)theSGM {
    sgm = theSGM; 
    [theGame takeSGM: theSGM]; 
}


// the per-frame routine does three things:
// 1) it moves buttons towards their goal positions, 
//      if they are not already there
// 2) it calls the update function for "theGame", so they can move.
//      if the game ends, then set screen state to be "game over"
// 3) draws the buttons

- (void)update {
	int i, gameRes;
	
	gameRes = [ theGame update ];
	if ((gameRes==1)&&(whichScreen==4)) { // you got killed
		[self changeScreen:5];
	}

	// then draw menu buttons in front!
	for (i=0; i<NUM_BUTTONS; ++i) { 
		// move out-of-place buttons
		if (menuSpr[i].cx>gxs[i]) { menuSpr[i].cx -= 40.0; }
		if (menuSpr[i].cx<gxs[i]) { menuSpr[i].cx += 40.0; }
		
		if (sprVisible[i]==1) { 
			// sprDraw(&(menuSpr[i])); 
		}
	}
    
}



- (void)setAccel:(float *)a {
	[ theGame takeAccel:a ];
}



// 1:on 2:move 3:off 4:cancelled
- (void)touchEvent:(float*)ts:(int)nt:(int)evType {
	int i, didHandle;
	float gx, gy;	
	
	didHandle = 0; 
    
    
	if (nt>0) { 
		gx = ts[0]; 
		gy = ts[1];
		
		//NSLog(@"num t:%d, evtype:%d", nt, evType); 
		// menu buttons jump only when you release the button
		if (evType==3) { 
            
			for (i=0; i<NUM_BUTTONS; ++i) { 
				if (sprInside(&(menuSpr[i]), gx, gy)) {
					// click the button? 
					if (nextScreen[i]!=-1) { 
						[self changeScreen:nextScreen[i]]; 
					}	
					// is there a message for the game? 
					if (gameMessage[i]!=0) { 
						[theGame takeMessage:(gameMessage[i])]; 
					}				
					didHandle = 1; 
				}
			}
		}
		
		if (didHandle==0) {       
            [theGame takeTouch: evType: ts[0]: ts[1]]; 
            // NSLog(@"ping"); 
		}
	}
}



- (void)changeScreen:(int)newState {
	int i;
	whichScreen = newState;
	for (i=0; i<NUM_BUTTONS; ++i) { 
		gxs[i] = xs[i]-400.0;
		if (newState==targetScreen[i]) { 
			gxs[i] = xs[i];
		}
	}
}






- (void) dealloc {
	free(menuSpr);
}


// pass right thru to SG manager
- (void)takeScreenDim:(int)wid:(int)height:(float)scaleFactor {
    [theGame takeScreenDim: wid: height: scaleFactor]; 
    screenW = (float)wid;
    screenH = (float)height;
    screenS = scaleFactor; 
}


- (int)hasNewName { return [theGame hasNewName]; }
- (NSString*)getName { return [theGame getName]; }
- (int)getID { return [theGame getID]; }

///////// used by viewcontroller to implement the menu with labels instead of sprites

// returns the nth sprite
- (void)getSprite:(int)which:(sprite*)it {
    sprCopy(it, &(menuSpr[which])); 
}

- (void)takeEndTouch:(int)which { 
    //NSLog(@"touch %d", which); 
    
    if (nextScreen[which]!=-1) { 
        [self changeScreen:nextScreen[which]]; 
    }	
    // is there a message for the game? 
    if (gameMessage[which]!=0) { 
        [theGame takeMessage:(gameMessage[which])]; 
    }				
}


@end





