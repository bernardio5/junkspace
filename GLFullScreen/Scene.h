

#import <Cocoa/Cocoa.h>

#import "gameObject.h"
#import "SGManager.h"


@class Texture;

@interface Scene : NSObject {
	Texture *texture;
	GLuint textureName;
	    
    sgManager *theSGM; 
    gameObject *theGame; 
    
    float timer; 
}

- (id)init;

- (void)setViewportRect:(NSRect)bounds;
- (void)render;

//////// game interface
// pass which thru to game
- (void)takeMessage:(int)which; 

- (int)hasNewName; 
- (NSString*)getName; 



@end
