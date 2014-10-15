//
//  Delivery.h
//  OnlineKenakata
//
//  Created by Rabby Alam on 7/20/14.
//  Copyright (c) 2014 OnlineKenakata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeleveryMethod.h"
#import "LoadingView.h"

@interface Delivery : UIViewController<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>{

    UIPickerView *paymentMethodPicker;
    NSString *currency;

    NSString *paymentID;
    NSMutableArray *paymentMethodList;
    NSMutableDictionary *dic;
    NSDate *alermTime;
    LoadingView *loading;


}


@property (strong,nonatomic) IBOutlet UITextField *nameFild;
@property (strong,nonatomic) IBOutlet UITextField *emailFild;
@property (strong,nonatomic) IBOutlet UITextField *phoneFild;
@property (strong,nonatomic) IBOutlet UITextField *commentFild;
@property (strong,nonatomic) IBOutlet UITextField *address;

@property (strong,nonatomic) IBOutlet UITextField *paymentMethod;


@property (strong,nonatomic) IBOutlet UILabel *subtotalLable;
@property (strong,nonatomic) IBOutlet UILabel *subtotal;
@property (strong,nonatomic) IBOutlet UILabel *total;
@property (strong,nonatomic) IBOutlet UILabel *deleveryChargeLable;

@property (strong,nonatomic) IBOutlet UIButton *payment;

@property (strong,nonatomic) DeleveryMethod *method;

@property (strong,nonatomic) IBOutlet UILabel *deleveryChargeLabel;

@property NSString* deleveryCharge;
@property NSMutableDictionary *marchentDictionary;

@end


