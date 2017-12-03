//
//  MapScene.m
//  iBeacons Demo
//
//  Created by Kim on 14/2/21.
//  Copyright (c) 2014年 Mobient. All rights reserved.
//

#import "ShowMapScene.h"
#import "SKButton.h"
#import "SetupBeaconWindow.h"
static NSString * const kAnimalNodeName = @"movable";
@implementation ShowMapScene
{
    SKSpriteNode *_background;
    SKSpriteNode *_selectedNode;
    
    SKButton *_carSaveButton ;

    NSMutableDictionary  *_beaconDict;
    
    int _refreshCount;
    SKShapeNode *humanPoint ;
    
//    SKSpriteNode *carPoint;

}



-(id) initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        [[BeaconRegionManager shared] startManager];
        [[BeaconRegionManager shared] syncMonitoredRegions];
        
        self.backgroundColor = [SKColor whiteColor];
        _background =
        [SKSpriteNode spriteNodeWithImageNamed:@"background.jpg"];
                _background.position = CGPointMake(self.size.width / 2, self.size.height / 2);

            //bg.zRotation = M_PI / 8;
        CGSize mySize = _background.size;
        NSLog(@"Size: %@", NSStringFromCGSize(mySize));
        NSLog(@"Self Size: %@", NSStringFromCGSize(self.size));
        
        
        
        
        float scale = 0.0;
        if(( self.size.width / mySize.width ) > (self.size.height / mySize.height ))
        {
            scale = self.size.width / mySize.width ;
        }else
        {
            scale =self.size.height/mySize.height;
        }
        NSLog(@"ShowMap Size: %f",scale);
        
        
        [_background runAction:[SKAction scaleBy:scale duration:0]];
        
        
        
        [self addChild:_background];
        
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(managerDidRangeBeacons:)
         name:@"managerDidRangeBeacons"
         object:nil];
        _refreshCount = 0;
        
        if(_beaconDict ==nil)
            _beaconDict = [[NSMutableDictionary alloc] init];
        
        CGMutablePathRef myPath = CGPathCreateMutable();
        CGPathAddArc(myPath, NULL, 0,0, 8, 0, M_PI*2, YES);
        humanPoint = [[SKShapeNode alloc] init];
        humanPoint.path = myPath;
        
        humanPoint.lineWidth = 0.1;
        
        humanPoint.strokeColor = [SKColor blackColor];
        humanPoint.glowWidth = 0;
        humanPoint.fillColor = [SKColor brownColor];
        humanPoint.hidden = true;
        humanPoint.position =CGPointMake(0,0);
        
//        carPoint =
//        [SKSpriteNode spriteNodeWithImageNamed:@"muscle_car.png"];
//        carPoint.hidden = true;
//        carPoint.position =CGPointMake(0,0);
        
        
        

        

        
        
        _carSaveButton = [[SKButton alloc] initWithImageNamed:@"muscle_car.png"];
        
        
        Coordinate *coordinateTemp = [[BeaconRegionManager shared] getCorrdinateContentsDict:kCarKey];
        if(coordinateTemp!=nil)
        {
        NSLog(@"corr is not nil");
        
            [_carSaveButton setScale:1];

            _carSaveButton.position = CGPointMake(coordinateTemp.xCoordinate ,coordinateTemp.yCoordinate);
             [_background addChild:_carSaveButton];
            
        }else{
//            NSLog(@"corr is  nil");
//            [_carSaveButton setScale:4];
//            _carSaveButton.position = CGPointMake(_background.size.width/2-200 ,_background.size.height/2 -200);
        }
//        [_carSaveButton setTouchUpInsideTarget:self action:@selector(carSaveAction)];
       
        
        
               
        

        
    }else
    NSLog(@"Not in Size: %@", NSStringFromCGSize(size));

    return self;
}



- (void)didMoveToView:(SKView *)view
{
//    NSLog(@"didMoveToView");
    UIPinchGestureRecognizer *precog = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    
    [self.scene.view addGestureRecognizer:precog];
}


