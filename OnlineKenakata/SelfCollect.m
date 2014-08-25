//
//  SelfCollect.m
//  OnlineKenakata
//
//  Created by Rabby Alam on 7/20/14.
//  Copyright (c) 2014 OnlineKenakata. All rights reserved.
//

#import "SelfCollect.h"
#import "Product.h"
#import "AFNetworking.h"
#import "DatabaseHandeler.h"
#import "Data.h"
#import "DeleveryMethod.h"
#import "TextStyling.h"
#import "bKashViewController.h"




// Set the environment:
// - For live charges, use PayPalEnvironmentProduction (default).
// - To use the PayPal sandbox, use PayPalEnvironmentSandbox.
// - For testing, use PayPalEnvironmentNoNetwork.
#define kPayPalEnvironment PayPalEnvironmentSandbox
@interface SelfCollect ()

@end

@implementation SelfCollect

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

    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    NSMutableDictionary *dic1=[NSKeyedUnarchiver unarchiveObjectWithData:[ud objectForKey:@"get_user_data"]];
   dic = [[dic1 objectForKey:@"success"]objectForKey:@"user"];
    
    currency=[dic objectForKey:@"currency"];
    branchID=@"0";
    paymentID=@"0";
    branches=[dic objectForKey:@"branches"];
    paymentMethodList=[dic objectForKey:@"payment_methods"];
    [self setValueOntop];

    [self initPickerView];
    [self initPaymentMethod];
    
    if(self.method!=nil){
        [self initFields];
    }
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Required"
                                                        message:@"Please provide all the following information and double check your information for accuracy."
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
    [alertView show];
    [self.payment setBackgroundColor:[TextStyling appColor]];
    // Do any additional setup after loading the view.
}

-(void)setValueOntop{
    self.subtotalLable.text=[NSString stringWithFormat:@"Sub total (%luitems):",(unsigned long)self.productList.count];
    int total=0;
    for (int i=0; i<self.productList.count; i++) {
        Product *product=[self.productList objectAtIndex:i];
        
        total+= [product.PRICE intValue]*[product.QUANTITY intValue];
        
        
        
    }
    
    self.total.text=[NSString stringWithFormat:@"%@%d",currency,total];
    self.subtotal.text=[NSString stringWithFormat:@"%@%d",currency,total];
}

-(void)initFields{
    self.nameFild.text=self.method.name;
    self.emailFild.text=self.method.email;
    self.phoneFild.text=self.method.phone;
    self.commentFild.text=self.method.comment;
    self.textFild.text=[self getBranchName:self.method.branchName];
 //   paymentID=[NSString stringWithFormat:@"%d",self.method.paymentMethod];
    branchID=self.method.branchName;
   // self.paymentMethod.text=[self getPaymentMethodName:self.method.paymentMethod];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -PcikerView methods for branch and payment methods

-(NSString *)getBranchName:(NSString *)LbranchID{
    NSString *str=@"";
    
    for (int i=0; i<branches.count; i++) {
        
        NSString *name= [[branches objectAtIndex:i]objectForKey:@"branch_id"];
        if([name isEqualToString:LbranchID]){
            str=[[branches objectAtIndex:i]objectForKey:@"branch_address"];
        
            break;
        }
    }
    
    return str;
}

-(NSString *)getPaymentMethodName:(int)methodID{
    NSString *str=@"";
    for (int i=0; paymentMethodList.count; i++) {
        int _id=[[[paymentMethodList objectAtIndex:i]objectForKey:@"id"]intValue];
        if(_id==methodID){
            str=[[paymentMethodList objectAtIndex:i]objectForKey:@"name"];
            break;
        }
    }
    return str;
}

-(void)initPickerView{
    namePicker = [[UIPickerView alloc] init];
    namePicker.delegate = self;
    namePicker.dataSource = self;
    namePicker.showsSelectionIndicator = YES;
    namePicker.tag=1;
    
    UIToolbar *accessoryView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];

    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onNameSelection)];
    [accessoryView setItems:[NSArray arrayWithObject:doneButton]];
    
    self.textFild.inputView = namePicker;
    self.textFild.inputAccessoryView = accessoryView;
}

