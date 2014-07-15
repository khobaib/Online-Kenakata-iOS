//
//  WebBrowser.m
//  OnlineKenakata-Demo
//
//  Created by Rabby Alam on 7/13/14.
//  Copyright (c) 2014 rabbi. All rights reserved.
//

#import "WebBrowser.h"

@interface WebBrowser ()

@end

@implementation WebBrowser

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
    // Do any additional setup after loading the view.
    [self initLoading];
    
    
    NSURL *url=[NSURL URLWithString:self.url];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:req];
    loading.hidden=NO;
    [loading StartAnimating];
}
-(void)initLoading{
    CGFloat x= self.view.frame.size.width/2-65;
    CGFloat y =(self.view.frame.size.height-self.navigationController.navigationBar.frame.size.height-self.tabBarController.tabBar.frame.size.height)/2-25;
    // NSLog(@"%f  %f",x,y);
    
    loading=[[LoadingView alloc]initWithFrame:CGRectMake(x, y, 130, 50)];
    loading.hidden=YES;
    [self.view addSubview:loading];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [loading StopAnimating];
    loading.hidden=YES;
    
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
