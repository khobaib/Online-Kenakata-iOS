//
//  ProductList.h
//  OnlineKenakata-Demo
//
//  Created by Rabby Alam on 7/9/14.
//  Copyright (c) 2014 rabbi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingView.h"


@interface ProductList : UITableViewController{

    NSMutableArray *catagoryList;
    NSMutableArray *productList;
    NSString *currency;
    LoadingView *loading;
}
@property NSString *productId;
@property NSString *catagoryName;
@property (strong,nonatomic) IBOutlet UITableView *tableView;


-(void)parsProductList:(id) respons;
@end
