//
//  ViewController.h
//  junkspace8
//
//  Created by Neal McDonald on 8/14/12.
//  Copyright (c) 2012 Neal McDonald. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

#import "SGManager.h"
#import "gameObject.h"


@interface ViewController : GLKViewController <UIAccelerometerDelegate> {
    int textIsOn; 
    sgManager *sgm;
    gameObject *theGame;
    float width, height;
   
    // 0->1, what %age of available sats to show. 
    int frameCounter;
}

- (void)takeSettings: (bool)st: (bool)ho: (int)sup;

@property(nonatomic, retain) IBOutlet UIImageView *thePic;   // image of help
@property(nonatomic, retain) IBOutlet UIButton *theLabel;   // label that changes a lot
@property(nonatomic, retain) IBOutlet UIButton *jumperBut;   // button going to internets

- (IBAction)showTexty;
- (IBAction)jumpToFilm;
- (IBAction)jumpToSatData;

@end
