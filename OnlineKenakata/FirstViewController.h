//
//  FirstViewController.h
//  OnlineKenakata-Demo
//
//  Created by Rabby Alam on 7/8/14.
//  Copyright (c) 2014 rabbi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingView.h"



@interface FirstViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UISearchBarDelegate>
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
    int counter;
}
@property UIImage *image;
@property (strong,nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong,nonatomic) IBOutlet UICollectionView *collectionview;
@property (strong,nonatomic) IBOutlet UISearchBar *searchBar;

@property (strong,nonatomic)IBOutlet UIButton *signinButton;
-(void)parsCatagoryList:(id) data;
@end
