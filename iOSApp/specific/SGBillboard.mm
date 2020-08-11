

#import "SGBillboard.h"


/// for defining texture coords
#define BB_DENSITY 16.0f

// 1/density
#define BB_INV_DENSITY 0.0625f




/* ********************** drawing */




//// set as billboard sprite, for eyepoint e, sprite at point p, size sz, texture coords as sprite
void bbSet(sgBillboard *b, mVec3 *e, mVec3 *up, mVec3 *p, float sz, int tx, int ty) {
    mVec3 cam, vert, horiz; 
    mVec3 c1, c2, c3, c4, spare; 
    float t1x, t1y, t2x, t2y; 
    
    mvEqSub(&cam, p, e); 
    mvCopy(&vert, up); 
    mvEqCross(&horiz, &cam, &vert); 
    mvNormalize(&vert); 
    mvNormalize(&horiz); 
    mvScale(&vert, (real)(sz*0.5)); 
    mvScale(&horiz, (real)(sz*-0.5)); 
    
    mvEqSub(&spare, p, &vert); 
    mvEqSub(&c1, &spare, &horiz); 
    mvEqAdd(&c2, &spare, &horiz); 
    mvEqAdd(&spare, p, &vert); 
    mvEqSub(&c3, &spare, &horiz); 
    mvEqAdd(&c4, &spare, &horiz); 
    
    t1x = tx * BB_INV_DENSITY;
    t2x = t1x + BB_INV_DENSITY;
    t1y = ty * BB_INV_DENSITY;  // textures can be inverted
    t2y = t1y +  BB_INV_DENSITY;
    /*
    b->p[0] = c1.x; 
    b->p[1] = c1.y; 
    b->p[2] = c1.z; 
    mvNormalize(&c1); 
    mvNegate(&c1); 
    b->p[3] = c1.x; 
    b->p[4] = c1.y; 
    b->p[5] = c1.z; 
    
    b->p[6] = t1x; 
    b->p[7] = t2y; 
    
    
    b->p[8] = c2.x; 
    b->p[9] = c2.y; 
    b->p[10] = c2.z; 
    mvNormalize(&c2); 
    mvNegate(&c2); 
    b->p[11] = c2.x; 
    b->p[12] = c2.y; 
    b->p[13] = c2.z; 
    
    b->p[14] = t2x; 
    b->p[15] = t2y; 
    
    
    b->p[16] = c3.x; 
    b->p[17] = c3.y; 
    b->p[18] = c3.z; 
    mvNormalize(&c3); 
    mvNegate(&c3); 
    b->p[19] = c3.x; 
    b->p[20] = c3.y; 
    b->p[21] = c3.z; 
    
    b->p[22] = t1x; 
    b->p[23] = t1y; 
    
    
    b->p[24] = c4.x; 
    b->p[25] = c4.y; 
    b->p[26] = c4.z; 
    mvNormalize(&c4); 
    mvNegate(&c4); 
    b->p[27] = c4.x; 
    b->p[28] = c4.y; 
    b->p[29] = c4.z; 
    
    b->p[30] = t2x; 
    b->p[31] = t1y; 
    */
    
    /* w no normals */
    b->p[0] = c1.x; 
    b->p[1] = c1.y; 
    b->p[2] = c1.z; 
    
    b->p[3] = t1x; 
    b->p[4] = t2y; 
    
    
    b->p[5] = c2.x; 
    b->p[6] = c2.y; 
    b->p[7] = c2.z; 
    
    b->p[8] = t2x; 
    b->p[9] = t2y; 
    
    
    b->p[10] = c3.x; 
    b->p[11] = c3.y; 
    b->p[12] = c3.z; 
    
    b->p[13] = t1x; 
    b->p[14] = t1y; 
    
    
    b->p[15] = c4.x; 
    b->p[16] = c4.y; 
    b->p[17] = c4.z; 
    
    b->p[18] = t2x; 
    b->p[19] = t1y; 
    /*
    
    
    b->p[0] = c1.x; 
    b->p[1] = c1.y; 
    b->p[2] = c1.z; 
    
    b->t[0] = t1x; 
    b->t[1] = t2y; 
    
    
    b->p[3] = c2.x; 
    b->p[4] = c2.y; 
    b->p[5] = c2.z; 
    
    b->t[2] = t2x; 
    b->t[3] = t2y; 
    
    
    b->p[6] = c3.x; 
    b->p[7] = c3.y; 
    b->p[8] = c3.z; 
    
    b->t[4] = t1x; 
    b->t[5] = t1y; 
    
    
    b->p[9] = c4.x; 
    b->p[10] = c4.y; 
    b->p[11] = c4.z; 
    
    b->t[6] = t2x; 
    b->t[7] = t1y; 
    */
   // NSLog(@"%f %f %f %f", t1x, t2x, t1y, t2y);
}    



