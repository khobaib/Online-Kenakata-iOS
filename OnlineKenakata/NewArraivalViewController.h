//
//  NewArraivalViewController.h
//  kenakata
//
//  Created by MC MINI on 11/9/14.
//  Copyright (c) 2014 OnlineKenakata. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewArraivalViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate>{
    NSMutableArray *productList;
    NSString *currency;
    int counter;

    BOOL isLoading;

}
@property IBOutlet UICollectionView *collectionView;
@end
