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
#import "Marchent.h"
#import "MBProgressHUD.h"
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
    
    NSString *token = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    if(token!=nil){
     
        [self initFieldsForLoggedIn];
    }
    
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

-(void)initFieldsForLoggedIn{
    self.nameFild.text=[[NSUserDefaults standardUserDefaults]objectForKey:@"name"];
    self.emailFild.text=[[NSUserDefaults standardUserDefaults]objectForKey:@"email"];
    self.phoneFild.text=[[NSUserDefaults standardUserDefaults]objectForKey:@"phone"];
    self.address.text=[[NSUserDefaults standardUserDefaults]objectForKey:@"address"];
    

    self.nameFild.enabled=NO;
    self.emailFild.enabled=NO;
    self.phoneFild.enabled=NO;
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
   
    self.subtotalLable.text=[NSString stringWithFormat:@"Sub total (%luitems):",(unsigned long)[Data getProdictCount]];
    
    self.total.text=[NSString stringWithFormat:@"%@%d",currency,[Data getSubTotal]+[Data getDeleveryCharge]];
    self.subtotal.text=[NSString stringWithFormat:@"%@%d",currency,[Data getSubTotal]];
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
    
    if(![self validatePhoneNumber:self.phoneFild.text]){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"ERROR"
                                                            message:@"Please Enter a valid phone number."
                                                           delegate:nil
                                                  cancelButtonTitle:@"Calcle"
                                                  otherButtonTitles:nil];
        [alertView show];
        return;

    }
    
    NSString *token=[[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
    NSDictionary *params;
  
    [self setMethod];
    
    
    if(token!=nil){
        
        [[NSUserDefaults standardUserDefaults]setObject:address forKey:@"address"];
        
        NSMutableDictionary *customer=[[NSMutableDictionary alloc]init];
        
        [customer setObject:address forKey:@"formatted_address"];
        [customer setObject:@"2" forKey:@"delivery_method"];
        [customer setObject:@"-1" forKey:@"branch_id"];
        NSMutableArray *arr=[self prepDataForRequest];
        
                                params = @{@"token":token,
                                 @"customer": customer,
                                 @"orders": arr,
                                 @"remark":comment,
                                 @"amount_paid":@"0",
                                 @"payment_method":paymentID,
                                 @"delivery_charges":@"0",
                                 @"sub_total":self.subtotal.text,
                                 @"transaction_id":@"0"};

        
    }else{
        
       
        
       
        NSMutableDictionary *customer=[[NSMutableDictionary alloc]init];
        
        [customer setObject:name forKey:@"customer_name"];
        [customer setObject:email forKey:@"customer_email"];
        [customer setObject:phone forKey:@"customer_phone"];
        [customer setObject:address forKey:@"formatted_address"];
        [customer setObject:@"2" forKey:@"delivery_method"];
        [customer setObject:@"-1" forKey:@"branch_id"];
        NSMutableArray *arr=[self prepDataForRequest];
        
                                params = @{@"token":@"",
                                 @"customer": customer,
                                 @"orders": arr,
                                 @"remark":comment,
                                 @"amount_paid":@"0",
                                 @"payment_method":paymentID,
                                 @"delivery_charges":@"0",
                                 @"sub_total":self.subtotal.text,
                                 @"transaction_id":@"0"};

    }
    
    
 
    
   
    if([paymentMethod isEqualToString:@"bKash"]){
        
        bKashViewController *bvc=[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"bKash"];
        bvc.params=[params mutableCopy];
        [self.navigationController pushViewController:bvc animated:YES];
        
    }else{
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        NSString *str=[NSString stringWithFormat:@"%@/rest_kenakata.php?method=add_order_4_1&application_code=%@",[Data getBaseUrl],[Data getAppCode]];
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [manager POST:str parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *dic1=(NSDictionary *)responseObject;
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSLog(@"%@",dic1);
            if([[dic1 objectForKey:@"success"] isEqualToString:@"ok"]){
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
                return ;

            }
       NSLog(@"JSON: %@", responseObject);
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:@"Sorry there might be some problem.Please Try again later."
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
            [alertView show];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:@"Sorry there might be some problem.Please Try again later."
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
            [alertView show];
            
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
-(NSMutableDictionary *)marchentProductData:(NSMutableArray *)productArr{
    NSMutableArray *arraylist=[[NSMutableArray alloc]init];
    NSMutableDictionary *data=[[NSMutableDictionary alloc]init];
    int marchentTotal=0;
    for (int i=0; i<productArr.count; i++) {
        Product *product=[productArr objectAtIndex:i];
        
        marchentTotal+=([product.PRICE intValue] *[product.QUANTITY intValue]);
        
        NSMutableDictionary *dic1=[[NSMutableDictionary alloc]init];
        [dic1 setObject:product.ID forKey:@"product_id"];
        [dic1 setObject:product.QUANTITY forKey:@"quantity"];
        [dic1 setObject:[NSString stringWithFormat:@"%d",i] forKey:@"record_id"];
        
        NSString *TF;
        NSString *ans;
        if([product.varientID isEqualToString:@""]){
            TF=@"false";
            ans=@"0";
        }else{
            TF=@"true";
            ans=product.varientID;
        }
        NSMutableDictionary *dic2=[[NSMutableDictionary alloc]init];
        [dic2 setObject:TF forKey:@"is_special_question"];
        [dic2 setObject:ans forKey:@"special_answer_id"];
        [dic1 setObject:dic2 forKey:@"special_question"];
        
        NSArray *arr=[product.attributs componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@": "]];
        
        // NSLog(@"%@",arr);
        NSString *str=@"";
        for(int i=0;i<arr.count-1;i=i+2){
            str=[str stringByAppendingPathComponent:[arr objectAtIndex:i]];
        }

        
        [arraylist addObject:dic1];
        
        
        
    }
    
    [data setObject:[NSNumber numberWithInt:marchentTotal] forKey:@"merchant_total" ];
    [data setObject:arraylist forKey:@"products"];
    
    
    return data;
}


-(NSMutableArray*)prepDataForRequest{
    NSMutableArray *arr=[[NSMutableArray alloc]init];
    
    NSArray *valArr=[[Data getMarchentData] allValues];
    
    
    for(int i=0;i<valArr.count;i++){
        Marchent *marchent=[valArr objectAtIndex:i];
        
        NSMutableDictionary *marchentDictionary=[self marchentProductData:marchent.productArray];
        [marchentDictionary setObject:marchent.marchentId forKey:@"merchant_id"];
        [marchentDictionary setObject:marchent.deleveryCharge forKey:@"delivery_charge"];
       
        [arr addObject:marchentDictionary];
    }
    
    return arr;
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

@end
