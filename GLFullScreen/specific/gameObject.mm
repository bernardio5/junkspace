#import "gameObject.h"
#import "mVec3.h"

@implementation gameObject




- (id)init {    
	if ((self = [super init])) {
		gameMode = 0;
		modeTimer = -1; 
        yearFract = 0.0; 
        
        // so's we can know where and when it is
        theEearth = [[eearth alloc] init]; 
        [theEearth update: 0.0]; 
        // HEY! FUCKING IDIOT! MONKEY WITH RATE ON THE OTHER ONE! THANKS!
        
        earth2 = [[eearth alloc] init]; 
        [earth2 update:0.0]; 
    }
    return self;
}



- (void)takeSGM:(sgManager*)theSGM {
    // int i;
    mVec3 ground, viewUp, viewDir, sunPos, spare, dueNorth, dueEast; 
    float sz;
    
    sgm = theSGM; 
    
    [theEearth getPUD:&ground:&viewUp:&viewDir]; 
    mvSetf(&ground, 0.0, 0.0, -1.0); 
    mvSetf(&viewUp, 0.0, 0.0, -2.0); 
    mvSetf(&viewDir, 0.0, 1.0, 0.0); 
    sz = 2.0; 
    [sgm setCameraPUD :&ground :&viewUp: &viewDir];
    
    //[theEearth getSun: &sunPos];
    // northwards, eastwards, upwards, VEwards
    //mvCopy(&spare, &viewDir);
    //mvScale(&spare, 500.0);
    //mvAddEq(&spare, &ground);
    //sunBoard = [sgm addBillboard: &spare: 400.0: 13: 0];
    
    
    //[ theEearth getNE: &dueNorth: &dueEast];
    mvScale(&dueNorth, 1000.0); 
    mvEqAdd(&spare, &ground, &dueNorth); 
    ///northwards = [sgm addBillboard:&spare: 160.0: 0: 0];

    mvScale(&dueEast, 1000.0); 
    mvEqAdd(&spare, &ground, &dueEast); 
    //eastwards = [sgm addBillboard: &spare: 160.0: 1: 0];

//    mvCopy(&spare, &ground);  
//    mvScale(&spare, 2.0);  
//    upwards = [sgm addBillboard: &spare: 160.0: 5: 0];
    
    mvCopy(&spare, &ground);  
    mvScale(&spare, 2.0);  
    //westwards = [sgm addBillboard: &spare: 160.0: 2: 0];
    
    mvSetf(&spare, 0.0, 0.0, 7000.0); 
    //VEwards = [sgm addBillboard: &spare: 160.0: 3: 0];

    //for (i=0; i<64; ++i) {
      //  horiz[i] = [sgm addBillboard: &spare: 160.0: 4:0];
   // }
    

    
    theSats = [[satBall alloc] init];
    [theSats setup: sgm]; 
    
    theSatSource = [[satSource alloc] init];
    [theSatSource parse: theSats];
}





- (void)setPos:(float)lat:(float)lon:(float)heading:(float)inclination {
    [theEearth takeLatLon: lat:lon]; 
    [theEearth takeHeading: heading]; 
    [theEearth takeIncline: inclination]; 
    
}



- (void)setPos2:(float)lat:(float)lon:(float)heading:(float)inclination {
    [earth2 takeLatLon: lat:lon];
    [earth2 takeHeading: heading];
    [earth2 takeIncline: inclination];
    
   
    
}



- (void)takeMessage:(int)which {
    gameMode = which; 
    switch (which) { 
        case 0: 
            [theEearth takeLatLon: 37.335277: 121.89194]; // san jose, 1 screen
            //[theEearth takeHeading: 0.0];
            //[theEearth takeIncline: 10.0];
            break; 
        case 1: 
            [theEearth takeLatLon: 35.1108333: 106.61]; // albaquerque
            //[theEearth takeHeading: 0.0];
            //[theEearth takeIncline: 10.0];
            break; 
        case 2: 
            [theEearth takeLatLon: 37.335277: 121.89194]; // san jose
            //[theEearth takeHeading: 0.0];
            //[theEearth takeIncline: 10.0];
            
            [earth2 takeLatLon: 37.335277: 121.89194]; // san jose
            //[earth2 takeHeading: 180.0];
            //[earth2 takeIncline: 10.0];
            break; 
            
    }
}




