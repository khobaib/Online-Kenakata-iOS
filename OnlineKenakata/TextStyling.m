//
//  TextStyling.m
//  OnlineKenakata
//
//  Created by Apple on 8/7/14.
//  Copyright (c) 2014 OnlineKenakata. All rights reserved.
//

#import "TextStyling.h"

@implementation TextStyling

//styling in navigation bar : from storyboard , navigation bar color ar navigation bar back button

+(UIColor *)appColor{
    return [UIColor colorWithRed:(237.0/255.0) green:(183.0/255.0) blue:(3.0/255.0) alpha:1.0];
   // return [UIColor blackColor];//[UIColor colorWithRed:(.0/255.0) green:(160.0/255.0) blue:(221.0/255.0) alpha:1.0];
}
+(UIColor *)barbuttonColor{
    return [UIColor whiteColor];
}

+(void)changeAppearance{
    [[UINavigationBar appearance] setBarTintColor:[self appColor]];
    [[UINavigationBar appearance] setTintColor: [self barbuttonColor]];
    
    [[UITabBar appearance] setTintColor:[UIColor colorWithRed:(179.0/255.0) green:(138.0/255.0) blue:(2.0/255.0) alpha:1.0]
];
    [[UITabBar appearance] setBarTintColor:[UIColor colorWithRed:(254.0/255.0) green:(242.0/255.0) blue:(201.0/255.0) alpha:1.0]];
   // [[UITabBar appearance] setBarTintColor:[self appColor]];
    //[[UITabBar appearance] setTintColor:[UIColor blueColor]];
    //[[UITabBar appearance] setSelectedImageTintColor:[UIColor clearColor]];

}
+(NSMutableAttributedString *)AttributForTitle:(NSString *)text{
    NSMutableAttributedString *attString=[[NSMutableAttributedString alloc]initWithString:text];
    
  
    [attString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,[attString length])];
    
    return attString;
}


+(NSMutableAttributedString *)AttributForSubTitle:(NSString *)text{
    NSMutableAttributedString *attString=[[NSMutableAttributedString alloc]initWithString:text];
    
    
    [attString addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0,[attString length])];
    
    return attString;
}

+(NSMutableAttributedString *)AttributForPriceStrickThrough:(NSString *)text{
    
    
    NSMutableAttributedString *attString=[[NSMutableAttributedString alloc]initWithString:text];
    
    
    [attString addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInt:1] range:NSMakeRange(0,[attString length])];
    
    [attString addAttribute:NSStrikethroughColorAttributeName value:[UIColor redColor] range:NSMakeRange(0,[attString length])];
    
    [attString addAttribute:NSForegroundColorAttributeName value:[self appColor] range:NSMakeRange(0,[attString length])];
    
    return attString;
}

+(NSMutableAttributedString *)AttributForPrice:(NSString *)text{
    NSMutableAttributedString *attString=[[NSMutableAttributedString alloc]initWithString:text];
    
    
    [attString addAttribute:NSForegroundColorAttributeName value:[self appColor] range:NSMakeRange(0,[attString length])];
    
    return attString;
}

+(NSMutableAttributedString *)AttributForDescription:(NSString *)text{
   // NSMutableAttributedString *attString=[[NSMutableAttributedString alloc]initWithString:text];
      NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithData:[text dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0,[attributedString length])];
    
    return attributedString;
}

+(NSMutableAttributedString *)AttributForOfferNewsTitle:(NSString *)text{
    NSMutableAttributedString *attString=[[NSMutableAttributedString alloc]initWithString:text];
    
    
    [attString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,[attString length])];
    
    return attString;

}
+(NSMutableAttributedString *)AttributForOfferNewsDescription:(NSString *)text{
    NSMutableAttributedString *attString=[[NSMutableAttributedString alloc]initWithString:text];
    
    
    [attString addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0,[attString length])];
    
    return attString;
   
}


+(UIButton* )sharebutton{
 
    UIButton *sharebtn=[[UIButton alloc]initWithFrame:CGRectMake(110, 10, 100, 30)];
    [sharebtn setTitle:@"Share" forState:UIControlStateNormal];
    [sharebtn setTitleColor:[self barbuttonColor] forState:UIControlStateNormal];
    
    return sharebtn;
}

+(void)Handle{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Rabbi" message:@"fb/rabbyalam rabbyalam@gmail.com" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
    [alert show];
}

@end
