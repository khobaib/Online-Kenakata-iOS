//
//  AddToCart.m
//  OnlineKenakata
//
//  Created by Rabby Alam on 7/17/14.
//  Copyright (c) 2014 OnlineKenakata. All rights reserved.
//

#import "AddToCart.h"
#import "UIImageView+WebCache.h"
#import "Product.h"
#import "DatabaseHandeler.h"
#import "AFNetworking.h"

@interface AddToCart ()

@end

@implementation AddToCart

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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    NSMutableDictionary *dic = [ud objectForKey:@"get_user_data"];
    
    currency=[[[dic objectForKey:@"success"]objectForKey:@"user"]objectForKey:@"currency"];
    
    

    specialAnsDic=[[NSMutableDictionary alloc]init];
    [self initLoading];

    [self setValueOnUI];

}

- (void)setValueOnUI
{
    self.name.text=[self.productData objectForKey:@"name"];
    
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dic=[[[ud objectForKey:@"get_user_data"]objectForKey:@"success"]objectForKey:@"user"];
    
    NSString *addToCartMEssage=[dic objectForKey:@"add_to_cart_message"];
    
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[addToCartMEssage dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];



    [self.details setAttributedText:attributedString];
  //  NSLog(@"%@",addToCartMEssage);
    
    NSString * imgurl = [[[self.productData objectForKey:@"images"] objectAtIndex:0]objectForKey:@"thumbnail_image_url"];

    [self.thumbnil setImageWithURL:[NSURL URLWithString:imgurl]
             placeholderImage:[UIImage imageNamed:@"placeholder.gif"]];
    
    int tag = (int)[[self.productData objectForKey:@"tag"] integerValue];
    
    NSString *spclqus=[self.productData objectForKey:@"special_question"];
    if([spclqus isEqualToString:@""]){
        self.specialQuestionView.hidden=YES;
        
       
        flag=true;
        
        
        NSString *string = [NSString stringWithFormat:@"http://online-kenakata.com/mobile_api/rest.php?method=check_stock&product_id=%@&is_special_question=false&special_answer_id=&application_code=1000",[self.productData objectForKey:@"product_id"]];
        
        [self checkQuantity:string];

    }else{
        
        self.quantitybtn.enabled=NO;
        self.specialQuestionLable.text=spclqus;
        
        pickerData=[self.productData objectForKey:@"special_answers"];
        flag=false;
    }
    if(tag==1){
        self.oldPrice.text=[NSString stringWithFormat:@"%@ %@",currency,[self.productData objectForKey:@"price"]];
        self.tooping.image=[UIImage imageNamed:@"tag_new.png"];

    }else if (tag==2){
        self.tooping.image=[UIImage imageNamed:@"tag_sale.png"];

        NSMutableAttributedString *attString=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ %@",currency,[self.productData objectForKey:@"old_price"]]];
        
        [attString addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInt:1] range:NSMakeRange(0,[attString length])];
        self.oldPrice.attributedText = attString;
        
        
        self.priceNew.text=[NSString stringWithFormat:@"%@ %@",currency,[self.productData objectForKey:@"price"]];
        
    }else{
        self.oldPrice.text=[NSString stringWithFormat:@"%@ %@",currency,[self.productData objectForKey:@"price"]];
        
    }
    
        
    int available =[[self.productData objectForKey:@"general_available_quantity"]intValue];
    if(available>0){
        self.itemCode.text=[self.productData objectForKey:@"sku"];
        
    }else{
        self.itemCode.hidden=YES;
        //self.itemCodeLable.hidden=YES;
    }
}



-(void)checkQuantity:(NSString *)string{
    
  //
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    // NSLog(@"%@",string);
    // 2
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self parsProductList:responseObject];
        
        
        
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