void bbUpdate(sgBillboard *b, mVec3 *e, mVec3 *up, mVec3 *p, float sz) {
    mVec3 cam, vert, horiz; 
    mVec3 c1, c2, c3, c4, spare; 
    
    mvCopy(&(b->pos), p); 
    
    mvEqSub(&cam, p, e); 
    mvCopy(&vert, up); 
    mvEqCross(&horiz, &cam, &vert); 
    mvNormalize(&vert); 
    mvNormalize(&horiz); 
    mvScale(&vert, (real)(sz*0.5)); 
    mvScale(&horiz, (real)(sz*0.5)); 
    
    mvEqSub(&spare, p, &vert); 
    mvEqSub(&c1, &spare, &horiz); 
    mvEqAdd(&c2, &spare, &horiz); 
    mvEqAdd(&spare, p, &vert); 
    mvEqSub(&c3, &spare, &horiz); 
    mvEqAdd(&c4, &spare, &horiz); 
    /*
    
    b->p[0] = c1.x; 
    b->p[1] = c1.y; 
    b->p[2] = c1.z; 
    mvNormalize(&c1); 
    mvNegate(&c1); 
    b->p[3] = c1.x; 
    b->p[4] = c1.y; 
    b->p[5] = c1.z; 
    
    b->p[8] = c2.x; 
    b->p[9] = c2.y; 
    b->p[10] = c2.z; 
    mvNormalize(&c2); 
    mvNegate(&c2); 
    b->p[11] = c2.x; 
    b->p[12] = c2.y; 
    b->p[13] = c2.z; 
    
    b->p[16] = c3.x; 
    b->p[17] = c3.y; 
    b->p[18] = c3.z; 
    mvNormalize(&c3); 
    mvNegate(&c3); 
    b->p[19] = c3.x; 
    b->p[20] = c3.y; 
    b->p[21] = c3.z; 
    
    b->p[24] = c4.x; 
    b->p[25] = c4.y; 
    b->p[26] = c4.z; 
    mvNormalize(&c4); 
    mvNegate(&c4); 
    b->p[27] = c4.x; 
    b->p[28] = c4.y; 
    b->p[29] = c4.z; 
    */
    
    b->p[0] = c1.x; 
    b->p[1] = c1.y; 
    b->p[2] = c1.z; 
    
    b->p[5] = c2.x; 
    b->p[6] = c2.y; 
    b->p[7] = c2.z;     
    
    b->p[10] = c3.x; 
    b->p[11] = c3.y; 
    b->p[12] = c3.z; 
    
    b->p[15] = c4.x; 
    b->p[16] = c4.y; 
    b->p[17] = c4.z;
    
    
    ///NSLog(@"e %f %f %f   c %f %f %f   u %f %f %f", c1.x, c1.y, c1.z, c2.x, c2.y, c2.z, c3.x, c3.y, c3.z);
    /*
    b->p[0] = c1.x; 
    b->p[1] = c1.y; 
    b->p[2] = c1.z; 
    
    b->p[3] = c2.x; 
    b->p[4] = c2.y; 
    b->p[5] = c2.z;     
    
    b->p[6] = c3.x; 
    b->p[7] = c3.y; 
    b->p[8] = c3.z; 
    
    b->p[9] = c4.x; 
    b->p[10] = c4.y; 
    b->p[11] = c4.z;
     */
}    




float bbDoDraw(sgBillboard *b, mVec3 *dir) {
    float dot; 
    
    mvDotWith(&(b->pos), dir, &dot);
    return dot;
}
    
/*
// these are OGL 1.1 commands; might not work with GLKit. 
void bbDrawBillboard(sgBillboard *b) {

    //if (bbDoDraw(&(bills[i]), &dir)>0.1) { 
    
    glEnableClientState(GL_VERTEX_ARRAY);
    //glEnableClientState(GL_NORMAL_ARRAY);
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    glEnableVertexAttribArray(GL_VERTEX_ARRAY);
    
    glTexCoordPointer(2, GL_FLOAT, 0, &(b->t[0])); 
    glVertexPointer(3, GL_FLOAT, 0, &(b->p[0])); 
    // glVertexAttribPointer(GL_VERTEX_ARRAY, 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat)*3, &(bills[i].p[0]));
    // glEnableVertexAttribArray(GL_NORMAL_ARRAY);
    // glVertexAttribPointer(GL_NORMAL_ARRAY, 3, GL_FLOAT, GL_FALSE, sizeof(GLfloat)*8, &(bills[i].p[3]));
    // glEnableVertexAttribArray(GL_TEXTURE_COORD_ARRAY);
    // glVertexAttribPointer(GL_TEXTURE_COORD_ARRAY, 2, GL_FLOAT, GL_FALSE, sizeof(GLfloat)*5, &(bills[i].p[3]));
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    
    glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    glEnableClientState(GL_VERTEX_ARRAY);
    

}

*/