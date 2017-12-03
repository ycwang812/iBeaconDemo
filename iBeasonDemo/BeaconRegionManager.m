//
//  BeaconRegionManager.m
//  iBeasonDemo
//
//  Created by Kim on 14/4/13.
//  Copyright (c) 2014年 Kim. All rights reserved.
//

#import "BeaconRegionManager.h"

@interface BeaconRegionManager ()

@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation BeaconRegionManager
{
@private
    int _monitoredRegionCount;
    
        //temporary store for detailed ranging
    NSMutableDictionary *_currentRangedBeacons;
}

+ (BeaconRegionManager *)shared
{
   
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        return [[self alloc] init];
    });
}

-(BeaconRegionManager *)init
{
    self = [super init];
    NSLog(@"beaconRegion::init" );
    _plistManager = [[BeaconPlist alloc] init];
    [_plistManager loadLocalPlist];
    
    switch ([CLLocationManager authorizationStatus]) {
        case kCLAuthorizationStatusAuthorizedAlways:
            NSLog(@"Authorized Always");
            break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            NSLog(@"Authorized when in use");
            break;
        case kCLAuthorizationStatusDenied:
            NSLog(@"Denied");
            break;
        case kCLAuthorizationStatusNotDetermined:
            NSLog(@"Not determined");
            break;
        case kCLAuthorizationStatusRestricted:
            NSLog(@"Restricted");
            break;
            
        default:
            break;
    }
    self.locationManager = [[CLLocationManager alloc] init];
    if([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.locationManager requestAlwaysAuthorization];
    }
    self.locationManager.delegate = self;
    self.locationManager.pausesLocationUpdatesAutomatically = NO;
    
    
//    self.locationManager = [[CLLocationManager alloc] init];
//    self.locationManager.delegate = self;
//        // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
//    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
//        [self.locationManager requestWhenInUseAuthorization];
//    }
    
//    [self.locationManager startUpdatingLocation];
    _currentRangedBeacons = [[NSMutableDictionary alloc] init];
    _monitoredRegionCount = 0;
    
    return self;
}

-(void)startManager
{
        //clear monitoring on store location manager regions
    [[BeaconRegionManager shared] stopMonitoringAllBeaconRegions];
        //initialize ibeacon manager, load iBeacon plist, load available regions, start monitoring available regions
    [[BeaconRegionManager shared] loadAvailableRegions];
    [[BeaconRegionManager shared] startMonitoringAllAvailableBeaconRegions];
    NSLog(@"beaconRegion::startManager" );
    
    }

-(void)stopManager
{
        //clear monitoring on store location manager regions
    [[BeaconRegionManager shared] stopMonitoringAllBeaconRegions];
}


-(void)checkiBeaconsEnabledState
{
    if([[NSUserDefaults standardUserDefaults] objectForKey:kBeaconsEnabled])
        {
            //if no saved switch state set to YES by default
        self.ibeaconsEnabled = [[NSUserDefaults standardUserDefaults] boolForKey:kBeaconsEnabled];
        }
    else
        {
        self.ibeaconsEnabled =  YES;
        }
}

-(void)setIbeaconsEnabled:(BOOL)ibeaconsEnabled
{
    if (ibeaconsEnabled != _ibeaconsEnabled)
        {
        _ibeaconsEnabled = ibeaconsEnabled;
        }
    
        //enable montoring based on switch state
    if (ibeaconsEnabled)
        {
        [self startManager];
        }
    else
        {
        [self stopManager];
            //[self removeAllBeaconTags];
        }
}

-(void)syncMonitoredRegions
{
        //set monitored region read-only property with monitored regions
    _monitoredBeaconRegions = [self.locationManager monitoredRegions];
    
    
    
}

-(void)loadAvailableRegions
{
    _availableBeaconRegionsList = [_plistManager getAvailableBeaconRegionsList];
        // _corrdinateContentsDict = [_plistManager getCorrdinateContentsDict];
    
}

    //helper method to return a properly formatted (short style) date