- (void)handlePinch:(UIPinchGestureRecognizer *) recognizer
{
    
//        NSLog(@"Pinch %f", recognizer.scale);
        //[_bg setScale:recognizer.scale];
    
    [_background runAction:[SKAction scaleBy:recognizer.scale duration:0]];
    recognizer.scale = 1;
}

- (void)handleLongPress:(UILongPressGestureRecognizer *) recognizer
{
//    NSLog(@"handleLongPress " );
    if(recognizer.state == UIGestureRecognizerStateBegan)
    {
//        CGPoint point = [recognizer locationInView: self.scene.view];
    
//    NSLog(@"handleLongPress point:%@",NSStringFromCGPoint(point) );

  
    
    }
    
 }




- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
   	UITouch *touch = [touches anyObject];
	CGPoint positionInScene = [touch locationInNode:self];
	CGPoint previousPosition = [touch previousLocationInNode:self];
    
	CGPoint translation = CGPointMake( _background.position.x+ positionInScene.x - previousPosition.x, _background.position. y + positionInScene.y - previousPosition.y);
    
//    NSLog(@"Size: positionInScene:%@  previousPosition:%@", NSStringFromCGPoint( positionInScene),NSStringFromCGPoint(previousPosition));
    
    [_background setPosition:translation];
        //[self panForTranslation:translation];
}






