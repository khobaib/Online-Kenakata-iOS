//
//  FirstViewController.h
//  OnlineKenakata-Demo
//
//  Created by Rabby Alam on 7/8/14.
//  Copyright (c) 2014 rabbi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingView.h"



@interface FirstViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    NSMutableArray *catagoryList;
    NSMutableArray *productList;
    UIRefreshControl *refreshControl;
    LoadingView *loading;
    NSString *currency;
    UIButton *overlayButton;
    NSMutableArray *backupCatList;
    NSMutableArray *backupproDuctList;
    BOOL isSearched;
}
@property UIImage *image;
@property (strong,nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong,nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic) IBOutlet UISearchBar *searchBar;
-(void)parsCatagoryList:(id) data;
@end
