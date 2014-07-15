//
//  OfferDetail.h
//  OnlineKenakata-Demo
//
//  Created by Rabby Alam on 7/10/14.
//  Copyright (c) 2014 rabbi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWPhotoBrowser.h"


@interface OfferDetail : UIViewController<MWPhotoBrowserDelegate>{
    
    NSMutableArray *photos;
    
}


@property(nonatomic,strong)NSMutableDictionary *offerData;

@property (nonatomic, strong) NSMutableArray *pageImages;
@property (nonatomic, strong) NSMutableArray *pageViews;

@property (strong,nonatomic)IBOutlet UILabel *name;
@property (strong,nonatomic)IBOutlet UITextView *description;

@property (strong,nonatomic)IBOutlet UIScrollView *scrollView;

@property (strong,nonatomic)IBOutlet UIPageControl *pageControl;


@end
