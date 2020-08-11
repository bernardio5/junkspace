#import "gameObject.h"
#import "mVec3.h"

@implementation gameObject

@synthesize locMan;      



////////////////////////////////////////////////////////////////// CLocationManager interface
// user location changed, didn't it. 
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation {
	lat = newLocation.coordinate.latitude;
	lon = newLocation.coordinate.longitude;
    lat *= M_PI/ 180.0; 
    lon *= M_PI/ 180.0; 
    [theEearth takeLatLon: lat: lon]; 
}



/// didn't allow whatever..
- (void)locationManager:(CLLocationManager *)manager
	   didFailWithError:(NSError *)error {
	if (error.code == kCLErrorDenied) {
        [[[UIAlertView alloc] initWithTitle:@"Location Services Disabled"
                                    message:@"This app will not work without them; if you change your mind, enable location services in the Settings dialog."
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
		GPSIsOn = 0;
       lat = 0.0;
        lon = 0.0; 
		[self.locMan stopUpdatingLocation];
	}
}
#ifndef USE_TOUCH
- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    heading = [newHeading trueHeading] * M_PI / 180.0;
    [theEearth takeHeading:heading]; 
}

#endif


// pass right thru to SG manager
- (void)takeSettings:(bool)st:(bool)ho:(int)sup {
    showStars = 0;
    if (st==YES) { showStars=1; }
    showHorizon = 0;
    if (ho==YES) { showHorizon=1; }
    speedup = sup;
    settingsFlag = 1;
}


- (void)useSettings {
    int i;
    if (showStars==1) {
        [theStars showStars];
    } else {
        [theStars hideStars];
    }
    
    if (showHorizon==1) {
        for (i=0; i<69; i++) {
            [sgm unhideBillboard: horiz[i]];
        }
    } else {
        for (i=0; i<69; i++) {
            [sgm hideBillboard: horiz[i]];
        }
    }
    
    
    [theSats takeFract: speedup];
    //NSLog(@" %d %d %d", showStars, showHorizon, speedup);
    //for (i=0; i<69; i+=6) {
    //    NSLog(@"%d %d    %d %d    %d %d", horiz[i+0], horiz[i+1], horiz[i+2], horiz[i+3], horiz[i+4], horiz[i+5]);
    //}
}




- (void)takeAccel:(float*)xyz {
    float ox, oy, oz;
    float len, goalAngle, dif;

    ox = xyz[0];
    oy = xyz[1]; 
    oz = xyz[2];
    
    // normalize and get angle
    len = sqrt(oy*oy+oz*oz);
    if (len<0.0001) {
        goalAngle = 0.0;
    } else {
        oz *= 1.0/len;
        goalAngle = -asin(oz);
    }
    
    dif = (goalAngle - orientationAngle)*0.2;
    orientationAngle += dif;
    
    
    [theEearth takeIncline: orientationAngle];
}



- (id)init {    
	if ((self = [super init])) {
		if([CLLocationManager locationServicesEnabled]) {
            self.locMan = [[CLLocationManager alloc] init];
            self.locMan.delegate = self;
            [self.locMan startUpdatingLocation];
            [self.locMan startUpdatingHeading];
        } else {
            [[[UIAlertView alloc] initWithTitle:@"Location Services Disabled"
                                         message:@"This app will not work without them; if you change your mind, enable location services in the Settings dialog."
                                       delegate:nil
                               cancelButtonTitle:@"OK"
                               otherButtonTitles:nil] show];
        }
               

        GPSIsOn = 1; 
        lat = 0.0; 
         lon = 0.0; 
        orientationAngle = 0.0; 
        heading = 0.0; 
        lastHeading = 0.0;
        turnsAdded = 0.0; 

		gameMode = 0;
		modeTimer = 0;
        
        yearFract = 0.0; 
        
        // so's we can know where and when it is
        theEearth = [[eearth alloc] init]; 
        [theEearth update: 0.0]; 
        // HEY! FUCKING IDIOT! MONKEY WITH RATE ON THE OTHER ONE! THANKS!
        
        speedup = 100;
        showStars = 1;
        showHorizon = 1;
        settingsFlag = 0; 
    }
    return self;
}



- (void)takeSGM:(sgManager*)theSGM {
    int i;
    mVec3 ground, viewUp, viewDir, sunPos, spare, dueNorth, dueEast; 
    float sz;
    
    sgm = theSGM; 
    
    [theEearth getPUD:&ground:&viewUp:&viewDir]; 
    mvSetf(&ground, 0.0, 0.0, -1.0); 
    mvSetf(&viewUp, 0.0, 0.0, -2.0); 
    mvSetf(&viewDir, 0.0, 1.0, 0.0); 
    sz = 2.0; 
    [sgm setCameraPUD :&ground :&viewUp: &viewDir];
    
    [theEearth getSun: &sunPos]; 
    horiz[0] = [sgm addBillboard: &sunPos: 160.0: 9: 0];
    
    [ theEearth getNE: &dueNorth: &dueEast]; 
    mvScale(&dueNorth, 1000.0); 
    mvEqAdd(&spare, &ground, &dueNorth); 
    horiz[1] = [sgm addBillboard:&spare: 160.0: 0: 0];

    mvScale(&dueEast, 1000.0); 
    mvEqAdd(&spare, &ground, &dueEast); 
    horiz[2] = [sgm addBillboard: &spare: 160.0: 1: 0];
    
    mvCopy(&spare, &ground);  
    mvScale(&spare, 2.0);  
    horiz[3] = [sgm addBillboard: &spare: 160.0: 2: 0];
    
    mvSetf(&spare, 0.0, 0.0, 7000.0); 
    horiz[4] = [sgm addBillboard: &spare: 160.0: 3: 0];

    for (i=5; i<69; ++i) {
       horiz[i] = [sgm addBillboard: &spare: 160.0: 4:0];
    }
    

    theStars = [[starBall alloc] init];
    [theStars setup: sgm]; 

    theStarSource = [[starSource alloc] init];
    [theStarSource parse: theStars]; 
    
    
    theSats = [[satBall alloc] init];
    [theSats setup: sgm]; 
    
    theSatSource = [[satSource alloc] init];
    [theSatSource parse: theSats];
    
    [self useSettings]; 
   // NSLog(@"hello");
}







// mesages: 1:set difficulty 2:video1 3:vid2  5 reset
- (void)takeMessage:(int)which {
	// NSLog(@"game takeMessage %d", which); 
	switch (which) { 
		case 0: // go to display mode
           // [self resetter]; 
			break; 
		case 1: // go to play mode
           // [self starter]; 
			break; 
		case 2: // video 1
			[[UIApplication sharedApplication] openURL:[NSURL 
				URLWithString:@"http://www.junkspace.org"]];
			break; 
	}
}




- (void)takeTouch:(int)type:(float)tx:(float)ty {
    int stopping; 

    touchDX = 0.0;
    touchDY = 0.0; 
    stopping = 0; 
    
    switch (type) { 
        case 1: 
            touchStartX = tx; 
            touchStartY = ty; 
            startingOri = orientationAngle; 
            startingHead = heading; 
            break; 
            
        case 2: 
            touchDX = tx - touchStartX; 
            touchDY = ty - touchStartY; 
            break;
            
        case 3:
            touchDX = tx - touchStartX; 
            touchDY = ty - touchStartY; 
            stopping = 1; 
            break; 
    }
    
    
#ifdef USE_TOUCH
    if (stopping==1) {
        if ((touchDX*touchDX+touchDY*touchDY)<20.0) { 
            // it was a tap; reset
            orientationAngle = 0; 
            heading = 0; 
            stopping =0; 
        } else stopping = 2; 
    } else stopping = 2; 
    
    if (stopping==2) { 
        orientationAngle = startingOri - touchDY/60.0;  
        heading = startingHead + touchDX/60.0; 
    }
    
    [theEearth takeHeading:heading]; 
    [theEearth takeIncline: orientationAngle]; 

    // NSLog(@"stXY %f %f  dXY %f %f   re o h %f %f", touchStartX, touchStartX, touchDX, touchDY, orientationAngle, heading); 

#endif
    
}






// operate game and redraw visual elements
- (int)update {
	int  res, i;
    double time,dtheta, theta; 
    mVec3 ground, viewUp, viewDir, sunPos, dueNorth, dueEast, spare, acr, nor; 
    
    res = 0; 
    ++modeTimer;
    if (settingsFlag ==1) {
        [self useSettings];
        settingsFlag = 0; 
    }
    [theEearth update: 0.033333]; //.25*86400.0]; // YESSS. THIS! IS THE ONE
    [theEearth getPUD: &ground: &viewUp: &viewDir];
    
    time = [theEearth getDayOfYear]; 
    // NSLog(@"game update %f" , time);
   
    [sgm start3D]; 
    
    [sgm setCameraPUD: &ground: &viewUp: &viewDir];
    if (showStars==1) {
        [theStars update: &ground];
    }
    
    // add billboards fro sprites loaded since last time? 
    [theSats update: time];
    
    [theEearth getSun: &sunPos]; 
    if (showHorizon==1) {
        [sgm updateBillboard: horiz[0]: &sunPos: 550.0];
        
        [ theEearth getNE: &dueNorth: &dueEast];
        mvScale(&dueNorth, 1000.0); 
        mvScale(&dueEast, 1000.0); 
        
        mvEqAdd(&spare, &ground, &dueNorth); 
        [sgm updateBillboard: horiz[1]: &spare: 50.0];
        
        mvEqAdd(&spare, &ground, &dueEast); 
        [sgm updateBillboard: horiz[2]: &spare: 50.0];
    
        dtheta = M_PI/32.0;
        for (i=0; i<64; ++i) { 
            theta = dtheta *i; 
            mvCopy(&acr, &dueEast); 
            mvScale(&acr, sin(theta)); 
            mvCopy(&nor, &dueNorth); 
            mvScale(&nor, cos(theta));
            
            mvEqAdd(&spare, &ground, &acr); 
            mvAddEq(&spare, &nor); 
            
            [sgm updateBillboard: horiz[i+5]: &spare: 50.0];
        }
    
        mvEqSub(&spare, &ground, &dueEast);
        [sgm updateBillboard: horiz[3]: &spare: 50.0];
        
        mvSetf(&spare, 0.0, 0.0, 1000.0); 
        mvAddEq(&spare, &ground); 
        [sgm updateBillboard: horiz[4]: &spare: 50.0];
    }
    
    [sgm redraw];
    
	return res;
}



- (void)setStartTime:(float)toWhat {
}





// pass right thru to SG manager
- (void)takeScreenDim:(int)wid:(int)height:(float)scaleFactor {
    [sgm setScreen: wid: height: scaleFactor];
    
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
