
#import "MainController.h"
#import "MyOpenGLView.h"
#import "Scene.h"

#define ISEA_TOP_MG 120
#define ISEA_BOT_MG 220

#define ISEA_LEFT_MG 120
#define ISEA_RIGHT_MG 220


@implementation MainController







- (void)goFullScreenHelper: (int)isVertical {
	NSRect mainDisplayRect, viewRect, glrect;
    
    isInFullScreenMode = YES;
	
	// Pause the non-fullscreen view
	[openGLView stopAnimation];
		
	// get access to the screen with keyboard focus
	mainDisplayRect = [[NSScreen mainScreen] frame];
    
	fullScreenWindow[0] = [[NSWindow alloc] initWithContentRect:mainDisplayRect styleMask:NSBorderlessWindowMask
													 backing:NSBackingStoreBuffered defer:YES];
	
	// Set the window level to be above the menu bar
	[fullScreenWindow[0] setLevel:NSMainMenuWindowLevel+1];
    [fullScreenWindow[0] setOpaque:YES];
	[fullScreenWindow[0] setHidesOnDeactivate:YES];
	
    //////// make a full-screen container view to put the OGL view and label into
    NSView *containerView; 
    viewRect = NSMakeRect(0.0, 0.0, mainDisplayRect.size.width, mainDisplayRect.size.height);
    containerView = [[NSView alloc] initWithFrame:viewRect]; 

    ///////  black band at top for cropping @ ISEA 
    NSTextView *blackTop, *blackBot; 
    if (isVertical==1) { 
        blackTop = [[NSTextView alloc] initWithFrame:NSMakeRect(0,0, ISEA_TOP_MG, mainDisplayRect.size.height)];
        [blackTop setString:@"AAA"];
        [blackTop setBackgroundColor: [NSColor blackColor]]; 
        [blackTop setTextColor: [NSColor blackColor]]; 
        [blackTop setDrawsBackground: YES]; 
        [containerView addSubview: blackTop];
    }
    
    /////// OGL view setup
    // Create a view with a double-buffered OpenGL context and attach it to the window
	// (that sharecontext stuff grabs settings from the existing OGLView
    if (isVertical==1) { 
        glrect = NSMakeRect(ISEA_TOP_MG, 0.0, mainDisplayRect.size.width - (ISEA_TOP_MG+ISEA_BOT_MG+60), mainDisplayRect.size.height);
    } else {
        glrect = NSMakeRect(0.0, 100.0, mainDisplayRect.size.width, mainDisplayRect.size.height-100);
    }
	bigOGL = [[MyOpenGLView alloc] initWithFrame:glrect shareContext:[openGLView openGLContext]];
	[containerView addSubview: bigOGL]; 
	[scene setViewportRect:glrect]; 	// tell "scene" that the viewingrect has changed
	[bigOGL setMainController:self]; 	// tell self to fucking draw innit
                // need to switch between 2 open views? 
    
    if (!isAnimating) {
		[bigOGL setNeedsDisplay:YES];
	} else {
		[bigOGL startAnimation];
	}
    
    
    ///////////  label setup
    if (isVertical==1) { 
        fullscLabel = [[NSTextView alloc] initWithFrame:NSMakeRect(mainDisplayRect.size.width-ISEA_BOT_MG-60, 0, 
                    mainDisplayRect.size.height, mainDisplayRect.size.height)]; // if you rot 90deg, gotta be square, I guess
    } else {
        fullscLabel = [[NSTextView alloc] initWithFrame:NSMakeRect(0, 40, mainDisplayRect.size.width, 60)];
    }
    [fullscLabel setString:@"NCC-1701 2002 DEB"];
    NSFont *yummyFont = [NSFont fontWithName:@"Lucida Grande" size:40.0];
    [fullscLabel setFont: yummyFont]; 
    [fullscLabel setAlignment: 2];  
    [fullscLabel setEditable:NO];
    [fullscLabel setSelectable:NO];
    
    if (isVertical==1) { 
        [fullscLabel setFrameCenterRotation:90];
    }
    [containerView addSubview:fullscLabel];
 
    ///////  black band at bottom for cropping @ ISEA 
    if (isVertical==1) { 
        blackBot = [[NSTextView alloc] initWithFrame:NSMakeRect(mainDisplayRect.size.width-ISEA_BOT_MG, 0, ISEA_BOT_MG, mainDisplayRect.size.height)];
        [blackBot setString:@"AAA"];
        [blackBot setBackgroundColor: [NSColor blackColor]]; 
        [blackBot setTextColor: [NSColor blackColor]]; 
        [blackBot setDrawsBackground: YES]; 
        [containerView addSubview: blackBot];
    }

    [fullScreenWindow[0] setContentView:containerView];
	[fullScreenWindow[0] makeKeyAndOrderFront:self];
}



