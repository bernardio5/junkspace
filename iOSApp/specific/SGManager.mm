//
//  SGManager.h

//
//  Created by Neal McDonald on 11/6/09.
//  Copyright Neal McDonald 2009. All rights reserved.
//

// scene graph manager-- the interface to the scene graph

#include "SGManager.h"
#include "mVec3.h"

@implementation sgManager

- (id)init {
	if ((self = [super init])) {
		//billCt = 0;
        
        mvSetf(&eyept, 0.0, 0.0, -10.0);
        mvSetf(&up, 0.0, 1.0, 0.0);
        mvSetf(&dir, 0.0, 0.0, 1.0);
        mvEqAdd(&COI, &eyept, &dir);
        mvNormalize(&COI);
        mvSetf(&bgColor, 1.0,1.0,1.0);
        
        
        xrez = 320.0;
        yrez = 480.0;
        scale = 1.0;
        near = 2.0;
        far = 40000.0;
        angle = GLKMathDegreesToRadians(45.0f);
        
        effect = [[GLKBaseEffect alloc] init];
        float aspect = xrez/yrez;
        effect.transform.projectionMatrix =  GLKMatrix4MakePerspective(angle, aspect, near, far);
        effect.transform.modelviewMatrix = GLKMatrix4MakeLookAt(0.0,0.0,0.0,
                                                                COI.x, COI.y, COI.z, 0.0,1.0,0.0);
        // effect.transform.projectionMatrix =  GLKMatrix4MakeOrtho(160.0, -160.0, -240.0, 240.0, -1000.0f, 1000.0f);
        
      //  effect.light0.enabled = YES;
      //  effect.light0.ambientColor = GLKVector4Make(0.0, 1.0, 1.0, 1.0);
      //  effect.light0.diffuseColor = GLKVector4Make(1.0, 0.0, 1.0, 1.0);
       // effect.light0.position = GLKVector4Make(0.0, 0.0, 0.0, 0.0);
        
        [effect prepareToDraw];
        int i;
        
        for (i=0; i<MAX_BILLS; ++i) { billShow[i] = 0; };
        
    }
    return self;
}


- (void)loadTexture:(NSString*)fname {
    NSError *error;
    // NSLog(@"SGM::loadText  fname=%@", fname);
    texture = [GLKTextureLoader textureWithCGImage:[UIImage imageNamed:fname].CGImage
                                           options:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:GLKTextureLoaderOriginBottomLeft] error:&error];
    if (error) {
        NSLog(@"Error loading texture from image: %@",error);
    }
    effect.texture2d0.enabled = YES;
    effect.texture2d0.envMode = GLKTextureEnvModeReplace;
    effect.texture2d0.target = GLKTextureTarget2D;
    effect.texture2d0.name = texture.name;

    [effect prepareToDraw];
    
}



- (void)useTexture:(int)asWhich {}



// screen rez defaults to 320x480.
// do not draw until after this routine is called; usually by viewController.
- (void) setScreen:(int)wid:(int)height:(int)speedSwitch {
    xrez = wid;
    yrez = height;
    
    if (speedSwitch<2) {
        [self loadTexture: @"orbitalTiles2048"];
    } else {
        [self loadTexture: @"orbitalTiles4096"];
    }
        
}

- (int) getWidth { return xrez; }


- (void) setCameraPUD:(mVec3 *)p:(mVec3 *)u:(mVec3 *)d {
   mvCopy(&eyept, p);
   mvCopy(&up, u);
   mvCopy(&dir, d);
   mvEqAdd(&COI, p, d);
}


- (void) setCameraViewAngle:(float)rads {
    angle = rads;
    // NSLog(@"angle %f", angle);
}


- (GLKBaseEffect*)getEffect {
    return effect;
}


 - (int) addBillboard:(mVec3*)pos :(float) sz :(int) tx:(int)ty {
     if (billCt<MAX_BILLS) {
        bbSet(&(bills[(billCt)]), &eyept, &up, pos, sz, tx, ty);
        billShow[billCt] = 1;
         ++(billCt);
     }
     return (billCt)-1;
 }


- (void) updateBillboard:(int)which:(mVec3*)pos:(float)sz {
    if ((which<MAX_BILLS)&&(billShow[which]==1)) {
        bbUpdate(&(bills[which]), &eyept, &up, pos, sz);
    }
}



- (void) hideBillboard:(int)which {
    if (which<MAX_BILLS) {
        billShow[which]=0;
    }
}

- (void) unhideBillboard:(int)which {
    if (which<MAX_BILLS) {
        billShow[which]=1;
    }
}


- (void) start3D {
    glClearColor(bgColor.x, bgColor.y, bgColor.z, 0.0);
    glClear(GL_COLOR_BUFFER_BIT );
    effect.transform.projectionMatrix =  GLKMatrix4MakePerspective(angle, xrez/yrez, near, far);
    effect.transform.modelviewMatrix = GLKMatrix4MakeLookAt(eyept.x, eyept.y, eyept.z,
                                                            COI.x, COI.y, COI.z, up.x, up.y, up.z);
    // NSLog(@"e %f %f %f   c %f %f %f   u %f %f %f", eyept.x, eyept.y, eyept.z, COI.x, COI.y, COI.z, up.x, up.y, up.z);
   // NSLog(@"bgc %f %f %f",  bgColor.x, bgColor.y, bgColor.z);
    [effect prepareToDraw];
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
}


- (void) redraw {
	int i;
    
    for (i=0; i<(billCt); ++i) {
        if ((bbDoDraw(&(bills[i]), &dir)>0.1)&&(billShow[i]==1)) {
            glEnableVertexAttribArray(GLKVertexAttribPosition);
            glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat)*5, &(bills[i].p[0]));
            glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
            glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(GLfloat)*5, &(bills[i].p[3]));
            glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
            glDisableVertexAttribArray(GLKVertexAttribPosition);
            glDisableVertexAttribArray(GLKVertexAttribTexCoord0);
        }
    }
    glDisable(GL_BLEND);
}

@end