-(NSString *)dateStringFromInterval:(NSTimeInterval)interval
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSString *dateString = [NSDateFormatter localizedStringFromDate:date
                                                          dateStyle:NSDateFormatterShortStyle
                                                          timeStyle:NSDateFormatterNoStyle];
    return dateString;
}

#pragma monitoring stop/start helpers

-(void)startMonitoringBeaconInRegion:(CLBeaconRegion *)beaconRegion
{
    
//    NSUUID *beaconUUID = [[NSUUID alloc] initWithUUIDString:
//                          @"B9407F30-F5F8-466E-AFF9-25556B57FE6D"];
//    NSString *regionIdentifier = @"Estimote Region";
//    CLBeaconRegion *beaconRegionTemp = [[CLBeaconRegion alloc]
//                                    initWithProximityUUID:beaconUUID identifier:regionIdentifier];
//    [self.locationManager startMonitoringForRegion:beaconRegionTemp];
//    [self.locationManager startRangingBeaconsInRegion:beaconRegionTemp];
//    [self.locationManager startUpdatingLocation];
//    NSLog(@"init::startMonitoringBeaconInRegion %@",beaconRegion );
//    [self syncMonitoredRegions];
//    _monitoredRegionCount++;

    
    if (beaconRegion != nil) {
        [self.locationManager startMonitoringForRegion:beaconRegion];
        [self.locationManager startRangingBeaconsInRegion:beaconRegion];
        NSLog(@"init::startMonitoringBeaconInRegion %@",beaconRegion );
        [self syncMonitoredRegions];
        _monitoredRegionCount++;
    }
}

-(void)stopMonitoringBeaconInRegion:(CLBeaconRegion *)beaconRegion
{
    if (beaconRegion != nil) {
        beaconRegion.notifyOnEntry = NO;
        beaconRegion.notifyOnExit = NO;
        beaconRegion.notifyEntryStateOnDisplay = NO;
        [self.locationManager stopMonitoringForRegion:beaconRegion];
        [self.locationManager stopRangingBeaconsInRegion:beaconRegion];
        [self syncMonitoredRegions];
        _monitoredRegionCount--;
    }
}

    //helper method to start monitoring all available beacon regions with no notifications
-(void)startMonitoringAllAvailableBeaconRegions
{
    
    for (CLBeaconRegion *beaconRegion in self.availableBeaconRegionsList)
        {
        if (beaconRegion != nil)
            {
            [self startMonitoringBeaconInRegion:beaconRegion];
            
            }
        }
    
    [self syncMonitoredRegions];
}

    //helper method to stop monitoring all available beacon regions
-(void)stopMonitoringAllAvailableBeaconRegions
{
    for (CLBeaconRegion *beaconRegion in self.availableBeaconRegionsList)
        {
        [self stopMonitoringBeaconInRegion:beaconRegion];
            //reset monitored region count
        _monitoredRegionCount = 0;
        }
}

    //stops monitoring all beacons in the current location monitor list
-(void)stopMonitoringAllBeaconRegions
{
    for (CLBeaconRegion *beaconRegion in [self.locationManager monitoredRegions])
        {
        if (beaconRegion != nil) {
            beaconRegion.notifyOnEntry = NO;
            beaconRegion.notifyOnExit = NO;
            beaconRegion.notifyEntryStateOnDisplay = NO;
            [self.locationManager stopRangingBeaconsInRegion:beaconRegion];
            [self.locationManager stopMonitoringForRegion:beaconRegion];
            [self syncMonitoredRegions];
                //reset monitored region count
            _monitoredRegionCount = 0;
        }
        }
}

#pragma location manager callbacks


