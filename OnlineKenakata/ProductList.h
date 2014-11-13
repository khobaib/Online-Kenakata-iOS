//
//  ProductList.h
//  OnlineKenakata-Demo
//
//  Created by Rabby Alam on 7/9/14.
//  Copyright (c) 2014 rabbi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingView.h"
#import "RMPickerViewController.h"
#import "GAITrackedViewController.h"

@interface ProductList : GAITrackedViewController<UICollectionViewDelegate,UICollectionViewDataSource,UIPickerViewDataSource,UIPickerViewDelegate,RMPickerViewControllerDelegate>{

    NSMutableArray *catagoryList;
    NSMutableArray *productList;
    NSString *currency;
    LoadingView *loading;
    int counter;
    BOOL isLoading;
    
    RMPickerViewController *sortByPicker;
}
@property NSString *productId;
@property NSString *catagoryName;
@property (strong,nonatomic) IBOutlet UICollectionView *collectionView;


-(void)parsProductList:(id) respons;
@end
