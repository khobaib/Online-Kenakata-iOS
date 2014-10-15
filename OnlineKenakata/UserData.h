//
//  UserData.h
//  OnlineKenakata
//
//  Created by Apple on 8/5/14.
//  Copyright (c) 2014 OnlineKenakata. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserData : UIViewController<UITableViewDataSource,UITableViewDelegate>{
}

@property (strong,nonatomic) NSMutableArray *tableData;
@property (strong,nonatomic) IBOutlet UIButton *addNew;

@property int type;

@property (strong,nonatomic) IBOutlet UILabel *deleveryChargeLabel;

@property NSString* deleveryCharge;
@property NSMutableDictionary *marchentDictionary;

@end
