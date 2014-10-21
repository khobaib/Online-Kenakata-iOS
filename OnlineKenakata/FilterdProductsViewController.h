//
//  FilterdProductsViewController.h
//  kenakata
//
//  Created by MC MINI on 10/20/14.
//  Copyright (c) 2014 OnlineKenakata. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterdProductsViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource>{
    
    NSMutableArray *catagoryList;
    NSMutableArray *productList;
    NSString *currency;
    int counter;
}

@property (strong,nonatomic) IBOutlet UICollectionView *collectionView;

@property NSDictionary *params;
@end
