//
//  Coordinate.m
//  iBeasonDemo
//
//  Created by Kim on 14/5/1.
//  Copyright (c) 2014年 Kim. All rights reserved.
//

#import "Coordinate.h"

@implementation Coordinate
@synthesize xCoordinate;
@synthesize yCoordinate;
@synthesize major;
@synthesize minor;
@synthesize proximityUUID;



-(NSString *) getKey
{
    
    return [NSString stringWithFormat:@"%@-%d-%d",proximityUUID,major,minor];
}



#pragma mark - NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInt:self.xCoordinate   forKey:@"xCoordinate"];
    [aCoder encodeInt:self.yCoordinate   forKey:@"yCoordinate"];
    [aCoder encodeInt:self.major   forKey:@"major"];
    [aCoder encodeInt:self.minor   forKey:@"minor"];
    [aCoder encodeObject:self.title         forKey:@"title"];
    [aCoder encodeObject:self.proximityUUID         forKey:@"proximityUUID"];
    }

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super init]))
        {
        self.xCoordinate = [aDecoder decodeIntForKey:@"xCoordinate"];
        self.yCoordinate = [aDecoder decodeIntForKey:@"yCoordinate"];
        self.major = [aDecoder decodeIntForKey:@"major"];
        self.minor = [aDecoder decodeIntForKey:@"minor"];
        self.title    = [aDecoder decodeObjectForKey:@"title"];
        self.proximityUUID    = [aDecoder decodeObjectForKey:@"proximityUUID"];
        }
    return self;
}

@end
