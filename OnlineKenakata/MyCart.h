//
//  MyCart.h
//  OnlineKenakata
//
//  Created by Rabby Alam on 7/19/14.
//  Copyright (c) 2014 OnlineKenakata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingView.h"
#import "RMPickerViewController.h"

@interface MyCart : UIViewController<UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,RMPickerViewControllerDelegate>
{
    NSString *currency;
    NSIndexPath *quantity;
    LoadingView *loading;
    NSMutableArray *serverProductList;
    BOOL serverData;
    int editQuantity;
    int counter;
    
    NSMutableDictionary *marchentDictionary;
}
@property (strong,nonatomic) NSMutableArray *productList;

@property (strong,nonatomic) IBOutlet UITableView *tableview;
@property (strong,nonatomic) IBOutlet UILabel *subTotal;
@property (strong,nonatomic) IBOutlet UILabel *total;
@property (strong,nonatomic) IBOutlet UILabel *subTotalLable;
@property (strong,nonatomic) IBOutlet UILabel *deleveryChargeLable;
@property (strong,nonatomic) IBOutlet UIButton *checkoutBtn;

@end
