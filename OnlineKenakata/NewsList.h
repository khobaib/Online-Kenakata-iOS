//
//  NewsList.h
//  OnlineKenakata-Demo
//
//  Created by Rabby Alam on 7/10/14.
//  Copyright (c) 2014 rabbi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingView.h"

@interface NewsList : UITableViewController{
    NSMutableArray *newsData;
    LoadingView *loading;
}

@end
