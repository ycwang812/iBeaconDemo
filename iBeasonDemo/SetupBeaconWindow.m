//
//  SetupBeaconWindow.m
//  iBeasonDemo
//
//  Created by Kim on 14/4/3.
//  Copyright (c) 2014年 Kim. All rights reserved.
//

#import "SetupBeaconWindow.h"
#import "SKButton.h"

@implementation SetupBeaconWindow
{
    @private
    SKButton *_rescanButton ;
    SKButton *_closeButton ;
    SKNode *_labelNode;
    SKLabelNode *_minorNode;
    SKLabelNode *_majorNode;
    NSString* minorNow ;
    NSString* majorNow ;
    
    Coordinate *_coordinateLarge;
    
}

-(id) init
{
    self = [super initWithImageNamed:@"setupwindow.png"];
        //Load the available managed beacon regions and update monitored regions
    
    

    if (self != nil) {
        [[BeaconRegionManager shared] startManager];
        
        NSLog(@"init::startManager" );
        
            // [self setAnchorPoint:CGPointZero];
            // [self setPosition:CGPointZero];
        
        _labelNode =  [[SKNode alloc] init];
        
        _minorNode = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
        _minorNode.fontSize = 20;
        _minorNode.fontColor = [SKColor redColor];
        _minorNode.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
        _minorNode.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame)+44);//CGPointMake(30,30);
        
        _minorNode.text = @"Minor";
        
        _majorNode = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
        _majorNode.fontSize = 20;
        _majorNode.fontColor = [SKColor redColor];
        _majorNode.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
        _majorNode.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame)-22);//CGPointMake(30,30);
        
        _majorNode.text = @"Major";
        
        [self addChild:_minorNode];
        [self addChild:_majorNode];
        
        _closeButton = [[SKButton alloc] initWithImageNamedNormal:@"no_bk.png" selected:@"no_bk.png"];
        [_closeButton setPosition: CGPointMake(CGRectGetMidX(self.frame)-36,CGRectGetMinY(self.frame)+33)];
        [_closeButton setTouchUpInsideTarget:self action:@selector(closeAction)];
            // [self addChild:_rescanButton];

        
        
        
        [self addChild:_closeButton];
        
        
        _rescanButton = [[SKButton alloc] initWithImageNamedNormal:@"ok_bk.png" selected:@"ok_bk.png"];
        [_rescanButton setPosition: CGPointMake(CGRectGetMidX(self.frame)+36,CGRectGetMinY(self.frame)+33)];
        [_rescanButton setTouchUpInsideTarget:self action:@selector(comfirmAction)];
            // [self addChild:_rescanButton];
        
        
        
        
        [self addChild:_rescanButton];
        
        
        
    }
    if(_coordinateLarge ==nil)
    {
        _coordinateLarge = [[Coordinate alloc] init] ;
        [_coordinateLarge setXCoordinate:-1 ];
        [_coordinateLarge setYCoordinate:-1 ];
        [_coordinateLarge setMajor:0 ];
        [_coordinateLarge setMinor:0 ];
    [_coordinateLarge setTitle:kiBeaconIndetify ];
        [_coordinateLarge setProximityUUID: kiBeaconPrimaryUUID];
        [[BeaconRegionManager shared] addCorrdinateContent:_coordinateLarge];
        [[BeaconRegionManager shared] startManager];
    }
    
    
    return self;
}


-(void) updateMajor: (NSString *)majorText  updateMinor: (NSString *) minorText
{
    majorNow = majorText;
    minorNow = minorText;
    _majorNode.text = [NSString stringWithFormat:@"Major:%@",majorText];
    _minorNode.text = [NSString stringWithFormat:@"Minor:%@",minorText];
    
}




-(void)closeAction
{
    
    
    
    [self removeFromParent];
    [self setHidden:TRUE];
    [self updateMajor:@"" updateMinor:@""];
}

-(void)comfirmAction
{
    
    Coordinate *coordinateTemp = [[Coordinate alloc] init] ;
    [coordinateTemp setXCoordinate: self.position.x ];
    [coordinateTemp setYCoordinate: self.position.y ];
    [coordinateTemp setMajor:[majorNow intValue] ];
    [coordinateTemp setMinor:[minorNow intValue] ];
    [coordinateTemp setTitle:kiBeaconIndetify ];
    [coordinateTemp setProximityUUID: kiBeaconPrimaryUUID];
    
    NSLog(@"close::%@ %@ %d" ,[coordinateTemp getKey],_majorNode.text,[_majorNode.text intValue]);
    [[BeaconRegionManager shared] addCorrdinateContent:coordinateTemp];
    [[BeaconRegionManager shared] syncMonitoredRegions];
    
    
    [self removeFromParent];
    [self setHidden:TRUE];
    [self updateMajor:@"" updateMinor:@""];
}

@end
