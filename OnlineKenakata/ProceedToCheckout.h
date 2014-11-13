//
//  ProceedToCheckout.h
//  OnlineKenakata
//
//  Created by Rabby Alam on 7/20/14.
//  Copyright (c) 2014 OnlineKenakata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"
@interface ProceedToCheckout : GAITrackedViewController<UIAlertViewDelegate>{
    NSString *currency;
}


@property(strong,nonatomic) NSMutableArray *productList;
@property (strong,nonatomic) IBOutlet UILabel *subtotalLable;
@property (strong,nonatomic) IBOutlet UILabel *subtotal;
@property (strong,nonatomic) IBOutlet UILabel *total;
@property (strong,nonatomic) IBOutlet UITextView *terms;
@property (strong,nonatomic) IBOutlet UIButton *agreeBtn;
@property (strong,nonatomic) IBOutlet UILabel *deleveryChargeLabel;

@property NSString* deleveryCharge;
@property NSMutableDictionary *marchentDictionary;
@end
