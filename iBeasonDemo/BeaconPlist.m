#import "BeaconPlist.h"
#import "BeaconDemoValues.h"
#import "Coordinate.h"
@implementation BeaconPlist
{
    NSArray *_availableBeaconRegions;

    NSArray *_plistCorrdinateContentsArray;
    NSMutableDictionary  *_plistCorrdinateContentsDict;
}

- (id)init
{
    self = [super init];
    
    if(self)
        {
        
        }
    return self;
}

-(NSArray*)getAvailableBeaconRegionsList
{
        //set read-only available regions
    [self loadAvailableBeaconRegionsList];
    return self.availableBeaconRegionsList;
}

-(NSDictionary  *)getCorrdinateContentsDict
{
    if(_plistCorrdinateContentsDict !=nil)
    {
        return _plistCorrdinateContentsDict;
    }else
        return nil;
}

-(void)removeCorrdinateContentsDict : (Coordinate *)delCoordinate
{
    [_plistCorrdinateContentsDict removeObjectForKey: [delCoordinate  getKey]];
    
    _plistCorrdinateContentsArray = [_plistCorrdinateContentsDict allValues];
    [self buildPlistFromData];
    
}


-(void)addCorrdinateContentsDict : (Coordinate *)addCoordinate
{
//    NSLog(@"%@",addCoordinate.getKey);
    
    [_plistCorrdinateContentsDict setObject:addCoordinate forKey:[addCoordinate  getKey]];
    
    _plistCorrdinateContentsArray = [_plistCorrdinateContentsDict allValues];
    [self buildPlistFromData];
    
}

-(void)loadLocalPlist
{
        //initialize with local list

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    NSString *plistBeaconRegionsPath = [basePath stringByAppendingPathComponent:@"SampleBeaconRegions.plist"];


//    NSLog(@"plist name::%@",plistBeaconRegionsPath);
    
    [self loadAvailableBeaconRegionsList];
    [self loadReadableBeaconRegions];
}



-(void)loadAvailableBeaconRegionsList
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    NSString *plistBeaconRegionsPath = [basePath stringByAppendingPathComponent:@"SampleBeaconRegions.plist"];

    _plistCorrdinateContentsArray = [NSKeyedUnarchiver unarchiveObjectWithFile:plistBeaconRegionsPath];
//     NSLog(@"loadAvailableBeaconRegionsList %@",_plistCorrdinateContentsArray);
    _availableBeaconRegionsList = [self buildBeaconRegionDataFromCorrdinate];
}

- (NSArray*) buildBeaconRegionDataFromCorrdinate
{
    NSMutableArray *managedBeaconRegions = [NSMutableArray array];
    if(_plistCorrdinateContentsDict == nil)
    _plistCorrdinateContentsDict =[[NSMutableDictionary alloc] init];
        else [_plistCorrdinateContentsDict removeAllObjects];
    for(Coordinate *beaconDict in _plistCorrdinateContentsArray)
        {
            CLBeaconRegion *beaconRegion = [self mapDictionaryToBeacon:beaconDict];
            [_plistCorrdinateContentsDict setObject:beaconDict forKey:[beaconDict getKey ]];
            if (beaconRegion != nil)
            {
            
//                NSLog(@"load beaconRegion %@",beaconRegion);
                [managedBeaconRegions addObject:beaconRegion];
            }else NSLog(@"load beaconRegion is null");
        
        }
    if ([managedBeaconRegions count]==0) {
//        [managedBeaconRegions addObject:
//         [[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:@"B9407F30-F5F8-466E-AFF9-25556B57FE6D"]  major:13594 minor:52321 identifier:kBeaconIdentify]];
//        [managedBeaconRegions addObject:
//         [[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:@"B9407F30-F5F8-466E-AFF9-25556B57FE6D"]  major:55414 minor:63858 identifier:kBeaconIdentify]];
//         [managedBeaconRegions addObject:[[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:@"B9407F30-F5F8-466E-AFF9-25556B57FE6D"]  identifier:kBeaconIdentify]];
    }
    return [NSArray arrayWithArray:managedBeaconRegions];
}

- (void) buildPlistFromData
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    NSString *plistBeaconRegionsPath = [basePath stringByAppendingPathComponent:@"SampleBeaconRegions.plist"];
//    NSLog(@"buildPlistFromData %@",_plistCorrdinateContentsArray);
    [NSKeyedArchiver archiveRootObject: _plistCorrdinateContentsArray toFile: plistBeaconRegionsPath];
    
    
    
    
    
    
}

- (CLBeaconRegion*)mapDictionaryToBeacon:(Coordinate*) coordinate
{
//    NSLog(@"mapDictionaryToBeacon %@  %d",coordinate.proximityUUID,coordinate.minor);
//    if (coordinate.major != 0) {
//         return [[CLBeaconRegion alloc] initWithProximityUUID: [[NSUUID alloc] initWithUUIDString:   coordinate.proximityUUID ]  major: coordinate.major minor: coordinate.minor identifier:coordinate.title];
//    }else
//    {
            return [[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:   coordinate.proximityUUID ] identifier:coordinate.title];
//    }
}



#pragma non-essential helper methods

    //This is a helper method that can be removed, useful for displaying IDs next to UUID
-(void)loadReadableBeaconRegions
{
    
    NSMutableArray *readableBeaconArray = [[NSMutableArray alloc] initWithCapacity:[self.availableBeaconRegionsList count]];
    NSString *currentReadableBeacon;
    
    for (CLBeaconRegion *beaconRegion in _availableBeaconRegions)
        {
        currentReadableBeacon = [NSString stringWithFormat:@"%@ - %@", [beaconRegion identifier], [[beaconRegion proximityUUID] UUIDString]];
        [readableBeaconArray addObject:currentReadableBeacon];
        }
    
    _readableBeaconRegions = [NSArray arrayWithArray:readableBeaconArray];
}

-(NSString *)identifierForUUID:(NSUUID *) uuid
{
    NSRange uuidRange;
    if (self.readableBeaconRegions != nil)
        {
        for (NSString *string in self.readableBeaconRegions)
            {
                //if string contains - <UUID> then remove this portion so only the identifier remains
            NSString *uuidPortion = [NSString stringWithFormat:@" - %@", [uuid UUIDString]];
                //NSRange returns a struct, so make sure it isn't nil, TODO:add nil check
            
            if (string != nil)
                {
                uuidRange = [string rangeOfString:[uuid UUIDString]];
                }
            if (uuidRange.location != NSNotFound)
                {
                return [string substringToIndex:[string rangeOfString:uuidPortion].location];
                }
            }
            //uuid is not in the monitored list
        return nil;
        }
     return nil;
}
@end