-(void)managerDidRangeBeacons :(NSNotification*) notification
{
    
    
        //reloads every 3 time for better responsiveness
//    if (_refreshCount > 2){
        CGMutablePathRef myPath = CGPathCreateMutable();
        CGPathAddArc(myPath, NULL, 0,0, 8, 0, M_PI*2, YES);
        NSArray *availableBeaconList = [[BeaconRegionManager shared]  beaconWithId:kiBeaconPrimaryUUID];
        //[_background removeAllChildren];
//    for (SKShapeNode *nodeTemp in [_beaconDict allValues]) {
//        
//       
//        [nodeTemp removeFromParent ];
//        
//        
//    }
        NSMutableArray *pointItems = [[NSMutableArray alloc] init];
        NSMutableArray *beaconItems = [[NSMutableArray alloc] init];
    
        Boolean isDrawEnable = [availableBeaconList count]>=3?TRUE:FALSE;
        for (CLBeacon *beacon in availableBeaconList){
            NSLog(@"Beacon %f %d %@",beacon.accuracy,beacon.rssi , beacon);

           Coordinate *coordinate = [[BeaconRegionManager shared] getCorrdinateContentsDict:[NSString stringWithFormat:@"%@-%@-%@",[beacon.proximityUUID UUIDString],beacon.major,beacon.minor]];
            
            if(coordinate ==nil) continue;
            
            
            if ([_beaconDict objectForKey: [coordinate getKey] ]!=nil) {
//                SKShapeNode *shapeTemp = [_beaconDict objectForKey:[coordinate getKey]];
                /*
                if (beacon.proximity == CLProximityImmediate){
                    shapeTemp.fillColor = [SKColor redColor];
                }
                if (beacon.proximity == CLProximityNear){
                    shapeTemp.fillColor = [SKColor blueColor];
                }
                if (beacon.proximity == CLProximityFar){
                    shapeTemp.fillColor = [SKColor grayColor];
                }
                */
                switch(beacon.proximity) {
                    case CLProximityFar:
//                        shapeTemp.fillColor = [SKColor grayColor];
                        
                        break;
                    case CLProximityNear:
//                        shapeTemp.fillColor = [SKColor blueColor];
                        break;
                    case CLProximityImmediate:
                            // message = @"You are in the immediate proximity of the beacon";
//                        shapeTemp.fillColor = [SKColor redColor];
                        break;
                    case CLProximityUnknown:
                        break;
                }

                if(isDrawEnable && [pointItems count]<=3)
                {
                  [pointItems  addObject: @[[NSNumber numberWithInt:coordinate.xCoordinate],[NSNumber numberWithInt:coordinate.yCoordinate]]];
                  [beaconItems addObject: beacon];
                }
                
//                shapeTemp.position = CGPointMake(coordinate.xCoordinate,coordinate.yCoordinate);
//                NSLog(@"A:beacon %f %f %f",beacon.accuracy ,shapeTemp.position.x ,shapeTemp.position.y );

//                [_background addChild:shapeTemp];
                
            }else{
                
//                SKShapeNode *beaconPoint = [[SKShapeNode alloc] init];
//                beaconPoint.path = myPath;
//                
//                beaconPoint.lineWidth = 0.1;
//                
//                beaconPoint.strokeColor = [SKColor whiteColor];
//                beaconPoint.glowWidth = 0;
//                
//                
//                switch(beacon.proximity) {
//                    case CLProximityFar:
//                        beaconPoint.fillColor = [SKColor grayColor];
//                        break;
//                    case CLProximityNear:
//                        beaconPoint.fillColor = [SKColor blueColor];
//                        break;
//                    case CLProximityImmediate:
//                            // message = @"You are in the immediate proximity of the beacon";
//                        beaconPoint.fillColor = [SKColor redColor];
//                        break;
//                    case CLProximityUnknown:
//                        break;
//                }
                /*
                if (beacon.proximity == CLProximityImmediate){
                    beaconPoint.fillColor = [SKColor redColor];
                }
                if (beacon.proximity == CLProximityNear){
                    beaconPoint.fillColor = [SKColor blueColor];
                }
                if (beacon.proximity == CLProximityFar){
                    beaconPoint.fillColor = [SKColor grayColor];
                }*/
                
//                beaconPoint.position = CGPointMake(coordinate.xCoordinate,coordinate.yCoordinate);
//                [_beaconDict setObject:beaconPoint forKey:[coordinate getKey]];
                    //draws beacon
//                [_background addChild:beaconPoint];
                
                if(isDrawEnable && [pointItems count]<=3)
                {
                    [pointItems  addObject: @[[NSNumber numberWithInt:coordinate.xCoordinate],[NSNumber numberWithInt:coordinate.yCoordinate]]];
                    [beaconItems addObject: beacon];
                }
                
            }

            
        }
   
        if(isDrawEnable && [pointItems count]>=3)
        {
        
        
              CGPoint human = trilateration ([pointItems objectAtIndex:0] ,[(CLBeacon *)[beaconItems objectAtIndex:0] accuracy]*100  , [pointItems objectAtIndex:1] ,[(CLBeacon *)[beaconItems objectAtIndex:1] accuracy]*100 , [pointItems objectAtIndex:2] ,[(CLBeacon *)[beaconItems objectAtIndex:2] accuracy]*100 );
         NSLog(@"human:%f %f",human.x,human.y);
        humanPoint.hidden = FALSE;
        humanPoint.position = human;
        [_background addChild: humanPoint];
        
        
        
        }else{
            
            
        }
//        [_background addChild:_carSaveButton];
    
    
    
}

