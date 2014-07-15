//
//  LoadingView.m
//  OnlineKenakata-Demo
//
//  Created by Rabby Alam on 7/9/14.
//  Copyright (c) 2014 rabbi. All rights reserved.
//

#import "LoadingView.h"
#import <QuartzCore/QuartzCore.h>

@implementation LoadingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    
        self.backgroundColor = [UIColor blackColor];
        [self setAlpha:0.80];
        
        [self.layer setCornerRadius:5.0f];
        
        // border
        [self.layer setBorderColor:[UIColor lightGrayColor].CGColor];
        [self.layer setBorderWidth:1.5f];
        
        // drop shadow
        [self.layer setShadowColor:[UIColor blackColor].CGColor];
        [self.layer setShadowOpacity:0.8];
        [self.layer setShadowRadius:3.0];
        [self.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
        activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        activityIndicator.frame = CGRectMake(0, 0, 50, self.frame.size.height );
        activityIndicator.backgroundColor = [UIColor clearColor];
        
        [self addSubview:activityIndicator];
        
        CGFloat labelX = activityIndicator.bounds.size.width + 2;
        
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(labelX, 0.0f, self.bounds.size.width - (labelX + 2), self.frame.size.height)];
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        label.font = [UIFont boldSystemFontOfSize:15.0f];
        label.numberOfLines = 1;
        
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.text = @"Loading...";
        
        [self addSubview:label];
        
    }
    return self;
}


-(void)StartAnimating{
    [activityIndicator startAnimating];
}
-(void)StopAnimating{
    [activityIndicator stopAnimating];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
