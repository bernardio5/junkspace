

#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>


// horizontal and vertical tiles per sprite sheet
#define SPR_DENSITY 16.0f

// 1/density
#define SPR_INV_DENSITY 0.0625f

typedef struct { 
	float cx, cy, sx, sy;		/* position and size */
	float r;					/* rotation */
	float t1x, t1y, t2x, t2y;	/* texture coords: top left, bottom right */
} sprite; 





/* setting */
static inline void sprSet(sprite *s, float x, float y, float sz, int tx, int ty, int txsz, int tysz) {
	s->cx = x; 
	s->cy = y;
	s->sx = txsz * sz;
	s->sy = tysz * sz; 
	s->r = 0.0f;
	
	s->t1x = tx * SPR_INV_DENSITY;
	s->t2x = s->t1x + (SPR_INV_DENSITY*txsz);
	s->t1y = ty * SPR_INV_DENSITY;
	s->t2y = s->t1y + (SPR_INV_DENSITY*tysz);
}

static inline void sprSetPos(sprite *s, float x, float y) {
	s->cx = x; 
	s->cy = y;
}

static inline void sprSetRot(sprite *s, float x) {
	s->r = x;
}

static inline float sprGetCenterX(sprite *s) { 
	return s->cx;
}

static inline float sprGetCenterY(sprite *s) { 
	return s->cy;
}

static inline void sprSetSize(sprite *s, float x, float y) {
	s->sx = x*0.5f; 
	s->sy = y*0.5f;
}


static inline void sprCopy(sprite *s, sprite *it) {
	s->cx = it->cx; 
	s->cy = it->cy; 
	s->sx = it->sx; 
	s->sy = it->sy; 
	s->r = it->r; 
	s->t1x = it->t1x; 
	s->t1y = it->t1y; 
	s->t2x = it->t2x; 
	s->t2y = it->t2y; 
}



// set so middle of tile is at x1y2, and top of tile is at x2y2
static inline void sprSetConnector(sprite *s, float width, float x1, float y1, float x2, float y2) {
	float dx, dy, len, angle;
	
 	dx = x2-x1;
	dy = y2-y1;
	len = (float)sqrt(dx*dx+dy*dy); 
	angle = (float)acos(dx/len);
	if (dy<0.0) { angle = 6.2831853f-angle; } // remember: y pointing down
	angle += 1.5707963;
	
	s->cx = x1; 
	s->cy = y1;
	s->sx = width*0.5f; 
	s->sy = len;
	s->r = angle; 
}	



/* set the sprite to use one tile of the tile set */
static inline void sprSetTile(sprite *s, int which) {
	int col = which%16;
	int row = (which-col) * SPR_INV_DENSITY;
	s->t1x = col * SPR_INV_DENSITY;
	s->t2x = s->t1x + SPR_INV_DENSITY;
	s->t1y = row * SPR_INV_DENSITY;
	s->t2y = s->t1y + SPR_INV_DENSITY;
}

/* set the sprite to cover multiple tiles, no bounds checking, babe. */
static inline void sprSetMultiTile(sprite *s, int which, int dx, int dy) {
	sprSetTile(s, which); 
	s->t2x += (dx-1) * SPR_INV_DENSITY; 
	s->t2y += (dy-1) * SPR_INV_DENSITY; 
}



/* ************************ buttony */
static inline bool sprInside(sprite *s, float px, float py) {
	if (px<((s->cx)-(s->sx))) { return NO; }
	if (py<((s->cy)-(s->sy))) { return NO; }
	if (px>((s->cx)+(s->sx))) { return NO; }
	if (py>((s->cy)+(s->sy))) { return NO; }
	return YES; 
}



/* ********************** drawing */

static inline void sprDraw(sprite *s) {
	GLfloat p[8], t[8], sn, cs, nx, ny; 
	int i;
	
	p[0] = -s->sx; 
	p[1] = -s->sy; 
	
	p[2] =  s->sx; 
	p[3] = -s->sy; 
	
	p[4] = -s->sx; 
	p[5] =  s->sy; 
	
	p[6] =  s->sx; 
	p[7] =  s->sy; 
	
	t[0] = s->t1x; 
	t[1] = s->t1y; 
	
	t[2] = s->t2x; 
	t[3] = s->t1y; 
	
	t[4] = s->t1x; 
	t[5] = s->t2y; 
	
	t[6] = s->t2x; 
	t[7] = s->t2y; 
    
	sn = (float)sin(s->r); 
	cs = (float)cos(s->r); 

	for (i=0; i<7; i+=2) { 
		nx = (cs*p[i])-(sn*p[i+1])+(s->cx);
		ny = (sn*p[i])+(cs*p[i+1])+(s->cy);
		p[i] = nx;
		p[i+1] = ny;
	}
	
	glVertexPointer(2, GL_FLOAT, 0, p);
	glEnableClientState(GL_VERTEX_ARRAY);
	glTexCoordPointer(2, GL_FLOAT, 0, t);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);	
}




static inline float frand() { 
    return 0.000001 * (random()%1000000); 
}



static inline float frandRange(float max, float min) { 
    return (frand()*(max-min)) + min; 
}