CGPoint trilateration ( NSArray* P1 ,float distance1  ,NSArray* P2, float distance2  , NSArray*  P3 ,float distance3)
{
//        //P1,P2,P3 is the point and 2-dimension vector
//    NSMutableArray *P1 = [[NSMutableArray alloc] initWithCapacity:0];
//    [P1 addObject:[NSNumber numberWithDouble:3]];
//    [P1 addObject:[NSNumber numberWithDouble:0]];
//    
//    
//    NSMutableArray *P2 = [[NSMutableArray alloc] initWithCapacity:0];
//    [P2 addObject:[NSNumber numberWithDouble:9]];
//    [P2 addObject:[NSNumber numberWithDouble:0]];
//    
//    NSMutableArray *P3 = [[NSMutableArray alloc] initWithCapacity:0];
//    [P3 addObject:[NSNumber numberWithDouble:4]];
//    [P3 addObject:[NSNumber numberWithDouble:8]];
//    
        //this is the distance between all the points and the unknown point
    float DistA = distance1;
    float DistB = distance2;
    float DistC = distance3;
    
//    NSLog(@"human:%f %f %f",distance1,distance2,distance3);
    
        // ex = (P2 - P1)/(numpy.linalg.norm(P2 - P1))
    NSMutableArray *ex = [[NSMutableArray alloc] initWithCapacity:0];
    double temp = 0;
    for (int i = 0; i < [P1 count]; i++) {
        double t1 = [[P2 objectAtIndex:i] doubleValue];
        double t2 = [[P1 objectAtIndex:i] doubleValue];
        double t = t1 - t2;
        temp += (t*t);
    }
    for (int i = 0; i < [P1 count]; i++) {
        double t1 = [[P2 objectAtIndex:i] doubleValue];
        double t2 = [[P1 objectAtIndex:i] doubleValue];
        double exx = (t1 - t2)/sqrt(temp);
        [ex addObject:[NSNumber numberWithDouble:exx]];
    }
    
        // i = dot(ex, P3 - P1)
    NSMutableArray *p3p1 = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = 0; i < [P3 count]; i++) {
        double t1 = [[P3 objectAtIndex:i] doubleValue];
        double t2 = [[P1 objectAtIndex:i] doubleValue];
        double t3 = t1 - t2;
        [p3p1 addObject:[NSNumber numberWithDouble:t3]];
    }
    
    double ival = 0;
    for (int i = 0; i < [ex count]; i++) {
        double t1 = [[ex objectAtIndex:i] doubleValue];
        double t2 = [[p3p1 objectAtIndex:i] doubleValue];
        ival += (t1*t2);
    }
    
        // ey = (P3 - P1 - i*ex)/(numpy.linalg.norm(P3 - P1 - i*ex))
    NSMutableArray *ey = [[NSMutableArray alloc] initWithCapacity:0];
    double p3p1i = 0;
    for (int  i = 0; i < [P3 count]; i++) {
        double t1 = [[P3 objectAtIndex:i] doubleValue];
        double t2 = [[P1 objectAtIndex:i] doubleValue];
        double t3 = [[ex objectAtIndex:i] doubleValue] * ival;
        double t = t1 - t2 -t3;
        p3p1i += (t*t);
    }
    for (int i = 0; i < [P3 count]; i++) {
        double t1 = [[P3 objectAtIndex:i] doubleValue];
        double t2 = [[P1 objectAtIndex:i] doubleValue];
        double t3 = [[ex objectAtIndex:i] doubleValue] * ival;
        double eyy = (t1 - t2 - t3)/sqrt(p3p1i);
        [ey addObject:[NSNumber numberWithDouble:eyy]];
    }
    
    
        // ez = numpy.cross(ex,ey)
        // if 2-dimensional vector then ez = 0
    NSMutableArray *ez = [[NSMutableArray alloc] initWithCapacity:0];
    double ezx;
    double ezy;
    double ezz;
    if ([P1 count] !=3){
        ezx = 0;
        ezy = 0;
        ezz = 0;
        
    }else{
        ezx = ([[ex objectAtIndex:1] doubleValue]*[[ey objectAtIndex:2]doubleValue]) - ([[ex objectAtIndex:2]doubleValue]*[[ey objectAtIndex:1]doubleValue]);
        ezy = ([[ex objectAtIndex:2] doubleValue]*[[ey objectAtIndex:0]doubleValue]) - ([[ex objectAtIndex:0]doubleValue]*[[ey objectAtIndex:2]doubleValue]);
        ezz = ([[ex objectAtIndex:0] doubleValue]*[[ey objectAtIndex:1]doubleValue]) - ([[ex objectAtIndex:1]doubleValue]*[[ey objectAtIndex:0]doubleValue]);
        
    }
    
    [ez addObject:[NSNumber numberWithDouble:ezx]];
    [ez addObject:[NSNumber numberWithDouble:ezy]];
    [ez addObject:[NSNumber numberWithDouble:ezz]];
    
    
        // d = numpy.linalg.norm(P2 - P1)
    double d = sqrt(temp);
    
        // j = dot(ey, P3 - P1)
    double jval = 0;
    for (int i = 0; i < [ey count]; i++) {
        double t1 = [[ey objectAtIndex:i] doubleValue];
        double t2 = [[p3p1 objectAtIndex:i] doubleValue];
        jval += (t1*t2);
    }
    
        // x = (pow(DistA,2) - pow(DistB,2) + pow(d,2))/(2*d)
    double xval = (pow(DistA,2) - pow(DistB,2) + pow(d,2))/(2*d);
    
        // y = ((pow(DistA,2) - pow(DistC,2) + pow(i,2) + pow(j,2))/(2*j)) - ((i/j)*x)
    double yval = ((pow(DistA,2) - pow(DistC,2) + pow(ival,2) + pow(jval,2))/(2*jval)) - ((ival/jval)*xval);
    
        // z = sqrt(pow(DistA,2) - pow(x,2) - pow(y,2))
        // if 2-dimensional vector then z = 0
    double zval;
    if ([P1 count] !=3){
        zval = 0;
    }else{
        zval = sqrt(pow(DistA,2) - pow(xval,2) - pow(yval,2));
    }
    
        // triPt = P1 + x*ex + y*ey + z*ez
    NSMutableArray *triPt = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = 0; i < [P1 count]; i++) {
        double t1 = [[P1 objectAtIndex:i] doubleValue];
        double t2 = [[ex objectAtIndex:i] doubleValue] * xval;
        double t3 = [[ey objectAtIndex:i] doubleValue] * yval;
        double t4 = [[ez objectAtIndex:i] doubleValue] * zval;
        double triptx = t1+t2+t3+t4;
        [triPt addObject:[NSNumber numberWithDouble:triptx]];
    }
    
   
    return CGPointMake([[triPt objectAtIndex:0] floatValue],[[triPt objectAtIndex:1] floatValue]);
    
}

