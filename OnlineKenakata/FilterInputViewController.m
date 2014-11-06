//
//  FilterInputViewController.m
//  kenakata
//
//  Created by MC MINI on 10/20/14.
//  Copyright (c) 2014 OnlineKenakata. All rights reserved.
//

#import "FilterInputViewController.h"
#import "AFNetworking.h"
#import "Data.h"
#import "MBProgressHUD.h"
#import "FilterdProductsViewController.h"

@interface FilterInputViewController ()

@end

@implementation FilterInputViewController

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
    
    marchentList=[[NSArray alloc]init];
    tagList=[[NSArray alloc]init];
    marchentList=[[NSUserDefaults standardUserDefaults]objectForKey:@"marchent_data"];
    filterParams=[[NSMutableDictionary alloc]init];
    priceList=[self dataforPrice];

    
    [self get_categories_by_parent_cateogory_id];
    
    [self initTagPicker];
    [self initMarchantPicker];
    [self initPricePicker];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initPricePicker{
    pricePicker=[[UIPickerView alloc]init];
    pricePicker.delegate=self;
    pricePicker.dataSource=self;
    pricePicker.showsSelectionIndicator=YES;
    pricePicker.tag=3;
    UIToolbar *accessoryView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onPriceSelection)];
    [accessoryView setItems:[NSArray arrayWithObject:doneButton]];
    self.priceField.inputView=pricePicker;
    self.priceField.inputAccessoryView=accessoryView;
}


-(void)initTagPicker{
    tagPicker = [[UIPickerView alloc] init];
    tagPicker.delegate = self;
    tagPicker.dataSource = self;
    tagPicker.showsSelectionIndicator = YES;
    tagPicker.tag=2;
    
    UIToolbar *accessoryView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onTagSelection)];
    [accessoryView setItems:[NSArray arrayWithObject:doneButton]];
    
    self.tag.inputView = tagPicker;
    self.tag.inputAccessoryView = accessoryView;

}

-(void)initMarchantPicker{
    marchentPicker = [[UIPickerView alloc] init];
    marchentPicker.delegate = self;
    marchentPicker.dataSource = self;
    marchentPicker.showsSelectionIndicator = YES;
    marchentPicker.tag=1;
    
    UIToolbar *accessoryView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onMarchentSelection)];
    [accessoryView setItems:[NSArray arrayWithObject:doneButton]];
    
    self.marchent.inputView = marchentPicker;
    self.marchent.inputAccessoryView = accessoryView;
    
}

-(void)onTagSelection{
    NSInteger row = [tagPicker selectedRowInComponent:0];
    
    self.tag.text =[[tagList objectAtIndex:row]objectForKey:@"name"]; //[self.citys objectAtIndex:row];
    [self.tag resignFirstResponder];
    filterParams[@"tag"]=[[tagList objectAtIndex:row]objectForKey:@"id"];
}
-(void)onMarchentSelection{
    NSInteger row = [marchentPicker selectedRowInComponent:0];
    
    self.marchent.text =[[marchentList objectAtIndex:row]objectForKey:@"user_name"]; //[self.citys objectAtIndex:row];
    [self.marchent resignFirstResponder];
    filterParams[@"marchent"]=[[marchentList objectAtIndex:row]objectForKey:@"user_id"];
}
-(void)onPriceSelection{
    NSInteger row=[pricePicker selectedRowInComponent:0];
    self.priceField.text=[[priceList objectAtIndex:row]objectForKey:@"title"];
    filterParams[@"heigh"]=[[priceList objectAtIndex:row]objectForKey:@"heigh"];
    filterParams[@"low"]=[[priceList objectAtIndex:row]objectForKey:@"low"];
    
    [self.priceField resignFirstResponder];
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 1;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}
// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if(pickerView.tag==1){
        return marchentList.count;

    }else if(pickerView.tag==2){
        return tagList.count;
    }else{
        return priceList.count;
    }
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    
    if(pickerView.tag==1){
        return [[marchentList objectAtIndex:row]objectForKey:@"user_name"];
        
    }else if(pickerView.tag==2){
        return [[tagList objectAtIndex:row]objectForKey:@"name"];
    }else{
        return [[priceList objectAtIndex:row]objectForKey:@"title"];
    }
    
}



-(void)get_categories_by_parent_cateogory_id{
    
    NSString *string = [NSString stringWithFormat:@"%@/rest_kenakata.php?method=get_all_tags&application_code=%@",[Data getBaseUrl],[Data getAppCode]];
    
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [self parseTaglist:responseObject];
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        

        [MBProgressHUD hideHUDForView:self.view animated:YES];

       
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error catagory List"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
    }];
    
    
   
    [operation start];
    
    
    
}

-(void)parseTaglist:(id)respons{
    NSDictionary *dic=(NSDictionary *)respons;
    
    tagList=[[dic objectForKey:@"success"]objectForKey:@"tags"];
    

}

-(NSMutableArray *)dataforPrice{
    NSMutableArray *aray=[[NSMutableArray alloc]init];
    
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
    
    dic[@"title"]=@"Below 250TK";
    dic[@"low"]=@"0";
    dic[@"heigh"]=@"250";
    
    NSMutableDictionary *dic1=[[NSMutableDictionary alloc]init];
    
    dic1[@"title"]=@"TK 251-500";
    dic1[@"low"]=@"251";
    dic1[@"heigh"]=@"500";
    
    NSMutableDictionary *dic2=[[NSMutableDictionary alloc]init];
    
    dic2[@"title"]=@"TK 501-1000";
    dic2[@"low"]=@"501";
    dic2[@"heigh"]=@"1000";
    
    NSMutableDictionary *dic3=[[NSMutableDictionary alloc]init];
    
    dic3[@"title"]=@"TK 1001-2000";
    dic3[@"low"]=@"1001";
    dic3[@"heigh"]=@"2000";
    
    NSMutableDictionary *dic4=[[NSMutableDictionary alloc]init];
    
    dic4[@"title"]=@"Tk 2000+";
    dic4[@"low"]=@"2000";
    dic4[@"heigh"]=@"-1";
    
    [aray addObject:dic];
    [aray addObject:dic1];
    [aray addObject:dic2];
    [aray addObject:dic3];
    [aray addObject:dic4];
    
    return aray;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if(filterParams[@"tag"]==nil){
        filterParams[@"tag"]=@"-1";
    }
    if(filterParams[@"marchent"]==nil){
        filterParams[@"marchent"]=@"-1";
    }
    
    if( filterParams[@"low"]==nil){
        filterParams[@"low"]=@"-1";
    }
    
    if(filterParams[@"heigh"]==nil){
        filterParams[@"heigh"]=@"-1";
    }
    if(self.isNew.on){
        filterParams[@"is_new"]=@"1";
    }else{
        filterParams[@"is_new"]=@"0";
    }
    
    if(self.isDiscount.on){
        filterParams[@"is_discount"]=@"1";
    }else{
        filterParams[@"is_discount"]=@"0";
    }
    
    FilterdProductsViewController *vc=[segue destinationViewController];
    vc.params=filterParams;
}


@end
