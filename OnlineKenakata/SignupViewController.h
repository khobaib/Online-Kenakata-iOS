//
//  SignupViewController.h
//  OnlineKenakata
//
//  Created by Apple on 8/13/14.
//  Copyright (c) 2014 OnlineKenakata. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignupViewController : UIViewController<UITextFieldDelegate>


@property (strong,nonatomic) IBOutlet UITextField *userNameField;
@property (strong,nonatomic) IBOutlet UITextField *passwordField;
@property (strong,nonatomic) IBOutlet UITextField *emailField;
@property (strong,nonatomic) IBOutlet UITextField *phoneNumber;

@property BOOL fromProcideToCheckout;

@end
