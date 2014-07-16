//
//  Info.h
//  OnlineKenakata-Demo
//
//  Created by Rabby Alam on 7/13/14.
//  Copyright (c) 2014 rabbi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWPhotoBrowser.h"
#import "share.h"
#import <MessageUI/MessageUI.h>


@interface Info : UIViewController<UITableViewDataSource,UITableViewDelegate,MWPhotoBrowserDelegate,UIAlertViewDelegate,shareDelegate,MFMessageComposeViewControllerDelegate>{
    NSMutableDictionary *dic;
    NSMutableArray *photos;

}

@property (nonatomic, strong) NSMutableArray *pageImages;
@property (nonatomic, strong) NSMutableArray *pageViews;

@property (strong,nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong,nonatomic) IBOutlet UIPageControl *pageControl;


@end
