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

@property (strong,nonatomic) NSMutableArray *productList;
@property (strong,nonatomic) NSMutableArray *tableData;

@property int type;

@end
