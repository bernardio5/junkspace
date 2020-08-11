

#import <Cocoa/Cocoa.h>
#import <QuartzCore/CVDisplayLink.h>

@class MainController;

@interface MyOpenGLView : NSView {
	
	NSOpenGLContext *openGLContext;
	NSOpenGLPixelFormat *pixelFormat;
	
	MainController *controller;
	
	CVDisplayLinkRef displayLink;
	BOOL isAnimating;
    
   

    
}

- (id) initWithFrame:(NSRect)frameRect;
- (id) initWithFrame:(NSRect)frameRect shareContext:(NSOpenGLContext*)context;

- (NSOpenGLContext*) openGLContext;

- (void) setMainController:(MainController*)theController;

- (void) drawView;

- (void) startAnimation;
- (void) stopAnimation;



@end
