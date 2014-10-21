//
//  NewsDetail.h
//  OnlineKenakata-Demo
//
//  Created by Rabby Alam on 7/12/14.
//  Copyright (c) 2014 rabbi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "share.h"
#import <MessageUI/MessageUI.h>

@interface NewsDetail : UIViewController<shareDelegate,MFMessageComposeViewControllerDelegate>{
    
}
@property (strong,nonatomic) NSDictionary *dic;

@property (strong,nonatomic) IBOutlet UIImageView *imageView;
@property (strong,nonatomic) IBOutlet UILabel *name;
@property (strong,nonatomic) IBOutlet UITextView *descriptionText;

@end
