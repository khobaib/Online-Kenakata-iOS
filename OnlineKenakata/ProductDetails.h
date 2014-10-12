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
#import "EDStarRating.h"
#import "LoadingView.h"
@interface ProductDetails : UIViewController<UIScrollViewDelegate,MWPhotoBrowserDelegate,shareDelegate,MFMessageComposeViewControllerDelegate>{
    NSString *currency;
    NSMutableArray *photos;
    LoadingView *loading;
    
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
@property (strong,nonatomic) IBOutlet EDStarRating *starRater;
@property (strong,nonatomic) IBOutlet UIView *starRaterBack;
@property (strong,nonatomic) IBOutlet UILabel *favoritNumber;
@property (strong,nonatomic) IBOutlet UILabel *similarProductLable;

@property (strong,nonatomic) IBOutlet UIButton *favButton;


-(IBAction)imageEnlarge:(id)sender;

- (void)loadVisiblePages;
- (void)loadPage:(NSInteger)page;
- (void)purgePage:(NSInteger)page;
@end