- (void)takeTouch:(int)type:(float)tx:(float)ty {
    
}


- (void)getCamera:(mVec3*)p:(mVec3*)u:(mVec3*)c {
    mVec3 gr, up, dir, coi, spare; 
    [theEearth getPUD: &gr: &up: &dir]; 
    if (gameMode==1) { // rotate up
        mvEqCross(&spare, &dir, &up); 
        mvNormalize(&spare); 
        NSLog(@"u  %f %f %f   d %f %f %f   s %f %f %f", up.x, up.y, up.z, dir.x, dir.y, dir.z, spare.x, spare.y, spare.z); 
        mvCopy(&up, &spare);
        
    }
    mvCopy(p, &gr); 
    mvCopy(u, &up); 
    mvEqAdd(&coi, &gr, &dir); 
    mvCopy(c, &coi); 
}





// operate game and redraw visual elements
- (void)update {
//	int  i;
    double time;//,dtheta, theta;
    mVec3 ground, viewUp, viewDir, sunPos, dueNorth, dueEast, spare;//, acr, nor;
    
   // NSLog(@"game update"); 
    [theEearth update: 0.033333]; //.25*86400.0]; // YESSS. THIS! IS THE ONE
    [theEearth getPUD: &ground: &viewUp: &viewDir]; 
    time = [theEearth getDayOfYear]; 
    
    //[sgm start3D]; 
    
    [sgm setCameraPUD: &ground: &viewUp: &viewDir];
    
    // add billboards fro sprites loaded since last time? 
    [theSats update: time];
    
//    [theEearth getSun: &sunPos];
    //mvCopy(&spare, &viewDir);
    //mvScale(&spare, 500.0);
    //mvAddEq(&spare, &ground);
    //[sgm updateBillboard: sunBoard: &spare: 20.0];
    
     [ theEearth getNE: &dueNorth: &dueEast]; 
    mvScale(&dueNorth, 1000.0); 
    mvScale(&dueEast, 1000.0); 
    
    mvEqAdd(&spare, &ground, &dueNorth); 
    //[sgm updateBillboard: northwards: &spare: 50.0];
    
    mvEqAdd(&spare, &ground, &dueEast); 
    //[sgm updateBillboard: eastwards: &spare: 50.0];
    /*
    dtheta = M_PI/32.0; 
    for (i=0; i<64; ++i) { 
        theta = dtheta *i; 
        mvCopy(&acr, &dueEast); 
        mvScale(&acr, sin(theta)); 
        mvCopy(&nor, &dueNorth); 
        mvScale(&nor, cos(theta));
        
        mvEqAdd(&spare, &ground, &acr); 
        mvAddEq(&spare, &nor); 
        
        [sgm updateBillboard: horiz[i]: &spare: 50.0]; 
    }
    */

    
    mvEqSub(&spare, &ground, &dueEast); 
    //[sgm updateBillboard: westwards: &spare: 50.0];
    
    // mvCopy(&spare, &ground);  
    // mvScale(&spare, 1.4);  
    // [sgm updateBillboard: upwards: &spare: 50.0];
    
    mvSetf(&spare, 0.0, 0.0, 1000.0); 
    mvAddEq(&spare, &ground); 
    //[sgm updateBillboard: VEwards: &spare: 50.0];
    
    [sgm redraw];

}



- (void)setStartTime:(float)toWhat {
}






- (int)hasNewName {  
    mVec3 ground, viewUp, viewDir; 
    [theEearth getPUD: &ground: &viewUp: &viewDir]; 
    return [theSats hasNewName: &ground: &viewDir]; 
}



- (NSString*)getName { 
    return [theSats getName]; 
}


- (int)getID { 
    return [theSats getID]; 
}




@end
