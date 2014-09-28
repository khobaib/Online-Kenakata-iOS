//
//  WriteReviewViewController.m
//  OnlineKenakata
//
//  Created by MC MINI on 8/18/14.
//  Copyright (c) 2014 OnlineKenakata. All rights reserved.
//

#import "WriteReviewViewController.h"
#import "Data.h"
#import "TextStyling.h"
#import "AFNetworking/AFNetworking.h"

@interface WriteReviewViewController ()

@end

@implementation WriteReviewViewController

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
    
    
    self.starRater.starImage=[UIImage imageNamed:@"star.png"];
    self.starRater.starHighlightedImage=[UIImage imageNamed:@"starhighlighted.png"];
    
    self.starRater.maxRating = 5;
    self.starRater.delegate=self;
    
    self.starRater.horizontalMargin = 12;
    self.starRater.editable=YES;
    self.starRater.rating= 0;
    
    
    self.starRater.displayMode=EDStarRatingDisplayFull;
    [self initLoading];
    
    self.description.layer.borderWidth = 3.0f;
     self.description.layer.borderColor = [[UIColor lightGrayColor] CGColor];

    self.description.layer.cornerRadius=5.0f;
    
    [self.submit setBackgroundColor:[TextStyling appColor]];
    [self initLoading];
    // Do any additional setup after loading the view.
    //NSLog(@"product id %@",self.productID);
}




- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"Write your review here"]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor]; //optional
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Write your review here";
        textView.textColor = [UIColor lightGrayColor]; //optional
    }
    [textView resignFirstResponder];
}

-(void)initLoading{
    CGFloat x= self.view.frame.size.width/2-65;
    CGFloat y =(self.view.frame.size.height-self.navigationController.navigationBar.frame.size.height-self.tabBarController.tabBar.frame.size.height)/2-25;
    
    loading=[[LoadingView alloc]initWithFrame:CGRectMake(x, y, 130, 50)];
    loading.hidden=YES;
    [self.view addSubview:loading];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField; {
    return [textField resignFirstResponder];
}


-(void)starsSelectionChanged:(EDStarRating*)control rating:(float)rating{
    control.rating=rating;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - keyboard movements
- (void)keyboardWillShow:(NSNotification *)notification
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect f = self.view.frame;
        f.origin.y = -25.0f ; //set the -35.0f to your required value
        self.view.frame = f;
    }];
}

-(void)keyboardWillHide:(NSNotification *)notification
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect f = self.view.frame;
        f.origin.y = 0.0f+self.navigationController.navigationBar.frame.size.height+20;
        self.view.frame = f;
    }];
}

-(IBAction)SubmitButtonPressed:(id)sender{
    [self.Headline resignFirstResponder];
    [self.description resignFirstResponder];
    NSString *tittle=self.Headline.text;
    NSString *descreption=self.description.text;
    
    if([tittle isEqualToString:@""] ||[descreption isEqualToString:@""]){
        UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"Error" message:@"Please Fillup all fields" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        
        return;
    }
    
    NSDictionary *params = @{@"token": @"ad76fdf3458003fffcf279aa02fa75d0a5eb1256",
                             @"product_id": self.productID,
                             @"rating":[NSNumber numberWithFloat:self.starRater.rating],
                             @"title":tittle,
                             @"detail":descreption};
    

    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSString *str=[NSString stringWithFormat:@"%@/rest.php?method=prod_review&application_code=%@",[Data getBaseUrl],[Data getAppCode]];
    
    NSLog(@"%@",str);
    
    [manager POST:str parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic1=(NSDictionary *)responseObject;
        
        
        [loading StopAnimating];
        loading.hidden=YES;
        
        if([[dic1 objectForKey:@"success"] isEqualToString:@"ok"]){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Success"
                                                                message:@"Your review is posted."
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
            [alertView show];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        NSLog(@"JSON: %@", responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [loading StopAnimating];
        loading.hidden=YES;
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];

        NSLog(@"Error: %@", error);
    }];

    loading.hidden=NO;
    [loading StartAnimating];
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