-(void)carSaveAction
{
    
    
    
    NSLog(@"save corr is nil");
    
    Coordinate *coordinateTemp = [[Coordinate alloc] init] ;
    [coordinateTemp setXCoordinate: humanPoint.position.x ];
    [coordinateTemp setYCoordinate: humanPoint.position.y ];
    [coordinateTemp setMajor:-1 ];
    [coordinateTemp setMinor:-1 ];
    [coordinateTemp setTitle:@"CAR" ];
    [coordinateTemp setProximityUUID: kCarUUID];
    
    [[BeaconRegionManager shared] addCorrdinateContent:coordinateTemp];
    [[BeaconRegionManager shared] syncMonitoredRegions];
    
    _carSaveButton.position = CGPointMake(coordinateTemp.xCoordinate ,coordinateTemp.yCoordinate);
     
    
//    CGPoint clickPoint = humanPoint.position;
//    CGPoint charPos = _carSaveButton.position;
//    CGFloat distance = sqrtf((clickPoint.x-charPos.x)*(clickPoint.x-charPos.x)+
//                             (clickPoint.y-charPos.y)*(clickPoint.y-charPos.y));
    
//    SKAction *moveTo = [SKAction moveTo:clickPoint duration:10];
//    SKAction *zoom = [SKAction scaleTo:0.5 duration:5];
//       [_carSaveButton  runAction: [SKAction  sequence:@[moveTo, zoom]]];
    
    
    
//    else{
//        NSLog(@"save corr is nou nil");
//       
//        [[BeaconRegionManager shared] removeCorrdinateContent:coordinateTemp];
//        [[BeaconRegionManager shared] syncMonitoredRegions];
//        CGPoint clickPoint = CGPointMake(_background.size.width/2-200 ,_background.size.height/2 -200);
////        CGPoint charPos = _carSaveButton.position;
////        CGFloat distance = sqrtf((clickPoint.x-charPos.x)*(clickPoint.x-charPos.x)+
////                                 (clickPoint.y-charPos.y)*(clickPoint.y-charPos.y));
//        
//        SKAction *moveTo = [SKAction moveTo:clickPoint duration:10];
//        SKAction *zoom = [SKAction scaleTo:4 duration:5];
//        
//        [_carSaveButton runAction:[SKAction sequence:@[moveTo, zoom]]];
//
//        
//        
//    }
    
    
    


}

@end
