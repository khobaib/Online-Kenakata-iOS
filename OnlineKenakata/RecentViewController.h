//
//  RecentViewController.h
//  kenakata
//
//  Created by MC MINI on 11/3/14.
//  Copyright (c) 2014 OnlineKenakata. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecentViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource>{
    NSMutableArray *productList;
    NSString *currency;
    
}
@property IBOutlet UICollectionView *collectionView;

@end
