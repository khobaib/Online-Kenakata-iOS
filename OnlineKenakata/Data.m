//
//  Data.m
//  OnlineKenakata
//
//  Created by Rabby Alam on 7/22/14.
//  Copyright (c) 2014 OnlineKenakata. All rights reserved.
//

#import "Data.h"

NSString * const baseurl=@"http://zenapp.my/starfish/";
NSString * const appcode=@"1000";
@implementation Data

+(NSString *)getAppCode{
    return appcode;
}

+(NSString *)getBaseUrl{
    return baseurl;
}

@end