-(void)initPaymentMethod{
    paymentMethodPicker = [[UIPickerView alloc] init];
    paymentMethodPicker.delegate = self;
    paymentMethodPicker.dataSource = self;
    paymentMethodPicker.showsSelectionIndicator = YES;
    paymentMethodPicker.tag=2;
    
    UIToolbar *accessoryView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onPaymentMethodSelection)];
    [accessoryView setItems:[NSArray arrayWithObject:doneButton]];
    
    self.paymentMethod.inputView = paymentMethodPicker;
    self.paymentMethod.inputAccessoryView = accessoryView;

}

- (void) onNameSelection{
    NSInteger row = [namePicker selectedRowInComponent:0];
    
    self.textFild.text =[[branches objectAtIndex:row]objectForKey:@"branch_address"]; //[self.citys objectAtIndex:row];
    [self.textFild resignFirstResponder];
    
    branchID=[[branches objectAtIndex:row]objectForKey:@"branch_id"];
}
-(void) onPaymentMethodSelection{
 
    NSInteger row = [paymentMethodPicker selectedRowInComponent:0];
    
    if(row==paymentMethodList.count+1){
         self.paymentMethod.text=@"Paypal";
        paymentID=@"69";
        [self.paymentMethod resignFirstResponder];

        return ;
    }else if(row==paymentMethodList.count){
         self.paymentMethod.text=@"Stripe";
        paymentID=@"169";
        [self.paymentMethod resignFirstResponder];
        return ;
    }
    self.paymentMethod.text =[[paymentMethodList objectAtIndex:row]objectForKey:@"name"]; //[self.citys objectAtIndex:row];
    [self.paymentMethod resignFirstResponder];
    
    paymentID=[[paymentMethodList objectAtIndex:row]objectForKey:@"id"];

}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if(pickerView.tag==1){
        return branches.count;

    }
    
    return paymentMethodList.count+2;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if(pickerView.tag==1){
       
        return [[branches objectAtIndex:row]objectForKey:@"branch_address"];
        
    }

   
    if(row==paymentMethodList.count+1){
        return @"Paypal";
    }else if(row==paymentMethodList.count){
        return @"Stripe";
    }
    
    return [[paymentMethodList objectAtIndex:row]objectForKey:@"name"];

}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}

#pragma mark -PaymentFunction

