//
//  NewGameMapSource.m
//  gpsWar01
//
//  Created by Neal McDonald on 4/5/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "satSource.h"

@implementation satSource


/*
 
 <satdata>
 <sat>
 <name>VANGUARD R/B
 </name><year>1959</year>
 <count>001</count><day>272.90211476</day>
 <ic>032.8952</ic><ra>144.6277</ra>
 <ec>1680509</ec><ap>172.4365</ap>
 <an>190.5197</an><mo>11.413728941</mo>
 </sat>
 <sat>
 <name>VANGUARD R/B
 </name><year>1958</year>
 <count>002</count><day>272.48816923</day>
 <ic>034.2660</ic><ra>317.6572</ra>
 <ec>2029763</ec><ap>040.2543</ap>
 <an>333.1878</an><mo>10.480960290</mo>
 </sat>
 <sat>
 <name>THOR ABLESTAR R/B
 </name><year>1960</year>
 <count>007</count><day>272.52596909</day>
 <ic>066.6652</ic><ra>272.3620</ra>

 
 
 
 
 
 */
// init everything but don't start
- (id)init {
	if ((self = [super init])) {
		space.dmdt = 0.0; 
        space.dmdtdt = 0.0;
		inType = 0; 
	}
	return self;
}


// start after given a place to put the results
- (void)parse:(satBall*)sats {
    
    allSats = sats;
    satCtr = 0; 
    inType = 0; 
 //   NSString *fname = [[NSBundle mainBundle] pathForResource:@"stars" ofType:@"xml"];
 //   aData = [NSData dataWithContentsOfFile: fname]; //[NSString pathWithComponents:segments]];
    
    NSString *fname = [[NSBundle mainBundle] pathForResource:@"catclip" ofType:@"xml"];
    aData = [NSData dataWithContentsOfFile: fname]; //[NSString pathWithComponents:segments]];
    
    theParser = [[NSXMLParser alloc] initWithData:aData ];	
    [theParser setDelegate:self];
    [theParser setShouldResolveExternalEntities:YES];
    [theParser parse]; // return value not used
    
}


- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {

	if ([elementName isEqualToString:@"name"]) { inType = 1; }
	if ([elementName isEqualToString:@"norad"]) { inType = 2; }
	if ([elementName isEqualToString:@"count"]) { inType = 3; }
	if ([elementName isEqualToString:@"day"]) { inType = 4; }
    
	if ([elementName isEqualToString:@"ic"]) { inType = 5; }
	if ([elementName isEqualToString:@"ra"]) { inType = 6; }
	if ([elementName isEqualToString:@"ec"]) { inType = 7; }
	if ([elementName isEqualToString:@"ap"]) { inType = 8; }
	if ([elementName isEqualToString:@"an"]) { inType = 9; }
	if ([elementName isEqualToString:@"mo"]) { inType = 10; }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    float mary; 
    
    if (inType>1) { 
        mary = [string doubleValue]; 
    }
    
	switch (inType) { 
        case 1: 
            [allSats takeName: string]; 
            break; 
        case 2: space.objectID = (int)mary; break; 
        case 3: space.RevNumber = (int)mary; break; 
        case 4: space.epoch = mary; break; 
            
        case 5: space.OID = mary; break; 
        case 6: space.RAAN = mary; break; 
        case 7: space.eccentricity = mary; break; 
        case 8: space.ArgPerg = mary; break; 
        case 9: space.MeanAnomaly = mary; break; 
        case 10: 
            space.MeanMotion = mary; 
            if (satCtr<NUM_SATS) { 
                [allSats addSat: &space]; 
                ++satCtr; 
            }
            break; 
	}	
    inType = 0; 
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	inType = 0; 
}


- (int)loadedCount { return satCtr; }

@end
