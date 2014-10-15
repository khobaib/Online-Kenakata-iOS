//
//  tabbarController.m
//  OnlineKenakata-Demo
//
//  Created by Rabby Alam on 7/8/14.
//  Copyright (c) 2014 rabbi. All rights reserved.
//

#import "tabbarController.h"
#import "MyCart.h"
#import "DatabaseHandeler.h"
#import "BBBadgeBarButtonItem.h"
#import "TextStyling.h"

@interface tabbarController ()

@end

@implementation tabbarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localNotificationReceived) name:@"localNotification" object:nil];

    self.moreNavigationController.delegate = self;


    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
     //   locationmanager=[[CLLocationManager alloc]init];
        //  manager.delegate = self;
       // [locationmanager requestWhenInUseAuthorization];
    }
   
}


- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated
{

      navigationController.navigationBarHidden=YES;
}



-(void)localNotificationReceived{
    
    [self myCart];
}
-(void)viewWillAppear:(BOOL)animated{
    
    
    UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(275, -6, 50, 50)];

    [btn setBackgroundImage:[UIImage imageNamed:@"my_cart.png"] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:10];

   // [btn setBackgroundImage:[self imageWithColor:[UIColor blueColor]] forState:UIControlStateHighlighted];
    
   // [btn setBackgroundColor:[UIColor whiteColor]];
    [btn addTarget:self action:@selector(myCart) forControlEvents:UIControlEventTouchUpInside];
   // btn.imageEdgeInsets= UIEdgeInsetsMake(0.0, 0, 0, 10);
    
    BBBadgeBarButtonItem *barButton = [[BBBadgeBarButtonItem alloc] initWithCustomUIButton:btn];
   // [barButton setImageInsets:UIEdgeInsetsMake(0.0, 0, 0, 10)];

  
    barButton.badgeBGColor=[UIColor redColor];
    [barButton setBadgeValue:[NSString stringWithFormat:@"%d",[DatabaseHandeler totalProduct]]];
    barButton.badgeOriginX=16;
    barButton.badgeOriginY=4;
    [barButton setBadgePadding:3];

   // [self.navigationItem setRightBarButtonItem:button];
    self.barBtn=btn;
    self.barBtn.tag=1;
    [self.navigationController.navigationBar addSubview:self.barBtn];

    btn=nil;
}
-(void)myCart{
    MyCart *cart=[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"MyCart"];
    
    cart.productList=[DatabaseHandeler getProduct];

 //   NSLog(@"log %d",cart.productList.count);
    if(cart.productList.count<1){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error "
                                                            message:@"My Cart is empty"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
        return;
    }
    [self.navigationController pushViewController:cart animated:YES];
    
}
- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 5.0f, 5.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
