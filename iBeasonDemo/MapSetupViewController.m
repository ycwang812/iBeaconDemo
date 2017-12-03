//
//  ImageViewController.m
//  iBeacons Demo
//
//  Created by Kim on 14/2/21.
//  Copyright (c) 2014年 Mobient. All rights reserved.
//

#import "MapSetupViewController.h"

@interface MapSetupViewController ()

@end

@implementation MapSetupViewController


- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
        // Configure the view.
    SKView * skView = (SKView *) self.skScene;
    
    if (!skView.scene) {
        skView.showsFPS = YES;
        skView.showsNodeCount = YES;
        
            // Create and configure the scene.
        SKScene * scene = [MapScene sceneWithSize:skView.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        
            // Present the scene.
        [skView presentScene:scene];
    }
}



//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//        // Configure the view.
//    SKView * skView = (SKView *)self.skScene;
//    
//    if (!skView.scene) {
//        skView.showsFPS = YES;
//        skView.showsNodeCount = YES;
//            // Create and configure the scene.
//        SKScene * scene = [MapScene sceneWithSize:skView.bounds.size];
//        scene.scaleMode = SKSceneScaleModeAspectFill;
//        
//        
//            // Present the scene.
//        [skView presentScene:scene];
//        
//    }
//
//    
//            // Do any additional setup after loading the view.
//}


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


@end
