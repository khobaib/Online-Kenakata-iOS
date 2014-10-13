//
//  Marchent.h
//  OnlineKenakata
//
//  Created by MC MINI on 10/13/14.
//  Copyright (c) 2014 OnlineKenakata. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Marchent : NSObject


@property NSMutableArray *productArray;

@property NSString *marchentId;
@property NSString *deleveryCharge;


-(id)initwithID:(NSString *)marchentID deleveryCharge:(NSString *)deleveryCharge;
@end
