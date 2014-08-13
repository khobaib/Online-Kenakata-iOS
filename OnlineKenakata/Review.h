//
//  Review.h
//  OnlineKenakata
//
//  Created by Apple on 8/12/14.
//  Copyright (c) 2014 OnlineKenakata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EDStarRating.h"

@interface Review : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    BOOL isReadMoreButtonTouched[5];

}
@property (strong,nonatomic)IBOutlet EDStarRating *TotalRating;
@property (strong,nonatomic) IBOutlet UILabel *reviewCount;
@property (strong,nonatomic) IBOutlet UILabel *numberOfStar;
@property (strong,nonatomic) IBOutlet UIScrollView *scrollview;
@property (strong,nonatomic) IBOutlet UIView *containView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;
@property (strong,nonatomic) IBOutlet UITableView *tableview;
@property (strong,nonatomic) IBOutlet UIView *barContainer;

@end
