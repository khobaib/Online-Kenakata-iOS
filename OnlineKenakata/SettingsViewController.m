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

-(void)viewDidAppear:(BOOL)animated{
    
    NSLog(@"log");
    [super viewWillAppear:animated];
    token=[[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    
   self.tabBarController.navigationItem.title=@"Settings";
    
    if(token!=nil){
        self.settingsTableHeight.constant=236;
    }else{
        self.settingsTableHeight.constant=177;
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
        NSString *str=[[NSUserDefaults standardUserDefaults]objectForKey:@"is_facebook"];
        
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
    if(token!=nil){
        return 4;
    }else{
        return 3;
    }
    
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(token!=nil){
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"settingCell" forIndexPath:indexPath];
       
        UILabel *lable=(UILabel *)[cell viewWithTag:1101];
        lable.text=@"";
        if(indexPath.row==1){
              lable.text=@"Change Password";
        }else if(indexPath.row==2){
              lable.text=@"Rate App";
        }else if (indexPath.row==3){
              lable.text=@"Logout";
        }else if(indexPath.row==0){
             lable.text=@"Info";
        }
        
      
        
        return cell;
        
    }else{
        
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"settingCell" forIndexPath:indexPath];
        
        UILabel *lable=(UILabel *)[cell viewWithTag:1101];
        
        lable.text=@"";
        
        if(indexPath.row==1){
             lable.text=@"Rate App";
        }else if(indexPath.row==2){
             lable.text=@"Login";
        }else if(indexPath.row==0){
            lable.text=@"Info";
        }
        
        
       
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(token!=nil){
        
        if(indexPath.row==0){
            [self performSegueWithIdentifier:@"pushinfo" sender:self];
        }
        if(indexPath.row==2){
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=905900408"]];
        }
        if(indexPath.row==3){
        
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Do you like to Logout?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
            [alert show];
        }
        
        if(indexPath.row==1){
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Please Enter The new password." delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
            [alert show];
        }
        
        
        
    }else{
        
        if(indexPath.row==0){
            [self performSegueWithIdentifier:@"pushinfo" sender:self];
        }
        if(indexPath.row==1){
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=905900408"]];
        }
        
        if(indexPath.row==2){
            LoginViewController *login =[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"loginScreen"];
            [self.navigationController pushViewController:login animated:YES];
        }
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==1){
        [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"token"];
        [FBSession.activeSession closeAndClearTokenInformation];
        [self viewDidAppear:YES];
    }
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
