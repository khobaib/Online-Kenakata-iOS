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
    

    [self get_categories_by_parent_cateogory_id];
    
    [self initTagPicker];
    [self initMarchantPicker];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

    }else{
        return tagList.count;
    }
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    
    if(pickerView.tag==1){
        return [[marchentList objectAtIndex:row]objectForKey:@"user_name"];
        
    }else{
        return [[tagList objectAtIndex:row]objectForKey:@"name"];
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
    
    if([self.lowestprice.text isEqualToString:@""]){
        filterParams[@"low"]=@"-1";
    }else{
        filterParams[@"low"]=self.lowestprice.text;
    }
    
    if([self.heighPrice.text isEqualToString:@""]){
        filterParams[@"heigh"]=@"-1";
    }else{
        filterParams[@"heigh"]=self.heighPrice.text;
    }
    
    
    
    FilterdProductsViewController *vc=[segue destinationViewController];
    vc.params=filterParams;
}


@end
