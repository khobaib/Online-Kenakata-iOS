//
//  SelfCollect.h
//  OnlineKenakata
//
//  Created by Rabby Alam on 7/20/14.
//  Copyright (c) 2014 OnlineKenakata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeleveryMethod.h"
#import "LoadingView.h"

@interface SelfCollect : UIViewController<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIAlertViewDelegate>{
    UIPickerView *namePicker;
    UIPickerView *paymentMethodPicker;
    NSString *currency;
    NSMutableArray *branches;
    NSMutableArray *paymentMethodList;
    
    NSString *branchID;
    NSString *paymentID;
    NSMutableDictionary *dic;
    NSDate *alermTime;
    LoadingView *loading;


}

@property (strong,nonatomic) NSMutableArray *productList;
@property (strong,nonatomic) IBOutlet UITextField *textFild;
@property (strong,nonatomic) IBOutlet UITextField *nameFild;
@property (strong,nonatomic) IBOutlet UITextField *emailFild;
@property (strong,nonatomic) IBOutlet UITextField *phoneFild;
@property (strong,nonatomic) IBOutlet UITextField *commentFild;
@property (strong,nonatomic) IBOutlet UITextField *paymentMethod;

@property (strong,nonatomic) IBOutlet UILabel *subtotalLable;
@property (strong,nonatomic) IBOutlet UILabel *subtotal;
@property (strong,nonatomic) IBOutlet UILabel *total;
@property (strong,nonatomic) IBOutlet UIButton *payment;
@property (strong,nonatomic) DeleveryMethod *method;

@end
