//
//  Marchent.m
//  OnlineKenakata
//
//  Created by MC MINI on 10/13/14.
//  Copyright (c) 2014 OnlineKenakata. All rights reserved.
//

#import "Marchent.h"

@implementation Marchent

-(id)initwithID:(NSString *)marchentID deleveryCharge:(NSString *)deleveryCharge{
    
    self.productArray=[[NSMutableArray alloc]init];
    self.marchentId=marchentID;
    self.deleveryCharge=deleveryCharge;
    
    return self;
}

@end
