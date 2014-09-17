//
//  OfferDetail.h
//  OnlineKenakata-Demo
//
//  Created by Rabby Alam on 7/10/14.
//  Copyright (c) 2014 rabbi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWPhotoBrowser.h"
#import "share.h"
#import <MessageUI/MessageUI.h>


@interface OfferDetail : UIViewController<MWPhotoBrowserDelegate,shareDelegate,MFMessageComposeViewControllerDelegate>{
    
    NSMutableArray *photos;
    
}


@property(nonatomic,strong)NSMutableDictionary *offerData;

@property (nonatomic, strong) NSMutableArray *pageImages;
@property (nonatomic, strong) NSMutableArray *pageViews;

@property (strong,nonatomic)IBOutlet UILabel *name;
@property (strong,nonatomic)IBOutlet UITextView *descriptionText; 

@property (strong,nonatomic)IBOutlet UIScrollView *scrollView;

@property (strong,nonatomic)IBOutlet UIPageControl *pageControl;


@end
