//
//  TextStyling.h
//  OnlineKenakata
//
//  Created by Apple on 8/7/14.
//  Copyright (c) 2014 OnlineKenakata. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TextStyling : NSObject

+(NSMutableAttributedString *)AttributForTitle:(NSString *)text;
+(NSMutableAttributedString *)AttributForSubTitle:(NSString *)text;
+(NSMutableAttributedString *)AttributForPriceStrickThrough:(NSString *)text;
+(NSMutableAttributedString *)AttributForPrice:(NSString *)text;
+(NSMutableAttributedString *)AttributForDescription:(NSString *)text;

+(NSMutableAttributedString *)AttributForOfferNewsTitle:(NSString *)text;
+(NSMutableAttributedString *)AttributForOfferNewsDescription:(NSString *)text;

+(UIButton* )sharebutton;
+(UIColor *)appColor;
+(UIColor *)barbuttonColor;
+(void)changeAppearance;
+(void)Handle;

@end
