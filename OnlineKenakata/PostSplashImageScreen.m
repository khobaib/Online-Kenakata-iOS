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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view.
    

   // self.navigationController.navigationBar.hidden=YES;
    
    NSString *string = [NSString stringWithFormat:@"http://online-kenakata.com/mobile_api/rest.php?method=get_user_data&application_code=%@",AppCode];
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // 2
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self getUserData:(NSDictionary *)responseObject];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        // 4
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Data"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
    }];
    
    // 5
    [self.indecator startAnimating];
    [operation start];
}

-(void)getUserData: (NSDictionary *) dic{

    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
  //  NSData *data = [NSKeyedArchiver archivedDataWithRootObject:dic];
    
    [ud setObject:dic forKey:@"get_user_data"];
    NSString *imageurl=[[[dic objectForKey:@"success"] objectForKey:@"user"]objectForKey:@"post_splash_image_url"];
    //NSLog(@"%@",imageurl);
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager downloadWithURL:[NSURL URLWithString:imageurl]
                     options:0
                    progress:^(NSInteger receivedSize, NSInteger expectedSize)
     {
         // progression tracking code
     }
                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished)
     {
         if (image)
         {
             if (image && finished)
             {
                
                 [self.indecator stopAnimating];
                 self.indecator.hidden=YES;
                 navicationController *nav=[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"navigationController"];
                 
                 tabbarController *tbc=[nav.viewControllers objectAtIndex:0];
                 
                 
                 FirstViewController *frst = [tbc.viewControllers objectAtIndex:0];
                 frst.image=image;
                 
                 [self presentViewController:nav animated:YES completion:nil];

                 
               //  self.navigationController.navigationBar.hidden=NO;

                
               
                 /*
                 
                 */
             }
         }
     }];
    
    
}
-(void)imageDownloaded{
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
