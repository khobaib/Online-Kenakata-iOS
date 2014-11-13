//
//  FilterInputViewController.h
//  kenakata
//
//  Created by MC MINI on 10/20/14.
//  Copyright (c) 2014 OnlineKenakata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"

@interface FilterInputViewController : GAITrackedViewController<UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate>{
    UIPickerView *marchentPicker;
    UIPickerView *tagPicker;
    UIPickerView *pricePicker;
    NSArray *marchentList;
    NSArray *tagList;
    NSArray *priceList;
    
    NSDictionary *priceRange;
    NSMutableDictionary *filterParams;
    
    int counter;
}

@property (strong,nonatomic) IBOutlet UITextField *marchent;
@property (strong,nonatomic) IBOutlet UITextField *tag;
@property (strong,nonatomic) IBOutlet UITextField *priceField;
@property IBOutlet UISwitch *isDiscount;
@property IBOutlet UISwitch *isNew;

@end
