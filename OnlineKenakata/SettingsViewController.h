//
//  SettingsViewController.h
//  OnlineKenakata
//
//  Created by MC MINI on 10/15/14.
//  Copyright (c) 2014 OnlineKenakata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"
@interface SettingsViewController : GAITrackedViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>{
    NSString *token;
}


@property (strong, nonatomic) IBOutlet NSLayoutConstraint *settingsTableHeight;

@property (strong,nonatomic) IBOutlet UITableView *table;

@property (strong,nonatomic) IBOutlet UILabel *username;
@property (strong,nonatomic) IBOutlet UILabel *loggedinVia;
@property (strong,nonatomic) IBOutlet UILabel *email;
@property (strong,nonatomic) IBOutlet UILabel *appvertion;



+(NSString*)md5HexDigest:(NSString*)input;

@end
