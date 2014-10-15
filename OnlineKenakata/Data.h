//
//  Data.h
//  OnlineKenakata
//
//  Created by Rabby Alam on 7/22/14.
//  Copyright (c) 2014 OnlineKenakata. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Data : NSObject{
   
}

+(NSString *)getBaseUrl;
+(NSString *)getAppCode;
+(NSString *)getKenakataUrl;

+(NSMutableDictionary*)getMarchentData;
+(void)setMarchentData:(NSMutableDictionary*)marchent;
+(int)getDeleveryCharge;
+(void)setDeleveryCharge:(int)charge;

+(int)getSubTotal;
+(void)setSubTotal:(int)total;

+(int)getProdictCount;
+(void)setProductCount:(int)prodCount;

@end
