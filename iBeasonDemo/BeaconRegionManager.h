//
//  BeaconRegionManager.h
//  iBeasonDemo
//
//  Created by Kim on 14/4/13.
//  Copyright (c) 2014年 Kim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "BeaconPlist.h"
#import "BeaconDemoValues.h"
#import "Coordinate.h"
#define DEFINE_SHARED_INSTANCE_USING_BLOCK(block) \
static dispatch_once_t pred = 0; \
__strong static id _sharedObject = nil; \
dispatch_once(&pred, ^{ \
_sharedObject = block(); \
}); \
return _sharedObject; \



@interface BeaconRegionManager : NSObject <CLLocationManagerDelegate>


@property  (nonatomic, assign) BOOL ibeaconsEnabled;
//plist  for managing local
@property (strong, nonatomic, readonly) BeaconPlist *plistManager;
    //detailed ranged dictionary ordered by zone (unknown, immediate, near, far)
@property (strong, nonatomic, readonly) NSDictionary *rangedBeaconsDetailed;
    //beacons that are currently monitored (same as available managed beacon regions by default)
@property (strong, nonatomic, readonly) NSSet *monitoredBeaconRegions;
    //all the managed regions loaded from the plist manager, data store for the available regions
@property (strong, nonatomic, readonly) NSArray *availableBeaconRegionsList;



@property (strong, nonatomic) NSMutableDictionary *beaconStats;

+ (id)shared;
-(void)startManager;

    //beacon and beacon region getters
-(NSArray *)beaconWithId:(NSString *)identifier;
-(Coordinate  *)getCorrdinateContentsDict:(NSString *)identifier;
-( NSDictionary  *)getCorrdinateContentsDict;

-(void)syncMonitoredRegions;
-(void)loadAvailableRegions;

-(void)removeCorrdinateContent : (Coordinate *)delCoordinate;
-(void)addCorrdinateContent : (Coordinate *)addCoordinate;



@end
