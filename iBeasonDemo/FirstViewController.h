//
//  FirstViewController.h
//  iBeasonDemo
//
//  Created by Kim on 14/3/31.
//  Copyright (c) 2014年 Kim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import "ShowMapScene.h"
@interface FirstViewController : UIViewController
@property (weak, nonatomic) IBOutlet SKView *skScene;

- (IBAction)touchDown:(id)sender;
@end
