//
//  PostSplashImageScreen.h
//  OnlineKenakata-Demo
//
//  Created by Rabby Alam on 7/8/14.
//  Copyright (c) 2014 rabbi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingView.h"




@interface PostSplashImageScreen : UIViewController
{
    LoadingView *loading;
   
}
@property IBOutlet UIScrollView *scrollView;
@property IBOutlet UIImageView *imageView;

-(void)getUserData: (NSDictionary *) dic;


@end
  