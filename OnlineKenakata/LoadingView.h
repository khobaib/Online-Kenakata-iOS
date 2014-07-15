//
//  LoadingView.h
//  OnlineKenakata-Demo
//
//  Created by Rabby Alam on 7/9/14.
//  Copyright (c) 2014 rabbi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingView : UIView{
    UIActivityIndicatorView *activityIndicator;
}


-(void)StartAnimating;
-(void)StopAnimating;
@end
