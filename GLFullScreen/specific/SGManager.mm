//
//  SGManager.h

//
//  Created by Neal McDonald on 11/6/09.
//  Copyright Neal McDonald 2009. All rights reserved.
//

// scene graph manager-- the interface to the scene graph

#include "SGManager.h" 


@implementation sgManager

- (id)init {    
	if ((self = [super init])) {
        
        mvSetf(&eyept, 0.0, 0.0, -20.0); 
        mvSetf(&up, 0.0, 1.0, 0.0); 
        mvSetf(&dir, 0.0, 0.0, 1.0); 
        mvEqAdd(&COI, &eyept, &dir); 
        mvNormalize(&COI);
        
        doFirstSort = 1;
        
    }
    return self; 
}


- (void) setCameraPUD:(mVec3 *)p:(mVec3 *)u:(mVec3 *)d {
    mvCopy(&eyept, p); 
    mvCopy(&up, u);
    mvNormalize(&up);
    mvCopy(&dir, d);
    mvNormalize(&dir); 
    mvEqAdd(&COI, p, d); 
}



- (int) addBillboard:(mVec3*)pos :(float) sz :(int) tx:(int)ty {
    
    if (billCt<MAX_BILLS) { 
        bbSet(&(bills[(billCt)]), &eyept, &up, pos, sz, tx, ty); 
        depthPlace[billCt] = -1;
        ++(billCt);
    }
    return (billCt)-1; 
}


- (void) updateBillboard:(int)which:(mVec3*)pos:(float)sz { 
    if (which<MAX_BILLS) { 
        bbUpdate(&(bills[which]), &eyept, &up, &dir, pos, sz);
    }    
}


- (void)firstSort {
	int i, j, farthest;
    float maxDepth;
    
    for (i=0; i<billCt; ++i) {
        depthPlace[i] = i;
    }
    
    /// re-sort billboards by depth-- plain ol' fucking swapsort.
    // draw them back-to-front; first is farthest; ith is farthest remaining
    for (i=0; i<(billCt); ++i) {
        farthest = i;
        maxDepth = bills[depthPlace[i]].depthSq;
        for (j=i+1; j<billCt; ++j) {
            if (bills[depthPlace[j]].depthSq > maxDepth) {
                maxDepth = bills[depthPlace[j]].depthSq;
                farthest = j;
            }
        }
        
        j = depthPlace[i]; depthPlace[i] = depthPlace[j]; depthPlace[j] = j;
    }
    
}



- (void) redraw {
	int i, j, toDraw;//, spare;
    int farthest;
    float maxDepth;//, depthDif;
    
    /*  /// this one doesn't keep up
    if (doFirstSort ==1) {
        [self firstSort];
        doFirstSort = 0; 
    }
    
    // maybe i can get away with 10 bubblesort passes to maintain?
    for (i=0; i<100; ++i) {
        for (j=0; j<billCt-i; ++j) {
            if (bills[depthPlace[j]].depthSq < bills[depthPlace[j+i]].depthSq) {
                spare = depthPlace[j];
                depthPlace[j] = depthPlace[j+i];
                depthPlace[j+i] = spare;
            }
        }
    }
    */
    
    // copy the visible ones to the depthPlace list
    toDraw=0;
    for (i=0; i<billCt; ++i) {
        if (bills[i].depthSq >0.0) {
            depthPlace[toDraw]=i;
            ++toDraw;
        }
    }
    
    
    /// this one makes flickers
    // swapsort the visible
    for (i=0; i<toDraw; ++i) {
        farthest = i;
        maxDepth = bills[depthPlace[i]].depthSq;
        for (j=i+1; j<toDraw; ++j) {
            if (bills[depthPlace[j]].depthSq > maxDepth) {
                maxDepth = bills[depthPlace[j]].depthSq;
                farthest = j;
            }
        }
        
        j = depthPlace[i]; depthPlace[i] = depthPlace[farthest]; depthPlace[farthest] = j;
    }
    
    /// it pings occasionally, but it looks right, so it is right. 
    //for (i=0; i<toDraw-1; ++i) {
      //  depthDif = bills[depthPlace[i]].depthSq - bills[depthPlace[i+1]].depthSq;
      //  if (depthDif<0.0) { NSLog(@"%9.3f %d %f %f ", depthDif, i, bills[depthPlace[i]].depthSq, bills[depthPlace[i+1]].depthSq);
    //    }
    //}
        // two bugs: too many add/drops and sort works? 
    // NSLog(@"td: %d maxD %f  mind %f", toDraw, bills[depthPlace[0]].depthSq, bills[depthPlace[toDraw-1]].depthSq);
    
    
    
    
    
    //NSLog(@"sg redraw, %d", billCt);  
	for (i=0; i<toDraw; ++i) {
        bbDrawBillboard(&(bills[depthPlace[i]]));
    }
}



@end



