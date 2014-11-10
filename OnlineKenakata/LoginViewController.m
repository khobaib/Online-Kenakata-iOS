//
//  LoginViewController.m
//  OnlineKenakata
//
//  Created by Apple on 8/13/14.
//  Copyright (c) 2014 OnlineKenakata. All rights reserved.
//

#import "LoginViewController.h"
#import "AFNetworking/AFNetworking.h"
#import "Data.h"
#import "MBProgressHUD.h"
#import "FacebookViewController.h"

#import "SignupViewController.h"
#import "UserData.h"
#import "DatabaseHandeler.h"

#import "Delivery.h"



@interface LoginViewController ()

@end

@implementation LoginViewController

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
    
    self.loginView.readPermissions = @[@"public_profile", @"email", @"user_friends"];
    [FBSettings setDefaultUrlSchemeSuffix:@"abcd"];
    //[FBSession.activeSession closeAndClearTokenInformation];
    
   
    if(self.fromProcideToCheckout){
        NSLog(@"Yes");
    }else{
        NSLog(@"No");
    }
    
    // Do any additional setup after loading the view.
}



-(IBAction)LoginButtonClicked:(id)sender{

    
    NSString *name=self.userNameField.text;
    NSString *password=self.passwordField.text;
    
    if([name isEqualToString:@""]||[password isEqualToString:@""]){
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Please fillup All the fields." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return;
    }
    /*
      if(![self NSStringIsValidEmail:email]){
      UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Enter Valid Email." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
      [alert show];
      return;
      }
      
      if(![self validatePhoneNumber:phone]){
      UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Enter Valid Phone Number." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
      [alert show];
      return;
      }
    */
    NSMutableDictionary *params=[[NSMutableDictionary alloc]init];
    
    [params setObject:name forKey:@"email"];
    
    
    
    [params setObject:password forKey:@"password"];
    [self loginNative:params];
    
    
    
}


- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
   
    NSMutableDictionary *data=[[NSMutableDictionary alloc]init];
    [data setObject:[NSString stringWithFormat:@"%@",[[FBSession activeSession]accessTokenData]] forKey:@"access_token"];
    
    [self facebokLogin:data];
    
}

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
   
}


-(void)facebokLogin:(NSMutableDictionary *)params{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    // manager.responseSerializer=[AFCompoundResponseSerializer serializer];
    
    NSString *str=[NSString stringWithFormat:@"%@/rest.php?method=registration",[Data getBaseUrl]];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.labelText = @"Please Wait";
    
    [manager POST:str parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic1=(NSDictionary *)responseObject;
             hud.hidden=YES;
        NSLog(@"%@",dic1);
        if([dic1 objectForKey:@"success"] !=nil){
            
            if([[[dic1 objectForKey:@"success"]objectForKey:@"registration_status"]intValue]==1){
             
                NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                
                
                 [ud setObject:[[dic1 objectForKey:@"success"]objectForKey:@"token"] forKey:@"token"];
                 [ud setObject:[[dic1 objectForKey:@"success"]objectForKey:@"email"] forKey:@"email"];
                 [ud setObject:[[dic1 objectForKey:@"success"]objectForKey:@"phone"] forKey:@"phone"];
                 [ud setObject:[[dic1 objectForKey:@"success"]objectForKey:@"name"] forKey:@"name"];
                 [ud setObject:[[dic1 objectForKey:@"success"]objectForKey:@"is_facebook"] forKey:@"is_facebook"];

            
                
                if(self.fromProcideToCheckout){
                    UserData *vc=[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"userData"];
                    
                    vc.type=2;
                    vc.tableData=[DatabaseHandeler getDeleveryMethods:2];
                    [self.navigationController pushViewController:vc animated:YES];
                    return ;
                }
                
                [self.navigationController popViewControllerAnimated:YES];
                
                
            }else{
                FacebookViewController *fvc=[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"fbsignup"];
                
                
                fvc.dic=[dic1 objectForKey:@"success"];
            
                [self.navigationController pushViewController:fvc animated:YES];
            }
          
        }
        
        if([dic1 objectForKey:@"error"] !=nil){
            
            NSString *message= [[dic1 objectForKey:@"error"]objectForKey:@"message"];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:message
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
            [alertView show];
            
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];

}



-(void)loginNative:(NSMutableDictionary *)params{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    // manager.responseSerializer=[AFCompoundResponseSerializer serializer];
    
    NSString *str=[NSString stringWithFormat:@"%@/rest.php?method=login",[Data getBaseUrl]];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [manager POST:str parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic1=(NSDictionary *)responseObject;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
         NSLog(@"%@",dic1);
       
        if([dic1 objectForKey:@"success"]!=nil){
         
            
  
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            
             [ud setObject:[[dic1 objectForKey:@"success"]objectForKey:@"token"] forKey:@"token"];
            [ud setObject:[[dic1 objectForKey:@"success"]objectForKey:@"email"] forKey:@"email"];
            [ud setObject:[[dic1 objectForKey:@"success"]objectForKey:@"phone"] forKey:@"phone"];
            [ud setObject:[[dic1 objectForKey:@"success"]objectForKey:@"name"] forKey:@"name"];
            [ud setObject:[[dic1 objectForKey:@"success"]objectForKey:@"is_facebook"] forKey:@"is_facebook"];

            
            
            if(self.fromProcideToCheckout){
                UserData *vc=[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"userData"];
                
                vc.type=2;
                vc.tableData=[DatabaseHandeler getDeleveryMethods:2];
                [self.navigationController pushViewController:vc animated:YES];
                return ;
            }

            
            [self.navigationController popViewControllerAnimated:YES];
        
           
        }
        
        if([dic1 objectForKey:@"error"]!=nil){
            
            NSString *message= [[dic1 objectForKey:@"error"]objectForKey:@"message"];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:message
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
            [alertView show];
            
            
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}




-(IBAction)SignupButtonAction:(id)sender{
    SignupViewController *signup=[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"Signup"];
    
    [self.navigationController pushViewController:signup animated:YES];
}

-(IBAction)skipbutton:(id)sender{
    
    if(self.fromProcideToCheckout){
        UserData *vc=[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"userData"];
      
        vc.type=2;
        vc.tableData=[DatabaseHandeler getDeleveryMethods:2];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        
        [self.navigationController popViewControllerAnimated:YES];

    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}



#pragma mark -validation

-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
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
