//
//  ViewController.m
//  junkspace8
//
//  Created by Neal McDonald on 8/14/12.
//  Copyright (c) 2012 Neal McDonald. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () {
    GLuint _program;
    
    GLKMatrix4 _modelViewProjectionMatrix;
    GLKMatrix3 _normalMatrix;
    float _rotation;
    
    GLuint _vertexArray;
    GLuint _vertexBuffer;
}

@property (strong, nonatomic) EAGLContext *context;
@property (strong, nonatomic) GLKBaseEffect *effect;


@end



@implementation ViewController

@synthesize thePic, theLabel, jumperBut;
@synthesize context = _context;
@synthesize effect;


- (void)moveTextOff {
    int size = thePic.frame.size.width+80;
    if (textIsOn==1) {
        [UIView beginAnimations:@"animateImageOff" context:NULL];
        [thePic setFrame:CGRectOffset([thePic frame], -size, 0)];
        [UIView commitAnimations];
        
        [UIView beginAnimations:@"animateButtonOff" context:NULL];
        [jumperBut setFrame:CGRectOffset([jumperBut frame], -size, 0)];
        [UIView commitAnimations];
        textIsOn = 0;
        //NSLog(@"oofff");
    }
    
}


- (void)moveTextOn {
    int size = thePic.frame.size.width+80;
    if (textIsOn==0) {
        [UIView beginAnimations:@"animateImageOn" context:NULL];
        [thePic setFrame:CGRectOffset([thePic frame], size, 0)];
        [UIView commitAnimations];
        
        [UIView beginAnimations:@"animateButtonOn" context:NULL];
        [jumperBut setFrame:CGRectOffset([jumperBut frame], size, 0)];
        [UIView commitAnimations];
        textIsOn = 1;
        //NSLog(@"on");
    }
}

- (void)takeSettings: (bool)st: (bool)ho: (int)sup {
    [theGame takeSettings: st: ho: sup];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];

    if (!self.context) {
        NSLog(@"Failed to create ES context");
    }
    
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    [EAGLContext setCurrentContext:self.context];
        
    //// accelerometer
    //[[UIAccelerometer sharedAccelerometer] setUpdateInterval:(1.0f / 30.0f)];
	//[[UIAccelerometer sharedAccelerometer] setDelegate:self];
    
    // //////////////////////////////////////// Neal's
    sgm = [[sgManager alloc] init];
    width = view.bounds.size.width;
    height = view.bounds.size.height;
    int hwFactor; // set speedup to change pano resolutions
    hwFactor = 1;
    int w = (int)width;
    switch (w) {
        case 320: hwFactor = 1; break;  // old pod/phone
        case 640: hwFactor = 2; break;  // retina pod/phone
        case 768: hwFactor = 3; break;  // pad 1 or 2
        case 1536: hwFactor = 4; break; // pad 3
    }
    [sgm setScreen:width:height:hwFactor];
    
    //
    theGame = [[gameObject alloc] init];
    [theGame takeSGM: sgm];
    
    effect = [sgm getEffect];
    
    textIsOn = 1; 
    [self moveTextOff];
    
    //frameCounter = 0;
}



- (void)viewDidUnload {    
    [super viewDidUnload];
    
    [self tearDownGL];
    // [theGame shutoff];
    if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
    }
	self.context = nil;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIAccelerometer sharedAccelerometer] setUpdateInterval: 0.03];
    [[UIAccelerometer sharedAccelerometer] setDelegate: self];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[UIAccelerometer sharedAccelerometer] setDelegate: nil];
    [super viewWillDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration {
	float acc[3];
	acc[0] = acceleration.x;
	acc[1] = acceleration.y;
	acc[2] = acceleration.z;
    [theGame takeAccel:acc];
}




- (void)tearDownGL {
    [EAGLContext setCurrentContext:self.context];
    
    glDeleteBuffers(1, &_vertexBuffer);
    glDeleteVertexArraysOES(1, &_vertexArray);
    
    self.effect = nil;
    
    if (_program) {
        glDeleteProgram(_program);
        _program = 0;
    }
}




#pragma mark - GLKView and GLKViewController delegate methods

- (void)update {
    //++frameCounter;
    //if ((frameCounter%100)==0) { NSLog(@"100"); }
    
    if ([theGame hasNewName]==1) {
        [self.theLabel setTitle: [theGame getName]  forState:UIControlStateNormal];
    }
    [theGame update];
}



- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    [self update];
}


- (IBAction)jumpToFilm {
    [[UIApplication sharedApplication] openURL:[NSURL
        URLWithString:@"http://www.junkspace.org"]];
}


- (IBAction)jumpToSatData {
    NSString *joe = [NSString stringWithFormat:@"http://www.n2yo.com/satellite/?s=%d", [theGame getID]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:joe]];
}


- (IBAction)showTexty {
    [self moveTextOn]; 
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch;
    int ct, i, j;
    NSArray *allT;
    
    
    allT = [touches allObjects];
    ct = [allT count];
    if (ct>40) { ct=40; }
    j=0;
    
    for (i=0; i<ct; ++i) {
        touch = [allT objectAtIndex:i];
        if (CGRectContainsPoint([self.view frame], [touch locationInView:self.view])) {
            [self moveTextOff]; 
        } else if (CGRectContainsPoint([self.theLabel frame], [touch locationInView:self.theLabel])) {
            
        }
    }
}

@end
