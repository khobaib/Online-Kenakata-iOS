//
//  HowItWorksViewController.h
//  kenakata
//
//  Created by MC MINI on 11/9/14.
//  Copyright (c) 2014 OnlineKenakata. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HowItWorksViewController : UIViewController{
    
}

@property (nonatomic, strong) NSMutableArray *pageImages;
@property (nonatomic, strong) NSMutableArray *pageViews;
@property (strong,nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong,nonatomic) IBOutlet UIPageControl *pageControl;


@end