/// for ISEA -- one full-screen object with a label
- (IBAction) goFullScreen:(id)sender {
    [scene takeMessage: 1];
    [self goFullScreenHelper: 1];
}

// for Zero1 -- one FS with label
- (IBAction) goFullScreenZero1:(id)sender {
//    [scene takeMessage: 0];
    [self goFullScreenHelper: 0];
}


// for Zero1 -- make two horizontal full-screen things
- (IBAction) goFullScreenZero1Two:(id)sender {
    [scene takeMessage:2];
    [self goFullScreenHelper: 0];
}






- (void) goWindow
{
	isInFullScreenMode = NO;
	
	// Release the screen-sized window and view
	[fullScreenWindow[0] release];
	[bigOGL release];
	
	// Switch to the non-fullscreen context
	[[openGLView openGLContext] makeCurrentContext];

    // let it know! redo the projection
    [scene setViewportRect:openGLView.bounds];
    [scene takeMessage: 0]; 
    
	if (!isAnimating) {
		// Mark the view as needing drawing
		// The animation has advanced while we were in full-screen mode, so its current contents are stale
		[openGLView setNeedsDisplay:YES];
	}
	else {
		// Continue playing the animation
		[openGLView startAnimation];
	}
}



- (void)coRunner { 
   // NSLog(@"ping"); 
    if (isInFullScreenMode==YES) { 
        if ([scene hasNewName]==1) { 
            [fullscLabel setString:[scene getName]];
        }
    } else { 
        if ([scene hasNewName]==1) { 
            [windowLabel setStringValue:[scene getName]];
        }
    }
}






- (void) awakeFromNib
{
	// Allocate the scene object
	scene = [[Scene alloc] init];
	
	// Assign the view's MainController to self
	[openGLView setMainController:self];
	
	// Activate the display link now
	[openGLView startAnimation];
	isAnimating = YES;
    
    // make a thread that watches the labels and resets them 
    theTimer = [NSTimer scheduledTimerWithTimeInterval:(NSTimeInterval)(1.0/5.0) target:self selector:@selector(coRunner) userInfo:nil repeats:TRUE];
    
    // [self goFullScreenHelper: 0];
}

- (void) dealloc
{
	[scene release];
	[super dealloc];
}

- (Scene*) scene
{
	return scene;
}

- (CFAbsoluteTime) renderTime
{
	return renderTime;
}

- (void) setRenderTime:(CFAbsoluteTime)time
{
	renderTime = time;
}

- (void) startAnimation
{
	if (!isAnimating)
	{
		if (!isInFullScreenMode)
			[openGLView startAnimation];
		else
			[bigOGL startAnimation];
		isAnimating = YES;
	}
}

- (void) stopAnimation
{
	if (isAnimating)
	{
		if (!isInFullScreenMode)
			[openGLView stopAnimation];
		else
			[bigOGL stopAnimation];
		isAnimating = NO;
	}
    [theTimer invalidate];
}

- (void) toggleAnimation
{
	if (isAnimating)
		[self stopAnimation];
	else
		[self startAnimation];
}

- (void) keyDown:(NSEvent *)event {
    if (isInFullScreenMode) [self goWindow];
}

// Holding the mouse button and dragging the mouse changes the "roll" angle (y-axis) and the direction from which sunlight is coming (x-axis).
- (void)mouseDown:(NSEvent *)theEvent
{
    if (isInFullScreenMode) [self goWindow];
    
}

@end