-(void)sendLocalNotificationWithMessage:(NSString*)message {
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.alertBody = message;
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

//-(void)locationManager:(CLLocationManager *)manager didRangeBeacons:
//(NSArray *)beacons inRegion:(CLBeaconRegion *)region {
//    NSString *message = @"";
//    
//    if(beacons.count > 0) {
//        CLBeacon *nearestBeacon = beacons.firstObject;
//        switch(nearestBeacon.proximity) {
//            case CLProximityFar:
//                message = @"You are far away from the beacon";
//                break;
//            case CLProximityNear:
//                message = @"You are near the beacon";
//                break;
//            case CLProximityImmediate:
//                message = @"You are in the immediate proximity of the beacon";
//                break;
//            case CLProximityUnknown:
//                return;
//        }
//    } else {
//        message = @"No beacons are nearby";
//    }
//    
//    NSLog(@"%@", message);
//    [self sendLocalNotificationWithMessage:message];
//}

    //this gets called once for each beacon regions at 1 hz
- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
        // CoreLocation will call this delegate method at 1 Hz once for each region
//    NSLog(@"didRangeBeacons %d", [beacons count]);

        //if a mutable array exists under key region.identifier, replace it's contents with the ranged beacons
    if ([_currentRangedBeacons objectForKey:[region.proximityUUID UUIDString]] && [[_currentRangedBeacons objectForKey:[region.proximityUUID UUIDString]] isKindOfClass:[NSMutableArray class]])
        {
        
        NSMutableArray *currentBeaconsInRegion = [_currentRangedBeacons objectForKey:[region.proximityUUID  UUIDString]];
        currentBeaconsInRegion = [NSMutableArray arrayWithArray:beacons];
        [_currentRangedBeacons setObject:currentBeaconsInRegion forKey:[region.proximityUUID UUIDString]];
        }
        //if no mutable array exists under key, allocate mutable array and replace with ranged beacons
    else
        {
        NSMutableArray *currentBeaconsInRegion = [[NSMutableArray alloc] initWithArray:beacons];
            //place current ranged beacons for this region under this region's key
        [_currentRangedBeacons setObject:currentBeaconsInRegion forKey:[region.proximityUUID UUIDString]];
        }
    [[NSNotificationCenter defaultCenter]
         postNotificationName:@"managerDidRangeBeacons"
         object:self];
    
    
}



//    // Location Manager Delegate Methods
//- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
//{
//    NSLog(@"%@", [locations lastObject]);
//}

-(void)removeCorrdinateContent : (Coordinate *)delCoordinate
{
    [_plistManager removeCorrdinateContentsDict:delCoordinate];
}


-(void)addCorrdinateContent : (Coordinate *)addCoordinate
{
    [_plistManager addCorrdinateContentsDict:addCoordinate];
}



#pragma non-essential helpers

    //helper method for checking if a specific beacon region is monitored
-(BOOL)isMonitored:(CLBeaconRegion *)beaconRegion
{
    [self syncMonitoredRegions];
    for (CLBeaconRegion *bRegion in self.monitoredBeaconRegions) {
        if ([bRegion.identifier isEqualToString:beaconRegion.identifier]){
            return true;
        }
    }
    return false;
}

    //returns a beacon from the ranged list given a identifier, else emits log and returns nil
-(NSArray *)beaconWithId:(NSString *)identifier
{
    NSMutableArray *beacons;
        //this lever of checking probably isn't completely necessary
    if ([_currentRangedBeacons objectForKey:identifier] && [[_currentRangedBeacons objectForKey:identifier] isKindOfClass:[NSMutableArray class]]) {
        beacons = [_currentRangedBeacons objectForKey:identifier];
        return  [beacons copy];
    }
    return nil;

}


-(Coordinate  *)getCorrdinateContentsDict:(NSString *)identifier
{
    return [[_plistManager getCorrdinateContentsDict] objectForKey:identifier];
}

-( NSDictionary  *)getCorrdinateContentsDict
{
    return [_plistManager getCorrdinateContentsDict];
}




@end
