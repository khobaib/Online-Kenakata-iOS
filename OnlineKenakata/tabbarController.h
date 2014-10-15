//
//  tabbarController.h
//  OnlineKenakata-Demo
//
//  Created by Rabby Alam on 7/8/14.
//  Copyright (c) 2014 rabbi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>


@interface tabbarController : UITabBarController<UINavigationControllerDelegate>{
     CLLocationManager *locationmanager;
}

@property (nonatomic,strong) UIButton *barBtn;

@end