-(IBAction)Payment:(id)sender{
 
    NSString *name=self.nameFild.text;
    NSString *phone=self.phoneFild.text;
    NSString *email=self.emailFild.text;
    NSString *comment=self.commentFild.text;
    NSString *branch=self.textFild.text;
    NSString *paymentMethod=self.paymentMethod.text;
    if([name isEqualToString:@""]||[phone isEqualToString:@""]||[email isEqualToString:@""]||[comment isEqualToString:@""]||[branch isEqualToString:@""]||[paymentMethod isEqualToString:@""])
    {
     
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Please fill up all fields."
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
        return;

    }
    
    if(![self NSStringIsValidEmail:email]){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Please Enter A valid email Address."
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
        return;

    }
    
    [self setMethod];
    
    if([self isfood]){
        NSLog(@"food");
        if(![self isInsideOpeningTime]){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:@"Currently the store is closed.Do you want to set an alert for letter?"
                                                               delegate:self
                                                      cancelButtonTitle:@"Calcle"
                                                      otherButtonTitles:@"Set Alert",nil];
            [alertView show];
            return;
            //NSLog(@"inside");
        }
        
    }
    
    NSLog(@"open store");
    
    
    if(![self validatePhoneNumber:self.phoneFild.text]){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"ERROR"
                                                            message:@"Please Enter a valid phone number."
                                                           delegate:nil
                                                  cancelButtonTitle:@"Calcle"
                                                  otherButtonTitles:nil];
        [alertView show];
        return;
        
    }
    NSMutableDictionary *customer=[[NSMutableDictionary alloc]init];
    
    [customer setObject:name forKey:@"customer_name"];
    [customer setObject:email forKey:@"customer_email"];
    [customer setObject:phone forKey:@"customer_phone"];
    [customer setObject:@"" forKey:@"formatted_address"];
    [customer setObject:@"1" forKey:@"delivery_method"];
    [customer setObject:branchID forKey:@"branch_id"];
    NSMutableArray *arr=[self productData];
    
    NSDictionary *params = @{@"token":@"",
                             @"customer": customer,
                             @"options": arr,
                             @"remark":comment,
                             @"amount_paid":@"0",
                             @"payment_method":paymentID,
                             @"delivery_charges":@"0",
                             @"sub_total":self.subtotal.text,
                             @"transaction_id":@"0"};
    
    
    
    
    if([paymentMethod isEqualToString:@"bKash"]){
     
        bKashViewController *bvc=[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"bKash"];
        bvc.params=[params mutableCopy];
        [self.navigationController pushViewController:bvc animated:YES];
        
    }else if([paymentMethod isEqualToString:@"Paypal"]){
        
        [self configWithVC];
        [self payment:arr];
        
    } else if ([paymentMethod isEqualToString:@"Stripe"]){
        [self stpPayment];
    }
    
    
    else{
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        NSString *str=[NSString stringWithFormat:@"%@/rest.php?method=add_order_4&application_code=%@",[Data getBaseUrl],[Data getAppCode]];
        
        [manager POST:str parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
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

    
 //   NSLog(@"%@",params);
    
}


#pragma mark -FoorStoreHandle
-(BOOL)isfood{
    NSString *food=[dic objectForKey:@"is_food"];
    return [food isEqualToString:@"1"];

}
- (NSDate *)dateToGMT:(NSDate *)sourceDate {
    NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:sourceDate];
    NSDate* destinationDate = [[NSDate alloc] initWithTimeInterval:destinationGMTOffset sinceDate:sourceDate];
    return destinationDate;
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(alertView.tag==2 && buttonIndex==1){
        
        [self.stripeView createToken:^(STPToken *token, NSError *error) {
            if (error) {
                
                NSLog(@"%@",[error description]);
                // Handle error
                [self handleError:error];
            } else {
                
                NSLog(@"%@",token);
                // Send off token to your server
                // [self handleToken:token];
            }
        }];

        
        return;
    }
    if(alertView.tag==1 && buttonIndex==1){

        NSDateFormatter *dateFormatter;
        [dateFormatter setDateFormat:@"hh:mm"];
        NSLog(@"%@",[self dateToGMT:alermTime]);
        
        return;
    }
    if(buttonIndex==1){
        NSLog(@"settings");
        
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init] ;
        [dateFormatter setDateFormat:@"HH:mm"];
        NSDate *from = [dateFormatter dateFromString:[dic objectForKey:@"opening_time"]];
        
        NSDate *to =[dateFormatter dateFromString:[dic objectForKey:@"closing_time"]];
        
        NSDate *currentTime = [NSDate date];
        
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *componentsTo = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit |NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:to];
        
        NSDateComponents *componentsCurent=[calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit fromDate:currentTime];
        NSDateComponents *componentsFrom =[calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit |NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:from];
        
        [componentsFrom setYear:[componentsCurent year]];
        [componentsFrom setMonth:[componentsCurent month]];
        [componentsFrom setTimeZone:[calendar timeZone]];
        
        NSLog(@"to %ld  current %ld",(long)[componentsTo hour],(long)[componentsCurent hour]);
        if([componentsTo hour]<[componentsCurent hour]){
            [componentsFrom setDay:[componentsCurent day]+1];
            

            NSLog(@"more day");
        }else{
           
            [componentsFrom setDay:[componentsCurent day]];

        }
        alermTime=[calendar dateFromComponents:componentsFrom];

        NSLog(@"%@",componentsFrom);
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = alermTime;
        localNotification.alertBody = [NSString stringWithFormat:@"Alert Fired at %@", alermTime];
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
        /*
        UIDatePicker *datePicker;
        UIAlertView *setDate;
        
        //create the alertview
        setDate = [[UIAlertView alloc] initWithTitle:@"Set Alert Time:"
                                                  message:nil
                                                 delegate:self
                                        cancelButtonTitle:@"Cancel"
                                        otherButtonTitles:@"OK", nil];
        
        //create the datepicker
        
        [setDate setTag:1];
        datePicker = [[UIDatePicker alloc] init];
        [datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
        datePicker.date = [NSDate date];

        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init] ;
        [dateFormatter setDateFormat:@"HH:mm"];
        NSDate *from = [dateFormatter dateFromString:[dic objectForKey:@"opening_time"]];
        
        NSDate *to =[dateFormatter dateFromString:[dic objectForKey:@"closing_time"]];
        
        
      //  NSDate *currentTime = [NSDate date];
        [datePicker setMinimumDate:from];
        [datePicker setMaximumDate:to];
        datePicker.datePickerMode = UIDatePickerModeTime;

        [setDate setValue:datePicker forKey:@"accessoryView"];
        alermTime=datePicker.date;
       // [setDate show];*/
    
    }
}
- (void) dateChanged:(id)sender
{
  
    UIDatePicker *datePicker = (UIDatePicker *)sender;
    alermTime=datePicker.date;
}


