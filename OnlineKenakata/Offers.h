//
//  Offers.h
//  OnlineKenakata-Demo
//
//  Created by Rabby Alam on 7/10/14.
//  Copyright (c) 2014 rabbi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingView.h"

@interface Offers : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource>{
    NSMutableArray *productList;
    NSMutableArray *catagoryList;
    int counter;
    NSString *currency;
    BOOL isLoading;
}
@property IBOutlet UICollectionView *collectionView;

@end
