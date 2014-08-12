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
    
}
@property (strong,nonatomic)IBOutlet EDStarRating *TotalRating;
@property (strong,nonatomic) IBOutlet UILabel *reviewCount;
@property (strong,nonatomic) IBOutlet UILabel *numberOfStar;
@end
