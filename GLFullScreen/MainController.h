

#import <Cocoa/Cocoa.h>
#import <OpenGL/OpenGL.h>

@class MyOpenGLView;
@class Scene;

@interface MainController : NSResponder {

	BOOL isInFullScreenMode;
	    
	// window mode
	IBOutlet MyOpenGLView *openGLView;
    IBOutlet NSTextField *windowLabel; 
    
	// full-screen mode
	NSWindow *fullScreenWindow[2];
    int windowCount;
    
	MyOpenGLView *bigOGL;
    NSTextView *fullscLabel; 
	
    NSWindow *secondScreen; 
    MyOpenGLView *bigOGL2; 
    NSTextView *fullscLabel2; 
    
    //int isVertical;
    
    NSTimer* theTimer;
    
	Scene *scene;
	BOOL isAnimating;
	CFAbsoluteTime renderTime;
}

//- (void)makeAFullScreen:(NSRect *)screenFrame;
//- (void)allFullScreen:(int)count;

- (void) goFullScreenHelper:(int)isVertical;


- (IBAction) goFullScreen:(id)sender;
- (IBAction) goFullScreenZero1:(id)sender;
- (IBAction) goFullScreenZero1Two:(id)sender;

- (void) goWindow;

- (Scene*) scene;

- (CFAbsoluteTime) renderTime;
- (void) setRenderTime:(CFAbsoluteTime)time;

@end
