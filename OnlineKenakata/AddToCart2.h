//
//  AddToCart.h
//  OnlineKenakata
//
//  Created by Rabby Alam on 7/17/14.
//  Copyright (c) 2014 OnlineKenakata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMPickerViewController.h"
#import "LoadingView.h"

@interface AddToCart2 : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate,RMPickerViewControllerDelegate,UIAlertViewDelegate>{
    NSMutableArray *pickerData;
    bool flag;
    NSString *currency;
    int quantity;
    NSMutableDictionary *specialAnsDic;
    int availablity;
    NSString * selectedQuantity;
    LoadingView *loading;
}


@property (strong,nonatomic) NSMutableDictionary *productData;

@property (strong,nonatomic) IBOutlet UIImageView *thumbnil;

@property (strong,nonatomic) IBOutlet UIImageView *tooping;
@property (strong,nonatomic) IBOutlet UILabel *name;
@property (strong,nonatomic) IBOutlet UILabel *oldPrice;
@property (strong,nonatomic) IBOutlet UILabel *priceNew;
@property (strong,nonatomic) IBOutlet UILabel *itemCode;
@property (strong,nonatomic) IBOutlet UILabel *specialQuestionLable;
@property (strong,nonatomic) IBOutlet UIButton *specialQuestion;
@property (strong,nonatomic) IBOutlet UIButton *quantitybtn;
@property (strong,nonatomic) IBOutlet UITextView *details;
@property (strong,nonatomic) IBOutlet UIView *specialQuestionView;


@property (strong,nonatomic)IBOutlet UIView *quantityView;
@property (strong,nonatomic)IBOutlet UIButton *confirmBtn;
@end