#import <Foundation/Foundation.h>
#import <CoreLocation/Corelocation.h>
#import "Coordinate.h"

@interface BeaconPlist : NSObject

-(NSArray *)getAvailableBeaconRegionsList;
-(NSDictionary  *)getCorrdinateContentsDict;
-(void)loadReadableBeaconRegions;

    //Plist loading
-(void)loadLocalPlist;
-(void)removeCorrdinateContentsDict : (Coordinate *)delCoordinate;
-(void)addCorrdinateContentsDict : (Coordinate *)addCoordinate;

@property (nonatomic, copy, readonly) NSArray *availableBeaconRegionsList;
@property (nonatomic, copy, readonly) NSArray *readableBeaconRegions;
@property (nonatomic, copy, readonly) NSDictionary  *corrdinateContentsDict;


@end
