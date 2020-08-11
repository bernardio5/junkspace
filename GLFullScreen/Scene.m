
#import "Scene.h"
#import "Texture.h"
#import <OpenGL/glu.h>

static double dtor( double degrees )
{
    return degrees * M_PI / 180.0;
}

@implementation Scene


- (id) init
{
    self = [super init];
    if (self) {
		textureName = 0;
                    
        theSGM = [[sgManager alloc] init]; 
        theGame = [[gameObject alloc] init];
        [theGame takeSGM: theSGM]; 
        timer = 0.0; 
    } 
    return self;
}

- (void)dealloc
{
	[texture release];
    [super dealloc];
}



- (void)setViewportRect:(NSRect)bounds {
    glViewport(0, 0, bounds.size.width, bounds.size.height);
	glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    gluPerspective(45, bounds.size.width / bounds.size.height, 500.0, 20000.0);
	glMatrixMode(GL_MODELVIEW);
}



- (void)render {	
		glEnable(GL_DEPTH_TEST);
	// glEnable(GL_CULL_FACE);
	glDisable(GL_LIGHTING);
    glEnable(GL_BLEND);
	glEnable(GL_TEXTURE_2D);
    glClearColor(1, 1, 1, 0.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    /*
    static GLfloat materialAmbient[4] = { 1.0, 1.0,1.0, 1.0 };
    static GLfloat materialDiffuse[4] = { 1.0, 1.0, 1.0, 1.0 };
    glMaterialfv(GL_FRONT, GL_AMBIENT, materialAmbient);
	glMaterialfv(GL_FRONT, GL_DIFFUSE, materialDiffuse);
    */
    // Upload the texture
	if (!textureName) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"orbitalTiles" ofType:@"png"];
		texture = [[Texture alloc] initWithPath:path];
		textureName = [texture textureName];
	}
	
	// Set up texturing parameters
	glBindTexture(GL_TEXTURE_2D, textureName);
    glTexEnvf(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_REPLACE);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
	glPushMatrix();
	 // Back the camera off a bit
    //GLUquadric *quadric = NULL;
    // glTranslatef(0.0, 0.0, -1.5);
   //  quadric = gluNewQuadric();
   //  gluQuadricTexture(quadric, GL_TRUE);
   //  gluSphere(quadric, 0.25, 48, 24);
   //  gluDeleteQuadric(quadric);
   //  quadric = NULL;
    mVec3 p, u, c; //, p2, u2, c2;
    
    [theGame getCamera:&p: &u: &c];
    //[theGame takeMessage: 1];
    //[theGame getCamera:&p2: &u2: &c2];
    //[theGame takeMessage: 0];
    
    gluLookAt(p.x,p.y,p.z,c.x,c.y,c.z,u.x,u.y,u.z); 
    [theGame update];
    
    glPopMatrix();
	
	glBindTexture(GL_TEXTURE_2D, 0);
      
}


- (void)takeMessage:(int)which {
    [theGame takeMessage: which]; 
}

- (int)hasNewName { 
    return [theGame hasNewName]; 
}
- (NSString*)getName {
    return [theGame getName]; 
}



@end
