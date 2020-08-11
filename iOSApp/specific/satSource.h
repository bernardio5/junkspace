//
//  NewGameMapSource.h
//  gpsWar01
//
//  Created by Neal McDonald on 4/5/10.
//  This class holds all the data the server sends about available maps

#import <Foundation/Foundation.h>

#import "satBall.h"


@interface satSource : NSObject <NSXMLParserDelegate> {
	NSXMLParser *theParser;
	NSData *aData; 
	int inMap;
    
    satInitRec space; 
    
    satBall *allSats;    
    int satCtr; 
	int inType;
}

- (void)parse:(satBall*)sats; 

- (int)loadedCount; 

@end
