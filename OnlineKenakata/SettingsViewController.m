//
//  SettingsViewController.m
//  OnlineKenakata
//
//  Created by MC MINI on 10/15/14.
//  Copyright (c) 2014 OnlineKenakata. All rights reserved.
//

#import "SettingsViewController.h"
#import "LoginViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "TextStyling.h"
#import "HowItWorksViewController.h"
#import "AFNetworking.h"
#import "Data.h"
#import "MBProgressHUD.h"
#import <CommonCrypto/CommonDigest.h>

@interface SettingsViewController ()

@end

@implementation SettingsViewController

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
}

-(void)viewWillAppear:(BOOL)animated{
    

    [super viewWillAppear:animated];
    
    self.screenName=@"Settings";
    token=[[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    
   self.tabBarController.navigationItem.title=@"Settings";
    
    NSString *str=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"is_facebook"]];
    

    if(token!=nil && ![str isEqualToString:@"true"]){
        self.settingsTableHeight.constant=431;
    }else{
        self.settingsTableHeight.constant=354;
    }
    
    [self setDataOnUI];
    
   
    [self.table reloadData];
}

-(void)home:(UIBarButtonItem *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    

    
  [self.tabBarController.navigationItem setLeftBarButtonItem:nil];
}



-(void)setDataOnUI{
    if(token!=nil){
        NSString *str=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"is_facebook"]];
        
        
        NSLog(@"%@",str);
        
        if([str isEqualToString:@"true"]){
            self.loggedinVia.text=@"Logged in Via:Facebook";

        }else{
            self.loggedinVia.text=@"Logged in Via:Online Kenakata";
        }
        self.username.text=[NSString stringWithFormat:@"Username: %@",[[NSUserDefaults standardUserDefaults]objectForKey:@"name"]];
        self.email.text=[NSString stringWithFormat:@"Email: %@",[[NSUserDefaults standardUserDefaults]objectForKey:@"email"]];
        
        self.appvertion.text=@"Kenakata 1.0.0";
        self.username.hidden=NO;
        self.email.hidden=NO;
        self.appvertion.hidden=NO;
        
    }else{
        self.loggedinVia.text=@"Kenakata 1.0.0";
        
        self.username.hidden=YES;
        self.email.hidden=YES;
        self.appvertion.hidden=YES;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString *str=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"is_facebook"]];

    if(token!=nil && ![str isEqualToString:@"true"]){
        
        return 7;
   
    }else{
        return 6;
    }
    
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *str=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"is_facebook"]];

    if(token!=nil && ![str isEqualToString:@"true"]){
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"settingCell" forIndexPath:indexPath];
       
        UILabel *lable=(UILabel *)[cell viewWithTag:1101];
        lable.text=@"";
        
        
        if(indexPath.row==0){
            lable.text=@"Recently Viewed";
        }else if(indexPath.row==1){
            lable.text=@"Find a Store";
        }else if(indexPath.row==2){
          lable.text=@"Change Password";
        }
        else if(indexPath.row==3){
            lable.text=@"Rate App";
        }else if (indexPath.row==4){
            lable.text=@"Info";
        }else if(indexPath.row==5){
            lable.text=@"How It works";
        }else if(indexPath.row==6){
            lable.text=@"Logout";
        }

        return cell;
        
    }else{
        
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"settingCell" forIndexPath:indexPath];
        
        UILabel *lable=(UILabel *)[cell viewWithTag:1101];
        
        lable.text=@"";
        
        if(indexPath.row==0){
            lable.text=@"Recently Viewed";
        }else if(indexPath.row==1){
            lable.text=@"Find a Store";
        }else if(indexPath.row==2){
            lable.text=@"Rate App";
        }else if (indexPath.row==3){
            lable.text=@"Info";
        }else if(indexPath.row==4){
            lable.text=@"How It works";
        }else if(indexPath.row==5){
            
            if(token!=nil){
                lable.text=@"Logout";
            }else{
                lable.text=@"Login";
            }
            
        }
        
        
        
       
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *str=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"is_facebook"]];
    
    if(token!=nil && ![str isEqualToString:@"true"]){
        if(indexPath.row==0){
          [self performSegueWithIdentifier:@"recentlyViewed" sender:self];
        
        }else if(indexPath.row==1){
            
         [self performSegueWithIdentifier:@"locationseg" sender:self];

        }else if(indexPath.row==2){
            [self passwordChange];
            
        }else if(indexPath.row==3){
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=905900408"]];
            
        }else if(indexPath.row==4){
            [self performSegueWithIdentifier:@"pushinfo" sender:self];
        
        }else if(indexPath.row==5){
            HowItWorksViewController *hvc=[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"howitWorks"];
            
            [self.navigationController pushViewController:hvc animated:YES];
        
        }else if(indexPath.row==6){
        
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Do you like to Logout?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
            [alert show];
            alert.tag=1;
        }
        
        
        
        
    }else{
        
        if(indexPath.row==0){
            [self performSegueWithIdentifier:@"recentlyViewed" sender:self];
            
        }else if(indexPath.row==1){
            
            [self performSegueWithIdentifier:@"locationseg" sender:self];
            
        }else if(indexPath.row==2){
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=941047309"]];
            
        }else if(indexPath.row==3){
            [self performSegueWithIdentifier:@"pushinfo" sender:self];
            
        }else if(indexPath.row==4){
            HowItWorksViewController *hvc=[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"howitWorks"];
            
            [self.navigationController pushViewController:hvc animated:YES];
            
        }else if(indexPath.row==5){
            if(token!=nil){
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Do you like to Logout?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
                [alert show];
                alert.tag=1;
            }else{
                LoginViewController *login =[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"loginScreen"];
                [self.navigationController pushViewController:login animated:YES];
            }
            
        }
        
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==1 && alertView.tag==1){
        [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"token"];
        [FBSession.activeSession closeAndClearTokenInformation];
        [self viewDidAppear:YES];
    }
    if(buttonIndex==1 && alertView.tag==2){
        
        UITextField *textField = [alertView textFieldAtIndex:0];
        
        [self changePassURL:textField.text];
    }
}

-(void)passwordChange{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Please Enter The new password." delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    
    
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    /* Display a numerical keypad for this text field */
    UITextField *textField = [alert textFieldAtIndex:0];
    textField.secureTextEntry=YES;

    [alert show];
    alert.tag=2;
}


-(void)changePassURL:(NSString *)newpass{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    // manager.responseSerializer=[AFCompoundResponseSerializer serializer];
    
    NSMutableDictionary *params=[[NSMutableDictionary alloc]init];

    params[@"new_pass"]=[SettingsViewController md5HexDigest:newpass];
    params[@"token"]=[[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    params[@"isNew"]=@"1";
    
    NSString *str=[NSString stringWithFormat:@"%@/rest.php?method=pass_change",[Data getBaseUrl]];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
 
    [manager POST:str parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic1=(NSDictionary *)responseObject;
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        
        if([dic1[@"success"] isEqualToString:@"ok"]){
            UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"কেনাকাটা" message:@"Your password is reset" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alertView show];
        }
        
        NSLog(@"%@",dic1);
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
        
         NSLog(@"Error: %@", error);
     }];

}

+(NSString*)md5HexDigest:(NSString*)input {
    const char* str = [input UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, strlen(str), result);
    
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
    for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x",result[i]];
    }
    return ret;
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
