
// read stars.xml, load data into arrays, offer up data nicely
//<stars>
//<star><mag>3.560000</mag><ra>0.036281</ra><dc>0.507726</dc></star>

#import <Foundation/Foundation.h>
#import "starBall.h"

@interface starSource : NSObject <NSXMLParserDelegate> {
	NSXMLParser *theParser;
	NSData *aData; 
    
    starBall *allStars;
    float mag, ra, dc; 
    int con;
    
    int starCtr; 
	int inType;
}

- (void)parse:(starBall*)stars; 
- (int)loadedCount; 

@end
