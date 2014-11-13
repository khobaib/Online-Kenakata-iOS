//
//  PostSplashImageScreen.h
//  OnlineKenakata-Demo
//
//  Created by Rabby Alam on 7/8/14.
//  Copyright (c) 2014 rabbi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingView.h"
#import "navicationController.h"
#import "GAITrackedViewController.h"




@interface PostSplashImageScreen : GAITrackedViewController
{
    LoadingView *loading;
   
}
@property IBOutlet UIScrollView *scrollView;
@property IBOutlet UIImageView *imageView;
@property navicationController *nav;

-(void)getUserData: (NSDictionary *) dic;


@end
  