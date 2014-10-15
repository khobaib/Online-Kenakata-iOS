//
//  FacebookViewController.h
//  OnlineKenakata
//
//  Created by MC MINI on 9/30/14.
//  Copyright (c) 2014 OnlineKenakata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking/AFNetworking.h"
#import <FacebookSDK/FacebookSDK.h>



@interface FacebookViewController : UIViewController{
    
}

@property NSMutableDictionary *dic;
@property (strong,nonatomic) IBOutlet UILabel *email;
@property (strong,nonatomic) IBOutlet UITextField *name;
@property (strong,nonatomic) IBOutlet UITextField *phone;

@property BOOL fromProcideToCheckout;



@end
