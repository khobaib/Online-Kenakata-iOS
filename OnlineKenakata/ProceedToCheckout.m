//
//  ProceedToCheckout.m
//  OnlineKenakata
//
//  Created by Rabby Alam on 7/20/14.
//  Copyright (c) 2014 OnlineKenakata. All rights reserved.
//

#import "ProceedToCheckout.h"
#import "Product.h"
#import "SelfCollect.h"
#import "Delivery.h"
#import "UserData.h"
#import "DatabaseHandeler.h"
#import "TextStyling.h"
#import "Data.h"

@interface ProceedToCheckout ()

@end

@implementation ProceedToCheckout

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
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dic1=[NSKeyedUnarchiver unarchiveObjectWithData:[ud objectForKey:@"get_user_data"]];
    
    NSMutableDictionary *dic = [[dic1 objectForKey:@"success"]objectForKey:@"user"];
    
    currency=[dic objectForKey:@"currency"];
    [self setValueOntop];
    NSString *addToCartMEssage=[dic objectForKey:@"terms_and_conditions_message"];
    
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[addToCartMEssage dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    
    [self.agreeBtn setBackgroundColor:[TextStyling appColor]];
    
    [self.terms setAttributedText:attributedString];
}

-(void)setValueOntop{
    self.subtotalLable.text=[NSString stringWithFormat:@"Sub total (%luitems):",(unsigned long)self.productList.count];
    int total=0;
    for (int i=0; i<self.productList.count; i++) {
        Product *product=[self.productList objectAtIndex:i];
        
        total+= [product.PRICE intValue]*[product.QUANTITY intValue];
        
       
        
    }
    
    self.total.text=[NSString stringWithFormat:@"%@%d",currency,total+[Data getDeleveryCharge]];
    self.subtotal.text=[NSString stringWithFormat:@"%@%d",currency,total];
    self.deleveryChargeLabel.text=[NSString stringWithFormat:@"%@%d",currency,[Data getDeleveryCharge]];
}

-(IBAction)iAgree:(id)sender{
 /*   UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Please Choose "
                                                        message:@"How would you like to receive the items?"
                                                       delegate:self
                                              cancelButtonTitle:@"cancle"
                                              otherButtonTitles:@"Self-Collect",@"Delivery",nil];*/
   // [alertView show];
    
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    if(token!=nil){
        Delivery *dvc=[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"delivery"];
        dvc.productList=self.productList;
        
        [self.navigationController pushViewController:dvc animated:YES];
        
        
    }else{
        UserData *vc=[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"userData"];
        vc.productList=self.productList;
        vc.type=2;
        vc.tableData=[DatabaseHandeler getDeleveryMethods:2];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
    

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if(buttonIndex==1 || buttonIndex==2){
        UserData *vc=[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"userData"];
        vc.productList=self.productList;
        vc.type=(int)buttonIndex;
        vc.tableData=[DatabaseHandeler getDeleveryMethods:(int)buttonIndex];
        [self.navigationController pushViewController:vc animated:YES];
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
