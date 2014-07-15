//
//  PushPin.h
//  OnlineKenakata-Demo
//
//  Created by Rabby Alam on 7/13/14.
//  Copyright (c) 2014 rabbi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface PushPin : NSObject<MKAnnotation>


@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, assign) CLLocationCoordinate2D theCoordinate;

- (id)initWithName:(NSString*)name address:(NSString*)address coordinate:(CLLocationCoordinate2D)coordinate;
- (MKMapItem*)mapItem;


@end
