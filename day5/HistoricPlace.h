//
//  HistoricPlace.h
//  day5
//
//  Created by Student on 24.06.15.
//  Copyright (c) 2015 KBTU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface HistoricPlace : NSObject <MKAnnotation>

@property (nonatomic) NSString *objectId;
@property (nonatomic) NSString *name;
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic) NSString *descr;
@property (nonatomic) UIImage *picture;

-(instancetype) initWithName:(NSString *) name andLocation:(CLLocationCoordinate2D)coordinate andDescription:(NSString *) descr andPicture:(UIImage *) picture andId:(NSString *)objectId;

@end
