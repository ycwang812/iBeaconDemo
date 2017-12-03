//
//  Coordinate.h
//  iBeasonDemo
//
//  Created by Kim on 14/5/1.
//  Copyright (c) 2014年 Kim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
@interface Coordinate : NSObject  <NSCoding> 

@property (nonatomic, assign) int xCoordinate;
@property (nonatomic, assign) int yCoordinate;
@property (nonatomic, assign) int major;
@property (nonatomic, assign) int minor;
@property (nonatomic, retain) NSString *proximityUUID;
@property (nonatomic, retain) NSString *title;


-(NSString *) getKey;


@end
