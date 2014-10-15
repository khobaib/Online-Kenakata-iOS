//
//  FacebookViewController.m
//  OnlineKenakata
//
//  Created by MC MINI on 9/30/14.
//  Copyright (c) 2014 OnlineKenakata. All rights reserved.
//

#import "FacebookViewController.h"
#import "Data.h"
#import "Delivery.h"

@interface FacebookViewController ()

@end

@implementation FacebookViewController

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
    self.email.text=[self.dic objectForKey:@"email"];
    self.name.text=[self.dic objectForKey:@"name"];

    // Do any additional setup after loading the view.
}

-(IBAction)signupoButtonPressed:(id)sender{
    NSString *name=self.name.text;
    NSString *phone =self.phone.text;
    if([name isEqualToString:@""] || [phone isEqualToString:@""]){
        UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"Error" message:@"Please fillup all the forms." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    }else if([self validatePhoneNumber:phone]){
        NSMutableDictionary *param=[[NSMutableDictionary alloc]init];
        [param setObject:name forKey:@"name"];
        [param setObject:phone forKey:@"phone"];
        [param setObject:self.email.text forKey:@"email"];
        [param setObject:[NSString stringWithFormat:@"%@",[[FBSession activeSession]accessTokenData]] forKey:@"access_token"];
        
        [self signUP:param];
    }else{
        UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"Error" message:@"Please Enter valid phone number." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
    }
}

-(void)signUP:(NSMutableDictionary *)params{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    // manager.responseSerializer=[AFCompoundResponseSerializer serializer];
    
    NSString *str=[NSString stringWithFormat:@"%@/rest.php?method=registerviafb",[Data getBaseUrl]];
    
    [manager POST:str parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic1=(NSDictionary *)responseObject;
        
        NSLog(@"%@",dic1);
        if(![[dic1 objectForKey:@"success"] isEqualToString:@""]){
          
            
             NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            
            [ud setObject:[[dic1 objectForKey:@"success"]objectForKey:@"token"] forKey:@"token"];
            [ud setObject:[[dic1 objectForKey:@"success"]objectForKey:@"email"] forKey:@"email"];
            [ud setObject:[[dic1 objectForKey:@"success"]objectForKey:@"phone"] forKey:@"phone"];
            [ud setObject:[[dic1 objectForKey:@"success"]objectForKey:@"name"] forKey:@"name"];
            [ud setObject:[[dic1 objectForKey:@"success"]objectForKey:@"is_facebook"] forKey:@"is_facebook"];

            if(self.fromProcideToCheckout){
                Delivery *dvc=[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"delivery"];
                
                
                [self.navigationController pushViewController:dvc animated:YES];
                return ;
            }

            
            [self.navigationController popToRootViewControllerAnimated:YES];
            
            
            if([[dic1 objectForKey:@"error"] isEqualToString:@""]){
                
                NSString *message= [[dic1 objectForKey:@"error"]objectForKey:@"message"];
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                    message:message
                                                                   delegate:nil
                                                          cancelButtonTitle:@"Ok"
                                                          otherButtonTitles:nil];
                [alertView show];
                
                
            }
            
            //
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
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
