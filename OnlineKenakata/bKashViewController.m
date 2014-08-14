//
//  bKashViewController.m
//  OnlineKenakata
//
//  Created by Apple on 8/10/14.
//  Copyright (c) 2014 OnlineKenakata. All rights reserved.
//

#import "bKashViewController.h"
#import "AFNetworking/AFNetworking.h"
#import "Data.h"
#import "DatabaseHandeler.h"
@interface bKashViewController ()

@end

@implementation bKashViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)initLoading{
    CGFloat x= self.view.frame.size.width/2-65;
    CGFloat y =(self.view.frame.size.height-self.navigationController.navigationBar.frame.size.height-self.tabBarController.tabBar.frame.size.height)/2-25;
    
    loading=[[LoadingView alloc]initWithFrame:CGRectMake(x, y, 130, 50)];
    loading.hidden=YES;
    [self.view addSubview:loading];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    NSMutableDictionary *dic1=[NSKeyedUnarchiver unarchiveObjectWithData:[ud objectForKey:@"get_user_data"]];
     dic = [[dic1 objectForKey:@"success"]objectForKey:@"user"];
    self.textLable.text=[NSString stringWithFormat:@"Please dial bKash and pay to bKash Wallet no:%@ then type transaction ID bellod",[dic objectForKey:@"bKash_wallet_number"]];
    
   // NSLog(@"%@",self.params);
    
    callMade=NO;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)bKashButtonPresed:(id)sender{
    callMade=YES;
    [self makeCall];
}
-(void)makeCall{
    
    NSString *phoneNumber = [@"telprompt://" stringByAppendingString:@"*247#"];
    NSString *deviceType = [UIDevice currentDevice].model;
    //  NSLog(@"%@",deviceType);
    
    
    if([deviceType isEqualToString:@"iPhone"]){
        
        NSLog(@"make call");
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"your device doesnt support calling"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
    }
    
}
-(IBAction)sendButtonPressed:(id)sender{
    if(!callMade){
        return;
    }
    if([self.transactionID.text isEqualToString:@""]){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Please enter your transaction ID"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
        return;
    }
    [self.params setValue:self.transactionID.text forKey:@"transaction_id"];
    [self allDone];
}
/*
-(void)checkStock:(NSString *)str{
 
    NSString *string = [NSString stringWithFormat:@"%@/rest.php?method=get_products_by_productids&product_ids=%@&application_code=%@",[Data getBaseUrl],str,[Data getAppCode]];
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //  NSLog(@"%@",string);
    // 2
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self parsProductList:responseObject];
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        // 4
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error catagory List"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
    }];
    
    // 5
    //  [self.indecator startAnimating];
    loading.hidden=NO;
    [loading StartAnimating];
    [operation start];

    
}*/
-(void)allDone{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSString *str=[NSString stringWithFormat:@"%@/rest.php?method=add_order_4&application_code=%@",[Data getBaseUrl],[Data getAppCode]];
    
    [manager POST:str parameters:self.params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic1=(NSDictionary *)responseObject;
        if([[dic1 objectForKey:@"ok"] isEqualToString:@"success"]){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Success"
                                                                message:@"Please check your mail for details."
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
            [alertView show];
            
            if ([DatabaseHandeler deletAll]) {
                NSLog(@"clear");
            }
            
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    

}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
  return [textField resignFirstResponder];
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