-(BOOL)isInsideOpeningTime{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init] ;
    [dateFormatter setDateFormat:@"HH:mm"];
    NSDate *from = [dateFormatter dateFromString:[dic objectForKey:@"opening_time"]];
    
    NSDate *to =[dateFormatter dateFromString:[dic objectForKey:@"closing_time"]];
    
    NSDate *currentTime = [NSDate date];
    
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *componentsTo = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit |NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:to];
    
    NSDateComponents *componentsCurent=[calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit fromDate:currentTime];
    
    NSComparisonResult result=[from compare:to];

    if(result==NSOrderedDescending){
        [componentsTo setDay:[componentsCurent day]+1];

    }else{
        [componentsTo setDay:[componentsCurent day]];

    }
    [componentsTo setYear:[componentsCurent year]];
    [componentsTo setMonth:[componentsCurent month]];
    [componentsTo setTimeZone:[calendar timeZone]];
    
    
    NSDateComponents *componentsFrom =[calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit |NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:from];
    
    [componentsFrom setYear:[componentsCurent year]];
    [componentsFrom setMonth:[componentsCurent month]];
    [componentsFrom setDay:[componentsCurent day]];
    [componentsFrom setTimeZone:[calendar timeZone]];
    
    NSComparisonResult result1=[[calendar dateFromComponents:componentsFrom] compare:currentTime];
    NSComparisonResult result2=[[calendar dateFromComponents:componentsTo] compare:currentTime];
    
    
    return (result1==NSOrderedAscending && result2==NSOrderedDescending);
    
}

#pragma mark-prepare for payment
-(void)setMethod{
    
    DeleveryMethod *obj=[[DeleveryMethod alloc]init];
    if(self.method==nil){
        [obj initDeleveryMethod:0 name:self.nameFild.text email:self.emailFild.text phone:self.phoneFild.text branchName:branchID address:@"" comment:self.commentFild.text payment:[paymentID intValue] type:1];
        
    }else{
        [obj initDeleveryMethod:self.method._id name:self.nameFild.text email:self.emailFild.text phone:self.phoneFild.text branchName:branchID address:@"" comment:self.commentFild.text payment:[paymentID intValue] type:1];
        
    }
    
    [DatabaseHandeler insertDeleveryMethodData:obj];
}
-(NSMutableArray *)productData{
    NSMutableArray *arraylist=[[NSMutableArray alloc]init];
 
    for (int i=0; i<self.productList.count; i++) {
        Product *product=[self.productList objectAtIndex:i];
        
        NSMutableDictionary *dic1=[[NSMutableDictionary alloc]init];
        [dic1 setObject:product.ID forKey:@"product_id"];
        [dic1 setObject:product.QUANTITY forKey:@"quantity"];
        [dic1 setObject:[NSString stringWithFormat:@"%d",i] forKey:@"record_id"];
        
        NSMutableDictionary *qus=[[NSMutableDictionary alloc]init];
        NSString *TF;
        NSString *ans;
        if([product.SPECIAL_QUESTION_TEXT isEqualToString:@""]){
            TF=@"FALSE";
            ans=@"0";
        }else{
            TF=@"TRUE";
            ans=product.SPECIAL_ANS_ID;
        }
        
        [qus setObject:TF forKey:@"is_special_question"];
        [qus setObject:ans forKey:@"special_answer_id"];
        
        [dic1 setObject:qus forKey:@"special_question"];
        
        [arraylist addObject:dic1];
        
        
    
    }
    
    return arraylist;
}

#pragma mark - main use keyboard movements

- (void)viewWillAppear:(BOOL)animated {
     self.environment = kPayPalEnvironment;
     [PayPalMobile preconnectWithEnvironment:self.environment];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


- (void)keyboardWillShow:(NSNotification *)notification
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect f = self.view.frame;
        f.origin.y = -20.0f ; //set the -35.0f to your required value
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
#pragma mark - validation
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

-(void)checkAvailablity:(NSString *)str{
    
    NSString *string = [NSString stringWithFormat:@"%@/rest.php?method=get_products_by_productids&product_ids=%@&application_code=%@",[Data getBaseUrl],str,[Data getAppCode]];
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    //  NSLog(@"%@",string);
    // 2
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self checkStockNumber:responseObject];
        
        
        
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
    
    
    
}

