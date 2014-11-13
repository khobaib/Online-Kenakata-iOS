//
//  RecentViewController.h
//  kenakata
//
//  Created by MC MINI on 11/3/14.
//  Copyright (c) 2014 OnlineKenakata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"
@interface RecentViewController : GAITrackedViewController<UICollectionViewDelegate,UICollectionViewDataSource>{
    NSMutableArray *productList;
    NSString *currency;
    
}
@property IBOutlet UICollectionView *collectionView;

@end
