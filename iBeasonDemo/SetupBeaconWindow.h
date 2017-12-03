//
//  SetupBeaconWindow.h
//  iBeasonDemo
//
//  Created by Kim on 14/4/3.
//  Copyright (c) 2014年 Kim. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "BeaconDemoValues.h"
#import "BeaconRegionManager.h"

@interface SetupBeaconWindow : SKSpriteNode
-(void) updateMajor: (NSString *)majorText  updateMinor: (NSString *) minorText;


@end
