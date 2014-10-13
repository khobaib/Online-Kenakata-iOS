//
//  Data.m
//  OnlineKenakata
//
//  Created by Rabby Alam on 7/22/14.
//  Copyright (c) 2014 OnlineKenakata. All rights reserved.
//

#import "Data.h"

NSString * const baseurl=@"http://online-kenakata.com/mobile_api";
NSString *const kenakataurl=@"";
NSString * const appcode=@"999";
static NSMutableDictionary *marchentData;
static int deleverycharge;

@implementation Data

+(NSString *)getAppCode{
    return appcode;
}

+(NSString *)getBaseUrl{
    return baseurl;
}

+(NSString *)getKenakataUrl{
    return kenakataurl;
}


+(NSMutableDictionary*)getMarchentData{
    return marchentData;
}
+(void)setMarchentData:(NSMutableDictionary*)marchent{
    marchentData=marchent;
}
+(int)getDeleveryCharge{
    return deleverycharge;
}
+(void)setDeleveryCharge:(int)charge{
    deleverycharge=charge;
}


@end
