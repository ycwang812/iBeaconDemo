//
//  MapScene.m
//  iBeacons Demo
//
//  Created by Kim on 14/2/21.
//  Copyright (c) 2014年 Mobient. All rights reserved.
//

#import "MapScene.h"
#import "SKButton.h"
#import "SetupBeaconWindow.h"
#import "Coordinate.h"
static NSString * const kAnimalNodeName = @"movable";
@implementation MapScene
{
    SKSpriteNode *_background;
    SKSpriteNode *_selectedNode;
    SKShapeNode *_traveler;
    SetupBeaconWindow *_beaconWindow;
    NSMutableDictionary  *_beaconDict;
    int _refreshCount;
    NSDate * checkDate ;
    NSTimeInterval pingStart;

}



-(id) initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        checkDate = [[NSDate alloc] init];
        self.backgroundColor = [SKColor whiteColor];
        _background =
        [SKSpriteNode spriteNodeWithImageNamed:@"background.jpg"];
            //  _background.anchorPoint = CGPointZero;
//                    _background.position = CGPointZero;
//                    bg.zRotation = M_PI / 8;
        
        _background.position = CGPointMake(self.size.width / 2, self.size.height / 2);
//             _background.anchorPoint = CGPointMake(0.5, 0.5); // same as default
            //bg.zRotation = M_PI / 8;
        CGSize mySize = _background.size;
        NSLog(@"MapScene Size: %@", NSStringFromCGSize(mySize));
        NSLog(@"Self Size: %@", NSStringFromCGSize(self.size));
        
        _traveler = [[SKShapeNode alloc] init];
        
        CGMutablePathRef myPath = CGPathCreateMutable();
        CGPathAddArc(myPath, NULL, 0,0, 8, 0, M_PI*2, YES);
        _traveler.path = myPath;
        
        _traveler.lineWidth = 0.1;
        _traveler.fillColor = [SKColor redColor];
        _traveler.strokeColor = [SKColor whiteColor];
        _traveler.glowWidth = 0;
        [_traveler setHidden:TRUE];
        [_background addChild:_traveler];
        
        float scale = 0.0;
        if(( self.size.width / mySize.width ) > (self.size.height / mySize.height ))
        {
            scale = self.size.width / mySize.width ;
        }else
        {
            scale =self.size.height/mySize.height;
        }
        NSLog(@"Size: %f",scale);
        
        _beaconWindow = [[SetupBeaconWindow alloc] init];
        [_beaconWindow setHidden:TRUE];
        
        [_background runAction:[SKAction scaleBy:scale duration:0]];
        
        
        
        [self addChild:_background];
        
        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(managerDidRangeBeacons:)
         name:@"managerDidRangeBeacons"
         object:nil];
        _refreshCount = 0;
        
        if (_beaconDict ==nil) {
            _beaconDict =[[NSMutableDictionary alloc] init];
        }
        
    }else 
    NSLog(@"Not in Size: %@", NSStringFromCGSize(size));

    return self;
}

- (void)didMoveToView:(SKView *)view
{
    NSLog(@"didMoveToView");
    UIPinchGestureRecognizer *precog = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
    
    [self.scene.view addGestureRecognizer:precog];
}


- (void)handlePinch:(UIPinchGestureRecognizer *) recognizer
{
    
        NSLog(@"Pinch %f", recognizer.scale);
        //[_bg setScale:recognizer.scale];
    
    [_background runAction:[SKAction scaleBy:recognizer.scale duration:0]];
    recognizer.scale = 1;
}

- (void)handleLongPress:(UILongPressGestureRecognizer *) recognizer
{
    NSLog(@"handleLongPress " );
    if(recognizer.state == UIGestureRecognizerStateBegan)
    {
        CGPoint point = [recognizer locationInView: self.scene.view];
    
    NSLog(@"handleLongPress point:%@",NSStringFromCGPoint(point) );
//    CGPoint offset = CGPointSubtract(point, _traveler.position);
//    
//    CGPoint direction = CGPointNormalize(offset);
//    _velocity=CGPointMultiplyScalar(direction, 120);

    }

        //[_background runAction:[SKAction scaleBy:recognizer.scale duration:0]];
        //recognizer.scale = 1;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
        //   NSLog(@"touchesBegan %@", touches);
    UITouch *touch = [touches anyObject];
    CGPoint positionInScene = [touch locationInNode: _background];
    
    NSLog(@"touchesBegan %@", NSStringFromCGPoint(positionInScene));
    
    if([_beaconWindow isHidden])
    {
            _traveler.position = positionInScene;
            [_traveler setHidden:FALSE];
            pingStart = [checkDate timeIntervalSinceNow];
    
    }
    
    
//    [self selectNodeForTouch:positionInScene];
}

