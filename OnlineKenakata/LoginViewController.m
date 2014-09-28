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
    // Do any additional setup after loading the view.
}

-(IBAction)LoginButtonClicked:(id)sender{

    
    NSString *name=self.userNameField.text;
    NSString *password=self.passwordField.text;
    
    if([name isEqualToString:@""]||[password isEqualToString:@""]){
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Please fillup All the fields." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return;
    }/*
      if(![self NSStringIsValidEmail:email]){
      UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Enter Valid Email." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
      [alert show];
      return;
      }
      
      if(![self validatePhoneNumber:phone]){
      UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Enter Valid Phone Number." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
      [alert show];
      return;
      }*/
    
    NSMutableDictionary *params=[[NSMutableDictionary alloc]init];
    
    [params setObject:name forKey:@"email"];
    
    
    
    [params setObject:password forKey:@"password"];
    [self signUP:params];
    
    
    
}


-(void)signUP:(NSMutableDictionary *)params{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    // manager.responseSerializer=[AFCompoundResponseSerializer serializer];
    
    NSString *str=[NSString stringWithFormat:@"%@/rest.php?method=login",[Data getBaseUrl]];
    
    [manager POST:str parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic1=(NSDictionary *)responseObject;
        
         NSLog(@"%@",dic1);
        if(![[dic1 objectForKey:@"Success"] isEqualToString:@""]){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Success"
                                                                message:@"Login"
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
            [alertView show];
            [self dismissViewControllerAnimated:YES completion:nil];
        
           
        }
        
        if([[dic1 objectForKey:@"error"] isEqualToString:@""]){
            
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


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}

-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

-(BOOL)validatePhoneNumber:(NSString *)phoneNumber{
    
    NSString *phoneRegex = @"^01[0-9]{9}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    BOOL test1=  [phoneTest evaluateWithObject:phoneNumber];
    
    NSString *phoneRegex2=@"^\\+8801[0-9]{9}$";
    NSPredicate *phoneTest2=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex2];
    BOOL test2=[phoneTest2 evaluateWithObject:phoneNumber];
    
    NSString *phoneRegex3=@"^01[1-9]-[0-9]{3}-[0-9]{5}";
    NSPredicate *phoneTest3=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex3];
    BOOL test3=[phoneTest3 evaluateWithObject:phoneNumber];
    
    NSString *phoneRegex4=@"^\\+8801[1-9]-[0-9]{3}-[0-9]{5}";
    NSPredicate *phoneTest4=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex4];
    BOOL test4=[phoneTest4 evaluateWithObject:phoneNumber];
    
    return test1|test2|test4|test3;
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
