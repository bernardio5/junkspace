/*
    
 
*/

#import "Texture.h"
#import <OpenGL/glu.h>

#define TEXTURE_WIDTH		4096
#define TEXTURE_HEIGHT		4096

@interface Texture (PrivateMethods)

- (BOOL) getImageDataFromPath:(NSString*)path;
- (void) loadTexture;

@end

@implementation Texture

- (id) initWithPath:(NSString*)path
{	
	if (self = [super init]) {
		if ([self getImageDataFromPath:path])
			// [self loadTexture];
            [self loadMIP];
	}
	return self;
}

- (GLuint) textureName
{
	return texId;
}

- (BOOL) getImageDataFromPath:(NSString*)path
{
	NSUInteger				width, height;
	NSURL					*url = nil;
	CGImageSourceRef		src;
	CGImageRef				image;
	CGContextRef			context = nil;
	CGColorSpaceRef			colorSpace;
	
	data = (GLubyte*) calloc(TEXTURE_WIDTH * TEXTURE_HEIGHT * 4, sizeof(GLubyte));
	
	url = [NSURL fileURLWithPath: path];
	src = CGImageSourceCreateWithURL((CFURLRef)url, NULL);
	
	if (!src) {
		NSLog(@"No image");
		free(data);
		return NO;
	}
	
	image = CGImageSourceCreateImageAtIndex(src, 0, NULL);
	CFRelease(src);
	
	width = TEXTURE_WIDTH; // CGImageGetWidth(image);
	height = TEXTURE_HEIGHT; // CGImageGetHeight(image);
	
	colorSpace = CGColorSpaceCreateDeviceRGB();
	context = CGBitmapContextCreate(data, width, height, 8, 4 * width, colorSpace, kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Host);
	CGColorSpaceRelease(colorSpace);
	
	// Core Graphics referential is upside-down compared to OpenGL referential
	// Flip the Core Graphics context here
	// An alternative is to use flipped OpenGL texture coordinates when drawing textures
	CGContextTranslateCTM(context, 0.0, height);
	CGContextScaleCTM(context, 1.0, -1.0);
	
	// Set the blend mode to copy before drawing since the previous contents of memory aren't used. This avoids unnecessary blending.
	CGContextSetBlendMode(context, kCGBlendModeCopy);
	
	CGContextDrawImage(context, CGRectMake(0, 0, width, height), image);
	
	CGContextRelease(context);
	CGImageRelease(image);
	
	return YES;
}

- (void) loadTexture
{
	glGenTextures(1, &texId);
	glGenBuffers(1, &pboId);
	
	// Bind the texture
	glBindTexture(GL_TEXTURE_2D, texId);
	
	// Bind the PBO
    glBindBuffer(GL_PIXEL_UNPACK_BUFFER, pboId);
	
	// Upload the texture data to the PBO
	glBufferData(GL_PIXEL_UNPACK_BUFFER, TEXTURE_WIDTH * TEXTURE_HEIGHT * 4 * sizeof(GLubyte), data, GL_STATIC_DRAW);
	
	// Setup texture parameters
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
	
	glPixelStorei(GL_UNPACK_ROW_LENGTH, 0);
	
	// OpenGL likes the GL_BGRA + GL_UNSIGNED_INT_8_8_8_8_REV combination
	// Use offset instead of pointer to indictate that we want to use data copied from a PBO		
	glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, TEXTURE_WIDTH, TEXTURE_HEIGHT, 0, 
				 GL_BGRA, GL_UNSIGNED_INT_8_8_8_8_REV, 0);
	//gluBuild2DMipmaps(GL_TEXTURE_2D, GL_RGBA, 64, 64, GL_RGBA, GL_UNSIGNED_BYTE, data); 
	// We can delete the application copy of the texture data now
	free(data);
	
	glBindTexture(GL_TEXTURE_2D, 0);
	//glBindBuffer(GL_PIXEL_UNPACK_BUFFER, 0);
}



- (void) loadMIP {
    // allocate a texture name
    glGenTextures( 1, &texId );
    
    // select our current texture
    glBindTexture( GL_TEXTURE_2D, texId );
    
    // select modulate to mix texture with color for shading
    glTexEnvf( GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_MODULATE );
    
    // when texture area is small, bilinear filter the closest mipmap
    glTexParameterf( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER,
                    GL_LINEAR_MIPMAP_NEAREST );
    // when texture area is large, bilinear filter the first mipmap
    glTexParameterf( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR );
    
    // if wrap is true, the texture wraps over at the edges (repeat)
    //       ... false, the texture ends at the edges (clamp)
    glTexParameterf( GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP );
    glTexParameterf( GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP );
    
    // build our texture mipmaps
    gluBuild2DMipmaps( GL_TEXTURE_2D, 4, 4096, 4096,
                      GL_BGRA, GL_UNSIGNED_INT_8_8_8_8_REV, data );
    
    // free buffer
    free( data );
    
}




- (void) dealloc
{
	glDeleteTextures(1, &texId);
	glDeleteBuffers(1, &pboId);
	[super dealloc];
}

@end
 
 
 




























