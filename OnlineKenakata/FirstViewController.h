//
//  FirstViewController.h
//  OnlineKenakata-Demo
//
//  Created by Rabby Alam on 7/8/14.
//  Copyright (c) 2014 rabbi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingView.h"

@interface FirstViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *tableData;
    UIRefreshControl *refreshControl;
    LoadingView *loading;
    
    
}
@property UIImage *image;
@property (strong,nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong,nonatomic) IBOutlet UITableView *tableView;
-(void)parsCatagoryList:(id) data;
@end