-(void)checkStockNumber:(id)resposns{
    
}

// called when 'return' key pressed. return NO to ignore.

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Paypal Payment

-(void)configWithVC{
    _payPalConfig = [[PayPalConfiguration alloc] init];
    _payPalConfig.acceptCreditCards = YES;
    _payPalConfig.languageOrLocale = @"en";
    _payPalConfig.merchantName = @"Awesome Shirts, Inc.";
    _payPalConfig.merchantPrivacyPolicyURL = [NSURL URLWithString:@"http://online-kenakata.com/legal/terms.php"];
    _payPalConfig.merchantUserAgreementURL = [NSURL URLWithString:@"http://online-kenakata.com/legal/terms.php"];
    
    _payPalConfig.languageOrLocale = [NSLocale preferredLanguages][0];
    
    _payPalConfig.payPalShippingAddressOption = PayPalShippingAddressOptionPayPal;
    
    
   
    
    NSLog(@"PayPal iOS SDK version: %@", [PayPalMobile libraryVersion]);
    
  
    
}

-(void)payment:(NSArray *)products{
    PayPalItem *item1 = [PayPalItem itemWithName:@"Old jeans with holes"
                                    withQuantity:1
                                       withPrice:[NSDecimalNumber decimalNumberWithString:@"84.99"]
                                    withCurrency:@"USD"
                                         withSku:@"Hip-00037"];
    
    NSArray *items = @[item1];
    NSDecimalNumber *subtotal = [PayPalItem totalPriceForItems:items];
    
    // Optional: include payment details
    NSDecimalNumber *shipping = [[NSDecimalNumber alloc] initWithString:@"5.99"];
    NSDecimalNumber *tax = [[NSDecimalNumber alloc] initWithString:@"2.50"];
    PayPalPaymentDetails *paymentDetails = [PayPalPaymentDetails paymentDetailsWithSubtotal:subtotal
                                                                               withShipping:shipping
                                                                                    withTax:tax];
    
    NSDecimalNumber *total = [[subtotal decimalNumberByAdding:shipping] decimalNumberByAdding:tax];
    
    PayPalPayment *payment = [[PayPalPayment alloc] init];
    payment.amount = total;
    payment.currencyCode = @"USD";
    payment.shortDescription = @"Good";
    payment.items = nil;//items;  // if not including multiple items, then leave payment.items as nil
    payment.paymentDetails =paymentDetails; // if not including payment details, then leave payment.paymentDetails as nil
    
    if (!payment.processable) {
        // This particular payment will always be processable. If, for
        // example, the amount was negative or the shortDescription was
        // empty, this payment wouldn't be processable, and you'd want
        // to handle that here.
    }
    
    // Update payPalConfig re accepting credit cards.
    self.payPalConfig.acceptCreditCards = YES;
    PayPalPaymentViewController *paymentViewController = [[PayPalPaymentViewController alloc] initWithPayment:payment
                                                                                                configuration:self.payPalConfig
                                                                                                     delegate:self];
    [self presentViewController:paymentViewController animated:YES completion:nil];
    
}


- (void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController{
    NSLog(@"cancle");
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController
                 didCompletePayment:(PayPalPayment *)completedPayment{
    
    
    NSLog(@"payment %@",completedPayment.confirmation);
   
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - StripePayment

-(void)stpPayment{
    
    stripeAlertView=[[UIAlertView alloc]initWithTitle:@"Your cart information" message:@"" delegate:self cancelButtonTitle:@"Cancle" otherButtonTitles:@"Done", nil];
    self.stripeView = [[STPView alloc] initWithFrame:CGRectMake(0,0,290,55) andKey:@"pk_test_hlpADPUOWaxn6uN0aATgLivW"];
   
    stripeAlertView.tag=2;
    
   [stripeAlertView setValue: self.stripeView forKey:@"accessoryView"];
    [stripeAlertView show];
   

}


- (void)handleError:(NSError *)error
{
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", @"Error")
                                                      message:[error localizedDescription]
                                                     delegate:nil
                                            cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                            otherButtonTitles:nil];
    [message show];
}


@end