-(void)parsProductList:(id) respons{
    NSMutableDictionary *dic=(NSMutableDictionary *)respons;
    quantity=[[dic objectForKey:@"available_quantity"]intValue];
    [loading StopAnimating];
    loading.hidden=YES;
    
}
-(void)initLoading{
    CGFloat x= self.view.frame.size.width/2-65;
    CGFloat y =(self.view.frame.size.height-self.navigationController.navigationBar.frame.size.height-self.tabBarController.tabBar.frame.size.height)/2-25;
    
    loading=[[LoadingView alloc]initWithFrame:CGRectMake(x, y, 130, 50)];
    loading.hidden=YES;
    [self.view addSubview:loading];
}

-(IBAction)quantity:(id)sender{
    if(!flag){
        return;
    }
    RMPickerViewController *pickerVC = [RMPickerViewController pickerController];
    pickerVC.delegate = self;
    
    [pickerVC show];
    
}

-(IBAction)spclQus:(id)sender{
    flag=false;
    RMPickerViewController *pickerVC = [RMPickerViewController pickerController];
    pickerVC.delegate = self;
    
    [pickerVC show];

}

-(IBAction)addToMyCart:(id)sender{
 
    Product* product=[[Product alloc]init];
    
    if(quantity<1){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Please select quantity"                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    NSMutableDictionary *image=[[self.productData objectForKey:@"images"]objectAtIndex:0];
    
    product=[product initProduct:[self.productData objectForKey:@"name"] productId:[self.productData objectForKey:@"product_id"] Quantity:selectedQuantity Weight:[self.productData objectForKey:@"weight"] code:[self.productData objectForKey:@"sku"] spclQusTxt:[self.productData objectForKey:@"special_question"] spclAnsID:[specialAnsDic objectForKey:@"id"] spclAnsText:[specialAnsDic objectForKey:@"answer"] spclAnsSubSku:[specialAnsDic objectForKey:@"sub_sku"] imageURL:[image objectForKey:@"image_url"] thumbImage:[image objectForKey:@"thumbnail_image_url"] price:[self.productData objectForKey:@"price"] oldPrice:[self.productData objectForKey:@"old_price"] availabl:availablity tag:[self.productData objectForKey:@"tag"]];
    
    [DatabaseHandeler myCartDataSave:product];
    
    [DatabaseHandeler getProduct];
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if(flag){
        return quantity;
    }else{
     return pickerData.count;
    }
    
}

- (void)pickerViewController:(RMPickerViewController *)vc didSelectRows:(NSArray *)selectedRows{
    
    if(flag){

        NSString *str=[NSString stringWithFormat:@"%d",[[selectedRows objectAtIndex:selectedRows.count-1]intValue]+1];
        
        [self.quantitybtn setTitle:str forState:UIControlStateNormal];
        selectedQuantity=str;
        
    }else{
     
       int i=[[selectedRows objectAtIndex:selectedRows.count-1]intValue];
        NSString *str=[[pickerData objectAtIndex:i]objectForKey:@"answer"];
        
        specialAnsDic=[pickerData objectAtIndex:i];
        
        [self.specialQuestion setTitle:str forState:UIControlStateNormal];
        
        flag=true;
       // quantity=[[[pickerData objectAtIndex:i]objectForKey:@"available_quantity"]intValue];
        
        self.quantitybtn.enabled=YES;
        
        
        NSString *string = [NSString stringWithFormat:@"http://online-kenakata.com/mobile_api/rest.php?method=check_stock&product_id=%@&is_special_question=true&special_answer_id=%@&application_code=1000",[self.productData objectForKey:@"product_id"],[specialAnsDic objectForKey:@"id"]];
        
        [self checkQuantity:string];

        
    }
    
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if(flag){
        return [NSString stringWithFormat:@"%ld",row+1];
    }else{
        NSString *str =[[pickerData objectAtIndex:row]objectForKey:@"answer"];
        return str;
    }
}

- (void)pickerViewControllerDidCancel:(RMPickerViewController *)vc{
    
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
