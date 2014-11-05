//
//  WriteReviewViewController.h
//  OnlineKenakata
//
//  Created by MC MINI on 8/18/14.
//  Copyright (c) 2014 OnlineKenakata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EDStarRating/EDStarRating.h"
#import "LoadingView.h"

@interface WriteReviewViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate,EDStarRatingProtocol>{
    
    LoadingView *loading;

    
}
@property (strong,nonatomic) NSString *productID;
@property (strong,nonatomic) IBOutlet EDStarRating *starRater;
@property (strong,nonatomic) IBOutlet UITextField *Headline;
@property (strong,nonatomic) IBOutlet UITextView *detailReview;
@property (strong,nonatomic) IBOutlet  UIButton *submit;

@property (strong,nonatomic) NSDictionary *userReview;

@end
