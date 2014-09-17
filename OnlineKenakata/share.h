//
//  share.h
//  OnlineKenakata
//
//  Created by Rabby Alam on 7/15/14.
//  Copyright (c) 2014 OnlineKenakata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@protocol shareDelegate <NSObject>

@required
-(void)setMessanger;

@end

@interface share : UIView{
    UIActionSheet *action;
}
@property (nonatomic, weak) id <shareDelegate> delegate;


@property (strong,nonatomic) NSString *titleName;
@property (strong,nonatomic) NSString *descriptionText;
@property (strong,nonatomic) NSString *caption;
@property (strong,nonatomic) UIImage *image;
@property (strong,nonatomic) NSString *url;
@property (strong,nonatomic) NSString *imageUrl;
@property (strong,nonatomic) UIViewController *viewController;
@property (strong,nonatomic) NSString *emailBody;
@property (strong,nonatomic) NSString *emailSub;
@property (strong,nonatomic) NSString *smsBody;
- (id)initWithFrame:(CGRect)frame actionSheet:(UIActionSheet *)sheet;
@end
