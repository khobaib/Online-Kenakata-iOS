//
//  FilterInputViewController.h
//  kenakata
//
//  Created by MC MINI on 10/20/14.
//  Copyright (c) 2014 OnlineKenakata. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterInputViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate>{
    UIPickerView *marchentPicker;
    UIPickerView *tagPicker;
    NSArray *marchentList;
    NSArray *tagList;
  
    NSMutableDictionary *filterParams;
    int counter;
}

@property (strong,nonatomic) IBOutlet UITextField *marchent;
@property (strong,nonatomic) IBOutlet UITextField *tag;
@property (strong,nonatomic) IBOutlet UITextField *lowestprice;
@property (strong,nonatomic) IBOutlet UITextField *heighPrice;

@end
