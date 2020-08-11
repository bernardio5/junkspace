


//<stars>
//<star><mag>3.560000</mag><ra>0.036281</ra><dc>0.507726</dc></star>

#import "starSource.h"

@implementation starSource



// start after given a place to put the results
- (void)parse:(starBall*)stars {    
    allStars = stars;
    starCtr = 0; 
    inType = 0; 
    
    NSString *fname = [[NSBundle mainBundle] pathForResource:@"stars" ofType:@"xml"];
    aData = [NSData dataWithContentsOfFile: fname]; //[NSString pathWithComponents:segments]];
    
    theParser = [[NSXMLParser alloc] initWithData:aData ];	
    [theParser setDelegate:self];
    [theParser setShouldResolveExternalEntities:YES];
    [theParser parse]; // return value not used
}





- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
	if ([elementName isEqualToString:@"mag"]) { inType = 1; }
	if ([elementName isEqualToString:@"ra"]) { inType = 2; }
	if ([elementName isEqualToString:@"dc"]) { inType = 3; }
	if ([elementName isEqualToString:@"con"]) { inType = 4; }
}




- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	switch (inType) { 
        case 1: 
            // get the item tagged with "id" out of the dictionary
            //NSLog(@" %@" , [attributeDict objectForKey:@"title"]); 
            mag = [string doubleValue];
            if (mag<1.0) { mag=1.0; }  // largest
            if (mag>7.0) { mag=7.0; }  // smallest
            mag = (7.0-mag)*50.0;
            
            inType = 0; 
            break; 
        case 2: 
            ra = [string doubleValue];
            inType = 0; 
            break; 
        case 3: 
            dc = [string doubleValue];
            if (starCtr<890) { 
                [allStars addStar: con: ra+1.57: dc: mag ];
                starCtr++; 
            }
            inType = 0; 
            break; 
        case 4: 
            //NSLog(@" %@" , [attributeDict objectForKey:@"id"]); 
            con = [string intValue];
            inType = 0; 
            break; 
	}	
}




- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	inType = 0; 
}


- (int)loadedCount { return starCtr; }


@end