//- (void)selectNodeForTouch:(CGPoint)touchLocation {
//        //1
//    SKSpriteNode *touchedNode = (SKSpriteNode *)[self nodeAtPoint:touchLocation];
//    
//        //2
//	if(![_selectedNode isEqual:touchedNode]) {
//		[_selectedNode removeAllActions];
//		[_selectedNode runAction:[SKAction rotateToAngle:0.0f duration:0.1]];
//        
//		_selectedNode = touchedNode;
//            //3
//		if([[touchedNode name] isEqualToString:kAnimalNodeName]) {
//			SKAction *sequence = [SKAction sequence:@[[SKAction rotateByAngle:degToRad(-4.0f) duration:0.1],
//													  [SKAction rotateByAngle:0.0 duration:0.1],
//													  [SKAction rotateByAngle:degToRad(4.0f) duration:0.1]]];
//			[_selectedNode runAction:[SKAction repeatActionForever:sequence]];
//		}
//	}
//    
//}
//float degToRad(float degree) {
//	return degree / 180.0f * M_PI;
//}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
   	UITouch *touch = [touches anyObject];
	CGPoint positionInScene = [touch locationInNode:self];
	CGPoint previousPosition = [touch previousLocationInNode:self];
    
	CGPoint translation = CGPointMake( _background.position.x+ positionInScene.x - previousPosition.x, _background.position. y + positionInScene.y - previousPosition.y);
    
    NSLog(@"Size: positionInScene:%@  previousPosition:%@", NSStringFromCGPoint( positionInScene),NSStringFromCGPoint(previousPosition));
    
    [_background setPosition:translation];
        //[self panForTranslation:translation];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
      NSLog(@"touchesEnded Size: : %f ", ( pingStart - [checkDate timeIntervalSinceNow]  ));
    if([_beaconWindow isHidden] && ( pingStart - [checkDate timeIntervalSinceNow]  > 1))
    {
        UITouch *touch = [touches anyObject];
        CGPoint positionInScene = [touch locationInNode:_background];
    _beaconWindow.position = positionInScene;
    [_beaconWindow setHidden:FALSE];
     [_background addChild:_beaconWindow];
    NSLog(@"touchesEnded Size: positionInScene:%@  ", NSStringFromCGPoint( positionInScene));
    }
}

/*
 
 SKTexture *rocketTexture = [SKTexture textureWithImageNamed:@"rocket.png"];
 for (int i= 0; i< 10; i++)
 {
 SKSpriteNode *rocket = [SKSpriteNode spriteNodeWithTexture:rocketTexture];
 rocket.position = [self randomRocketLocation];
 [self addChild: rocket];
 }
 The texture object itself is just a placeholder for the actual texture data. The texture data is more resource intensive, so Sprite Kit loads it into memory only when needed.
 

 
 
 
 */



-(void)managerDidRangeBeacons :(NSNotification*) notification
{
    NSLog(@"managerDidRangeBeacons %@", notification);
    
        //reloads every 3 time for better responsiveness
    if (_refreshCount > 1){
        NSArray *availableBeaconList = [[BeaconRegionManager shared]  beaconWithId:kiBeaconPrimaryUUID];
        for (CLBeacon *beacon in availableBeaconList){
            
            if (beacon.proximity == CLProximityImmediate){
//                                    NSLog([NSString stringWithFormat:@"%@", beacon.proximityUUID.UUIDString]);
//                
//                                    NSLog([NSString stringWithFormat:@"%@", beacon.major]);
                
                [_beaconWindow updateMajor: [beacon.major stringValue  ] updateMinor: [beacon.minor stringValue]];
                
                break;
                
                
            }
            
        }
        
        [self reDrawAllBeacon];
        
        _refreshCount = 0;
        
    }
    _refreshCount++;
    
}

-(void)reDrawAllBeacon
{
    CGMutablePathRef myPath = CGPathCreateMutable();
    CGPathAddArc(myPath, NULL, 0,0, 8, 0, M_PI*2, YES);

    NSDictionary *coordinateDict = [[BeaconRegionManager shared] getCorrdinateContentsDict];
    
    for(Coordinate *coordinate in [coordinateDict allValues])
    {
    
    if (coordinate.major ==0 && coordinate.minor==0) {
        continue;
    }
       if ([_beaconDict objectForKey: [coordinate getKey] ]!=nil) {
           SKShapeNode *shapeTemp = [_beaconDict objectForKey:[coordinate getKey]];
            shapeTemp.position = CGPointMake(coordinate.xCoordinate,coordinate.yCoordinate);
           
       }else{
           SKShapeNode *beaconPoint = [[SKShapeNode alloc] init];
           beaconPoint.path = myPath;
           
           beaconPoint.lineWidth = 0.1;
           
           beaconPoint.strokeColor = [SKColor whiteColor];
           beaconPoint.glowWidth = 0;
           
           beaconPoint.fillColor = [SKColor blueColor];
           beaconPoint.position = CGPointMake(coordinate.xCoordinate,coordinate.yCoordinate);
           
           [_beaconDict setObject:beaconPoint forKey:[coordinate getKey]];
           
           [_background addChild:beaconPoint];
       }
    
    
    

    }
    
    
    
    
}


@end
