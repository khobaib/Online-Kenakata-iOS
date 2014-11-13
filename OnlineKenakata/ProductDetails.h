//
//  ProductDetails.h
//  OnlineKenakata-Demo
//
//  Created by Rabby Alam on 7/9/14.
//  Copyright (c) 2014 rabbi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWPhotoBrowser.h"
#import <MessageUI/MessageUI.h>
#import "share.h"
#import "RateView.h"
#import "LoadingView.h"
#import "GAITrackedViewController.h"
@interface ProductDetails : GAITrackedViewController<UIScrollViewDelegate,MWPhotoBrowserDelegate,shareDelegate,MFMessageComposeViewControllerDelegate,UIGestureRecognizerDelegate>{
    NSString *currency;
    NSMutableArray *photos;
    LoadingView *loading;
    UIView *loadingTempView;
    BOOL favFlag;
}

@property NSMutableDictionary *productData;
@property NSMutableArray *similarProducrsData;
@property NSMutableArray *similarProductPage;

@property (nonatomic, strong) NSMutableArray *pageImages;
@property (nonatomic, strong) NSMutableArray *pageViews;
@property (strong,nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong,nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong,nonatomic) IBOutlet UIScrollView *scrl;

@property(strong,nonatomic) IBOutlet UILabel *name;
@property(strong,nonatomic) IBOutlet UILabel *oldPrice;
@property(strong,nonatomic) IBOutlet UILabel *priceNew;
@property(strong,nonatomic) IBOutlet UITextView *productDetails;
@property(strong,nonatomic) IBOutlet UILabel *itemCode;
@property (strong,nonatomic) IBOutlet UILabel *itemCodeLable;
@property (strong,nonatomic) IBOutlet UIButton *cartBtn;
@property (strong,nonatomic) IBOutlet UIScrollView *horizontalScroller;
@property (strong,nonatomic) IBOutlet RateView *starRater;
@property (strong,nonatomic) IBOutlet UIView *starRaterBack;
@property (strong,nonatomic) IBOutlet UILabel *favoritNumber;



@property (strong, nonatomic) IBOutlet NSLayoutConstraint *scrollHeight;
@property IBOutlet UIView *containerView;

@property (strong,nonatomic) IBOutlet UIButton *favButton;
@property (strong,nonatomic) IBOutlet UIImageView *logoImageView;
@property (strong,nonatomic) IBOutlet UILabel *productCode;

@property IBOutlet UICollectionView *collectionView;

-(IBAction)imageEnlarge:(id)sender;

- (void)loadVisiblePages;
- (void)loadPage:(NSInteger)page;
- (void)purgePage:(NSInteger)page;
@end
