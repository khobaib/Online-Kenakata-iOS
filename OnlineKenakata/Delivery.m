//
//  Delivery.m
//  OnlineKenakata
//
//  Created by Rabby Alam on 7/20/14.
//  Copyright (c) 2014 OnlineKenakata. All rights reserved.
//

#import "Delivery.h"
#import "Product.h"
#import "AFNetworking.h"
#import "Data.h"
#import "DatabaseHandeler.h"
#import "TextStyling.h"
#import "bKashViewController.h"
@interface Delivery ()

@end

@implementation Delivery

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
    
    paymentMethodList=[dic objectForKey:@"payment_methods"];
    [self setValueOntop];
    
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


-(void)initFields{
    self.nameFild.text=self.method.name;
    self.emailFild.text=self.method.email;
    self.phoneFild.text=self.method.phone;
    self.commentFild.text=self.method.comment;
    self.address.text=self.method.address;
    //paymentID=[NSString stringWithFormat:@"%d",self.method.paymentMethod];
    
   // self.paymentMethod.text=[self getPaymentMethodName:self.method.paymentMethod];
    
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

-(void)setValueOntop{
   
    int charge=[[dic objectForKey:@"delivery_charge"]intValue];
    self.deleveryChargeLable.text=[NSString stringWithFormat:@"%@ %@",currency,[dic objectForKey:@"delivery_charge"]];
    self.subtotalLable.text=[NSString stringWithFormat:@"Sub total (%luitems):",(unsigned long)self.productList.count];
    int total=0;
    for (int i=0; i<self.productList.count; i++) {
        Product *product=[self.productList objectAtIndex:i];
        
        total+= [product.PRICE intValue]*[product.QUANTITY intValue];
        
        
        
    }
    
    self.total.text=[NSString stringWithFormat:@"%@%d",currency,total+charge];
    self.subtotal.text=[NSString stringWithFormat:@"%@%d",currency,total];
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



-(void) onPaymentMethodSelection{
    
    NSInteger row = [paymentMethodPicker selectedRowInComponent:0];
    
    self.paymentMethod.text =[[paymentMethodList objectAtIndex:row]objectForKey:@"name"]; //[self.citys objectAtIndex:row];
    [self.paymentMethod resignFirstResponder];
    paymentID=[[paymentMethodList objectAtIndex:row]objectForKey:@"id"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
   
    return paymentMethodList.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
   
    return [[paymentMethodList objectAtIndex:row]objectForKey:@"name"];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}


-(IBAction)Payment:(id)sender{
    
    NSString *name=self.nameFild.text;
    NSString *phone=self.phoneFild.text;
    NSString *email=self.emailFild.text;
    NSString *comment=self.commentFild.text;
    NSString *address=self.address.text;
    NSString *paymentMethod=self.paymentMethod.text;
    if([name isEqualToString:@""]||[phone isEqualToString:@""]||[email isEqualToString:@""]||[comment isEqualToString:@""]||[address isEqualToString:@""]||[paymentMethod isEqualToString:@""])
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
  /*
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
        
    }*/
    

    NSMutableDictionary *customer=[[NSMutableDictionary alloc]init];
    
    [customer setObject:name forKey:@"customer_name"];
    [customer setObject:email forKey:@"customer_email"];
    [customer setObject:phone forKey:@"customer_phone"];
    [customer setObject:address forKey:@"formatted_address"];
    [customer setObject:@"2" forKey:@"delivery_method"];
    [customer setObject:@"" forKey:@"branch_id"];
    NSMutableArray *arr=[self productData];
    
    NSDictionary *params = @{@"customer": customer,
                             @"options": arr,
                             @"remark":comment,
                             @"amount_paid":@"0",
                             @"payment_method":paymentID,
                             @"delivery_charges":@"0",
                             @"sub_total":self.subtotal.text,
                             @"transaction_id":@"0"};
    
    
    //   NSLog(@"%@",params);
    
    
    if([paymentMethod isEqualToString:@"bKash"]){
        
        bKashViewController *bvc=[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"bKash"];
        bvc.params=[params mutableCopy];
        [self.navigationController pushViewController:bvc animated:YES];
        
    }else{
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        NSString *str=[NSString stringWithFormat:@"%@/rest.php?method=add_order_3&application_code=%@",[Data getBaseUrl],[Data getAppCode]];
        
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
    
    
}


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


-(void)setMethod{
    
    DeleveryMethod *obj=[[DeleveryMethod alloc]init];
    if(self.method==nil){
        [obj initDeleveryMethod:0 name:self.nameFild.text email:self.emailFild.text phone:self.phoneFild.text branchName:@"" address:self.address.text comment:self.commentFild.text payment:[paymentID intValue] type:2];
        
    }else{
        [obj initDeleveryMethod:self.method._id name:self.nameFild.text email:self.emailFild.text phone:self.phoneFild.text branchName:@"" address:self.address.text comment:self.commentFild.text payment:[paymentID intValue] type:2];
        
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

-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
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
        f.origin.y = -20.0f ;
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

@end
