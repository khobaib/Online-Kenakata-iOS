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
    NSMutableDictionary *dic = [[dic1 objectForKey:@"success"]objectForKey:@"user"];
    
    currency=[dic objectForKey:@"currency"];
    branchID=@"0";
    paymentID=@"0";
    branches=[dic objectForKey:@"branches"];
    paymentMethodList=[dic objectForKey:@"payment_methods"];
    [self setValueOntop];

    [self initPickerView];
    [self initPaymentMethod];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Required"
                                                        message:@"Please provide all the following information and double check your information for accuracy."
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
    [alertView show];
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
    if(pickerView.tag==1){
        return branches.count;

    }
    
    return paymentMethodList.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if(pickerView.tag==1){
        return [[branches objectAtIndex:row]objectForKey:@"branch_address"];
        
    }

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
    
    
    NSMutableDictionary *customer=[[NSMutableDictionary alloc]init];
    
    [customer setObject:name forKey:@"customer_name"];
    [customer setObject:email forKey:@"customer_email"];
    [customer setObject:phone forKey:@"customer_phone"];
    [customer setObject:@"" forKey:@"formatted_address"];
    [customer setObject:@"1" forKey:@"delivery_method"];
    [customer setObject:branchID forKey:@"branch_id"];
    NSMutableArray *arr=[self productData];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{@"customer": customer,
                             @"options": arr,
                             @"remark":comment,
                             @"amount_paid":@"0",
                             @"payment_method":paymentID,
                             @"delivery_charges":@"0",
                             @"sub_total":self.subtotal.text,
                             @"transaction_id":@"0"};
    
    
 //   NSLog(@"%@",params);
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];

    NSString *str=[NSString stringWithFormat:@"%@/rest.php?method=add_order_3&application_code=%@",[Data getBaseUrl],[Data getAppCode]];
    
    [manager POST:str parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic=(NSDictionary *)responseObject;
        if([[dic objectForKey:@"ok"] isEqualToString:@"success"]){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Success"
                                                                message:@"Please check your mail for details."
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
            [alertView show];

            if ([DatabaseHandeler deletAll]) {
                NSLog(@"clear");
            }
        }
        NSLog(@"JSON: %@", responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    
}
-(NSMutableArray *)productData{
    NSMutableArray *arraylist=[[NSMutableArray alloc]init];
 
    for (int i=0; i<self.productList.count; i++) {
        Product *product=[self.productList objectAtIndex:i];
        
        NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
        [dic setObject:product.ID forKey:@"product_id"];
        [dic setObject:product.QUANTITY forKey:@"quantity"];
        [dic setObject:[NSString stringWithFormat:@"%d",i] forKey:@"record_id"];
        
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
        
        [dic setObject:qus forKey:@"special_question"];
        
        [arraylist addObject:dic];
        
        
    
    }
    
    return arraylist;
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

-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
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
