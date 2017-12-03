//
//  FirstViewController.m
//  iBeasonDemo
//
//  Created by Kim on 14/3/31.
//  Copyright (c) 2014年 Kim. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController
ShowMapScene * scene ;
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}


- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
        // Configure the view.
    SKView * skView = (SKView *) self.skScene;
    
    if (!skView.scene) {
        skView.showsFPS = YES;
        skView.showsNodeCount = YES;
        
            // Create and configure the scene.
        scene = [ShowMapScene sceneWithSize:skView.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        
            // Present the scene.
        [skView presentScene:scene];
            }
}


- (BOOL)shouldAutorotate
{
    return YES;
}

-(BOOL)prefersStatusBarHidden {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
        // Release any cached data, images, etc that aren't in use.
}


- (IBAction)touchDown:(id)sender {
    [scene carSaveAction];
}
@end
