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

    
    // Do any additional setup after loading the view.
    // Do any additional setup after loading the view.
    
   
}

-(void)localNotificationReceived{
    
    [self myCart];
}
-(void)viewWillAppear:(BOOL)animated{
    

  //    UIBarButtonItem *button=[[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(myCart)];
 //   [button setImage:[UIImage imageNamed:@"my_cart.png"]];
    
 //   button.imageInsets = UIEdgeInsetsMake(0.0, 0, 0, 10);
    
    UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
    [btn setImage:[UIImage imageNamed:@"my_cart.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(myCart) forControlEvents:UIControlEventTouchUpInside];
   // btn.imageEdgeInsets= UIEdgeInsetsMake(0.0, 0, 0, 10);
    
    BBBadgeBarButtonItem *barButton = [[BBBadgeBarButtonItem alloc] initWithCustomUIButton:btn];
    [barButton setImageInsets:UIEdgeInsetsMake(0.0, 0, 0, 10)];

  
    barButton.badgeBGColor=[UIColor redColor];
    barButton.badgeValue=[NSString stringWithFormat:@"%d",[DatabaseHandeler totalProduct]];
    [barButton setBadgeValue:[NSString stringWithFormat:@"%d",[DatabaseHandeler totalProduct]]];
    NSLog(@" badge%@",barButton.badgeValue);
    barButton.badgeOriginX=10;
    barButton.badgeOriginY=0;

    
    [self.navigationItem setRightBarButtonItem:barButton];

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
