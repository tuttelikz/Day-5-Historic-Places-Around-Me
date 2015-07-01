//
//  HistoricPlace.m
//  day5
//
//  Created by Student on 24.06.15.
//  Copyright (c) 2015 KBTU. All rights reserved.
//

#import "HistoricPlace.h"

@implementation HistoricPlace

-(NSString *)title
{
    return self.name;
}

-(NSString *)subtitle
{
    return self.descr;
}

-(instancetype)initWithName:(NSString *)name andLocation:(CLLocationCoordinate2D)coordinate andDescription:(NSString *)descr andPicture:(UIImage *)picture andId:(NSString *)objectId
{
    self = [super init];
    if (self) {
        self.name = name;
        self.coordinate = coordinate;
        self.descr = descr;
        self.picture = picture;
        self.objectId = objectId;
    }
    return self;
}

@end
