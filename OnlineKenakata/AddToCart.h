//
//  AddToCart.h
//  OnlineKenakata
//
//  Created by Rabby Alam on 7/17/14.
//  Copyright (c) 2014 OnlineKenakata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMPickerViewController.h"

@interface AddToCart : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate,RMPickerViewControllerDelegate>{
    NSMutableArray *pickerData;
    bool flag;
    NSString *currency;
    int quantity;
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

@end
