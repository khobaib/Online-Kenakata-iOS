//
//  PostSplashImageScreen.m
//  OnlineKenakata-Demo
//
//  Created by Rabby Alam on 7/8/14.
//  Copyright (c) 2014 rabbi. All rights reserved.
//

#import "PostSplashImageScreen.h"
#import "AFNetworking.h"
#import "Constant.h"
#import "UIImageView+WebCache.h"
#import "tabbarController.h"
#import "navicationController.h"
#import "FirstViewController.h"
#import "DatabaseHandeler.h"
#import "Data.h"
#import "DatabaseHandeler.h"
#import "Reachability.h"
#import "SDWebImageManager.h"
#import <AddressBook/AddressBook.h>



@interface PostSplashImageScreen ()

@end

@implementation PostSplashImageScreen

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)askContactsPermission{
  ABAddressBookRef  addressBook_ = ABAddressBookCreateWithOptions(NULL, NULL);
    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined)
    {
        ABAddressBookRequestAccessWithCompletion(addressBook_, ^(bool granted, CFErrorRef error)
                                                 {
                                                     if (granted == NO)
                                                     {
                                                         // Show an alert for no contact Access
                                                     }
                                                 });
    }
    else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized)
    {
        // The user has previously given access, good to go
    }
    else
    {
        // The user has previously denied access
        // Send an alert telling user to change privacy setting in settings app
    }
}
- (void)InternetUnavailable
{
    NSLog(@"There IS NO internet connection");
    
    SDWebImageManager *manager=[[SDWebImageManager alloc]init];
    NSUserDefaults *ud =[NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dic1=[NSKeyedUnarchiver unarchiveObjectWithData:[ud objectForKey:@"get_user_data"]];
    NSMutableDictionary* dic=[[dic1 objectForKey:@"success"]objectForKey:@"user"];
    
    NSString *url=[dic objectForKey:@"post_splash_image_url"];
    
    if([manager diskImageExistsForURL:[NSURL URLWithString:url]]){
        
        NSLog(@"present");
        [loading StopAnimating];
        loading.hidden=YES;
        navicationController *nav=[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"navigationController"];
        
        tabbarController *tbc=[nav.viewControllers objectAtIndex:0];
        
        
        FirstViewController *frst = [tbc.viewControllers objectAtIndex:0];
        frst.image=[[manager imageCache]imageFromDiskCacheForKey:url];
        
        
        [self presentViewController:nav animated:YES completion:nil];
        
    }else{
        
        [loading StopAnimating];
        loading.hidden=YES;
        navicationController *nav=[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"navigationController"];
        
        tabbarController *tbc=[nav.viewControllers objectAtIndex:0];
        
        
        FirstViewController *frst = [tbc.viewControllers objectAtIndex:0];
        frst.image=[UIImage imageNamed:@"PostSplash.png"];
        
        [self presentViewController:nav animated:YES completion:nil];
        
        
        NSLog(@"not present");
        
    }
}

- (void)viewDidLoad
{
    int height=[UIScreen mainScreen].bounds.size.height;
    if(height==480){
        [self.imageView setImage:[UIImage imageNamed:@"splash002.png"]];
        NSLog(@"%d",height);
        
    }else{
        
        [self.imageView setImage:[UIImage imageNamed:@"splash001.png"]];
        
    }
    [self initLoading];
    [self askContactsPermission];
    
   
   
   
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [super viewDidLoad];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
   
    
    // Do any additional setup after loading the view.
    
    
    // self.navigationController.navigationBar.hidden=YES;
    
    NSString *string = [NSString stringWithFormat:@"%@/rest_kenakata.php?method=get_user_data&application_code=%@",[Data getBaseUrl],[Data getAppCode]];

    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // 2
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self getUserData:(NSDictionary *)responseObject];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [loading StopAnimating];
        loading.hidden=YES;
        
        
        // 4
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Data"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];

    }];
    
    // 5
    
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        [self InternetUnavailable];
        
    } else {
        loading.hidden=NO;
        
        [loading StartAnimating];
        [operation start];
        
    }
    
    
}


- (BOOL)connected {
    return [AFNetworkReachabilityManager sharedManager].reachable;
}

-(void)initLoading{
    CGFloat x= self.view.frame.size.width/2-65;
    CGFloat y =(self.view.frame.size.height-self.navigationController.navigationBar.frame.size.height-self.tabBarController.tabBar.frame.size.height)/2-25;
    
    loading=[[LoadingView alloc]initWithFrame:CGRectMake(x, y, 130, 50)];
    loading.hidden=YES;
    [self.view addSubview:loading];
}

-(void)getUserData: (NSDictionary *) dic{

    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dic];


    [ud setObject:nil forKey:@"get_user_data"];

    [ud setObject: data forKey:@"get_user_data"];
    
    NSString *imageurl=[[[dic objectForKey:@"success"] objectForKey:@"user"]objectForKey:@"post_splash_image_url"];
    //NSLog(@"%@",imageurl);
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager downloadImageWithURL:[NSURL URLWithString:imageurl]
                     options:0
                    progress:^(NSInteger receivedSize, NSInteger expectedSize)
     {
         // progression tracking code
     }
                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished,NSURL *imageURL)
     {
         if (image)
         {
             if (image && finished)
             {
                 [loading StopAnimating];
                 loading.hidden=YES;
                 navicationController *nav=[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"navigationController"];
                 
                 tabbarController *tbc=[nav.viewControllers objectAtIndex:0];
                 
                 
                 FirstViewController *frst = [tbc.viewControllers objectAtIndex:0];
                 frst.image=image;
                 
                 [self presentViewController:nav animated:YES completion:nil];

                 
               //  self.navigationController.navigationBar.hidden=NO;

                
               
                 /*
                 
                 */
             }
         }else{
             [loading StopAnimating];
             loading.hidden=YES;
             
             
             
             navicationController *nav=[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"navigationController"];
             
             tabbarController *tbc=[nav.viewControllers objectAtIndex:0];
             
             
             FirstViewController *frst = [tbc.viewControllers objectAtIndex:0];
             frst.image=[UIImage imageNamed:@"PostSplash.png"];
             
             [self presentViewController:nav animated:YES completion:nil];
             
             
             NSLog(@"not present");

         }
         [self getMarchentData];
     }];
    
    
}
-(void)getMarchentData{
    
    
    NSString *string = [NSString stringWithFormat:@"%@/rest_kenakata.php?method=get_merchant_data&application_code=%@",[Data getBaseUrl],[Data getAppCode]];
    
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // 2
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableDictionary *dic=(NSMutableDictionary *)responseObject;
        
        [self saveMArchentData:[[dic objectForKey:@"success"] objectForKey:@"merchant"]];

        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       
        
        
        // 4
       
        
    }];

    [operation start];

}

-(void)saveMArchentData:(NSMutableArray *)data{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    

    [ud setObject:data forKey:@"marchent_data"];
    
    for(int i=0;i<data.count;i++){
        
        NSMutableDictionary *dic=[data objectAtIndex:i];
        
        NSString *key = [NSString stringWithFormat:@"marchent_data_%@",[dic objectForKey:@"user_id"]];
        [ud setObject:dic forKey:key];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation
/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

*/
@end
