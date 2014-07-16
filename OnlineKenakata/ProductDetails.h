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
@interface ProductDetails : UIViewController<UIScrollViewDelegate,MWPhotoBrowserDelegate,shareDelegate,MFMessageComposeViewControllerDelegate>{
    NSString *currency;
    NSMutableArray *photos;
}

@property NSMutableDictionary *productData;

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


-(IBAction)imageEnlarge:(id)sender;

- (void)loadVisiblePages;
- (void)loadPage:(NSInteger)page;
- (void)purgePage:(NSInteger)page;
@end
