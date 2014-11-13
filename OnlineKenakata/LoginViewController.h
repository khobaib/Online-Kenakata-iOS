//
//  LoginViewController.h
//  OnlineKenakata
//
//  Created by Apple on 8/13/14.
//  Copyright (c) 2014 OnlineKenakata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "GAITrackedViewController.h"

@interface LoginViewController : GAITrackedViewController<UITextFieldDelegate,FBLoginViewDelegate,UIAlertViewDelegate>

@property (strong,nonatomic) IBOutlet UITextField *userNameField;
@property (strong,nonatomic) IBOutlet UITextField *passwordField;

@property (weak, nonatomic) IBOutlet FBLoginView *loginView;

@property BOOL fromProcideToCheckout;

@end
