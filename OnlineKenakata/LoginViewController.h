//
//  LoginViewController.h
//  OnlineKenakata
//
//  Created by Apple on 8/13/14.
//  Copyright (c) 2014 OnlineKenakata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>


@interface LoginViewController : UIViewController<UITextFieldDelegate,FBLoginViewDelegate>

@property (strong,nonatomic) IBOutlet UITextField *userNameField;
@property (strong,nonatomic) IBOutlet UITextField *passwordField;

@property (weak, nonatomic) IBOutlet FBLoginView *loginView;

@end
