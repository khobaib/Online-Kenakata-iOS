//
//  bKashViewController.h
//  OnlineKenakata
//
//  Created by Apple on 8/10/14.
//  Copyright (c) 2014 OnlineKenakata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingView.h"

@interface bKashViewController : UIViewController<UITextFieldDelegate>{
    NSMutableDictionary* dic;
    BOOL callMade;
    LoadingView *loading;

}

@property (strong,nonatomic)  NSMutableDictionary *params;
@property (strong,nonatomic) IBOutlet UITextField *transactionID;
@property (strong,nonatomic) IBOutlet UILabel *textLable;

@end
