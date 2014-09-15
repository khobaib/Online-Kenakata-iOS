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
#import "MyCart.h"
#import "Data.h"
#import "TextStyling.h"
#import "BBBadgeBarButtonItem.h"

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
    
    NSMutableDictionary *dic = [NSKeyedUnarchiver unarchiveObjectWithData:[ud objectForKey:@"get_user_data"]];;
    
    currency=[[[dic objectForKey:@"success"]objectForKey:@"user"]objectForKey:@"currency"];
    attributeList=[self.productData objectForKey:@"attributes"];
    

    self.attributeTableHeight.constant=50.0*(attributeList.count+1);
    specialAnsDic=[[NSMutableDictionary alloc]init];
    [self initLoading];

    [self setValueOnUI];
    selectedQuantity=@"";
    varientID=@"";

    
    attributeIdList=[[NSMutableArray alloc]initWithCapacity:attributeList.count];
    
    for(int i=0;i<attributeList.count;i++){
       
        [attributeIdList addObject:[NSNull null]];
    }
    

}

- (void)setValueOnUI
{
    [self.quantitybtn setTitleColor:[TextStyling appColor] forState:UIControlStateNormal];
    [self.specialQuestion setTitleColor:[TextStyling appColor] forState:UIControlStateNormal];
    [self.confirmBtn setBackgroundColor:[TextStyling appColor]];
    
    self.name.attributedText=[TextStyling AttributForTitle:[self.productData objectForKey:@"name"]];
    
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    NSMutableDictionary *dic1=[NSKeyedUnarchiver unarchiveObjectWithData:[ud objectForKey:@"get_user_data"]];;
    NSMutableDictionary *dic=[[dic1 objectForKey:@"success"]objectForKey:@"user"];
    
    NSString *addToCartMEssage=[dic objectForKey:@"add_to_cart_message"];
    
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[addToCartMEssage dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];



    [self.details setAttributedText:attributedString];
  //  NSLog(@"%@",addToCartMEssage);
    
    NSString * imgurl = [[[self.productData objectForKey:@"images"] objectAtIndex:0]objectForKey:@"thumbnail_image_url"];

    [self.thumbnil setImageWithURL:[NSURL URLWithString:imgurl]
             placeholderImage:[UIImage imageNamed:@"placeholder.gif"]];
    
    int tag = (int)[[self.productData objectForKey:@"tag"] integerValue];
    
    attributeList=[self.productData objectForKey:@"attributes"];
    
    if(attributeList==nil){
        self.specialQuestionView.hidden=YES;
        
        [self.specialQuestionView removeFromSuperview];
       
        attribute_index=-1;
        
       
        
        NSString *string = [NSString stringWithFormat:@"%@/rest.php?method=check_stock&product_id=%@&is_special_question=false&special_answer_id=&application_code=%@",[Data getBaseUrl],[self.productData objectForKey:@"product_id"],[Data getAppCode]];
        
        [self checkQuantity:string];

    }else{
        
        
       
    }
    if(tag==1){
        
        self.oldPrice.attributedText=[TextStyling AttributForPrice:[NSString stringWithFormat:@"%@ %@",currency,[self.productData objectForKey:@"price"]]];
        
        self.tooping.image=[UIImage imageNamed:@"tag_new.png"];

    }else if (tag==2){
        self.tooping.image=[UIImage imageNamed:@"tag_sale.png"];

        self.oldPrice.attributedText = [TextStyling AttributForPriceStrickThrough:[NSString stringWithFormat:@"%@ %@",currency,[self.productData objectForKey:@"old_price"]]];
        
      
        self.priceNew.attributedText=[TextStyling AttributForPrice:[NSString stringWithFormat:@"%@ %@",currency,[self.productData objectForKey:@"price"]]];
        
    }else{
        
        self.oldPrice.attributedText=[TextStyling AttributForPrice:[NSString stringWithFormat:@"%@ %@",currency,[self.productData objectForKey:@"price"]]];
        
    }
    
        
    //int available =[[self.productData objectForKey:@"general_available_quantity"]intValue];
    self.itemCode.text=[self.productData objectForKey:@"sku"];

   /* if(available>0){
        self.itemCode.text=[self.productData objectForKey:@"sku"];
        
    }else{
        self.itemCode.hidden=YES;
        self.itemCodeLable.hidden=YES;
    }*/
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



-(IBAction)addToMyCart:(id)sender{
 
    Product* product=[[Product alloc]init];
   
    if([selectedQuantity isEqualToString:@""]){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Please select quantity"                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    
    NSMutableDictionary *image=[[self.productData objectForKey:@"images"]objectAtIndex:0];
    
    NSString *attributes=@"";
    
    for(int i=0;i<attributeIdList.count;i++){
        NSString *str=[[attributeList objectAtIndex:i]objectForKey:@"name"];
        attributes=[attributes stringByAppendingFormat:@"%@:",str];
        
        NSArray *array=[[attributeList objectAtIndex:i]objectForKey:@"attribute_values"];
        for(int j=0;j<[array count];j++){
            if([[attributeIdList objectAtIndex:i]isEqualToString:[[array objectAtIndex:j]objectForKey:@"id"]]){
                  attributes=[attributes stringByAppendingFormat:@"%@ ",[[array objectAtIndex:j]objectForKey:@"name"]];
            }
        }
        
    }
    NSLog(@"%@ %@",attributes,varientID);

    product=[product initProduct:[self.productData objectForKey:@"name"] productId:[self.productData objectForKey:@"product_id"] Quantity:selectedQuantity Weight:[self.productData objectForKey:@"weight"] code:[self.productData objectForKey:@"sku"] attributs:attributes varient:varientID imageURL:[image objectForKey:@"image_url"] thumbImage:[image objectForKey:@"thumbnail_image_url"] price:[self.productData objectForKey:@"price"] oldPrice:[self.productData objectForKey:@"old_price"] availabl:availablity tag:[self.productData objectForKey:@"tag"]];
    
    if([DatabaseHandeler myCartDataSave:product]){
     
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Success"
                                                            message:@"Product is added to your cart."                                                           delegate:self
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:@"MyCart",nil];
        [alertView show];
    }
    
    //[DatabaseHandeler getProduct];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if(buttonIndex==1){
        
        MyCart *cart=[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"MyCart"];
        
        cart.productList=[DatabaseHandeler getProduct];
        
       // NSLog(@"log %lu",(unsigned long)cart.productList.count);
        if(cart.productList.count<1){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error "
                                                                message:@"My Cart is empty"
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
            [alertView show];
            return;
        }
        [self.navigationController pushViewController:cart animated:YES];
        
        
    }else if (buttonIndex==0){
      //  NSLog(@"%ld",(long)buttonIndex);
        UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(275, -6, 50, 50)];
        
        [btn setBackgroundImage:[UIImage imageNamed:@"my_cart.png"] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:10];
        
        // [btn setBackgroundImage:[self imageWithColor:[UIColor blueColor]] forState:UIControlStateHighlighted];
        
        // [btn setBackgroundColor:[UIColor whiteColor]];
        [btn addTarget:self action:@selector(myCart) forControlEvents:UIControlEventTouchUpInside];
        // btn.imageEdgeInsets= UIEdgeInsetsMake(0.0, 0, 0, 10);
        
        BBBadgeBarButtonItem *barButton = [[BBBadgeBarButtonItem alloc] initWithCustomUIButton:btn];
        // [barButton setImageInsets:UIEdgeInsetsMake(0.0, 0, 0, 10)];
        
        
        barButton.badgeBGColor=[UIColor redColor];
        [barButton setBadgeValue:[NSString stringWithFormat:@"%d",[DatabaseHandeler totalProduct]]];
        barButton.badgeOriginX=16;
        barButton.badgeOriginY=4;
        [barButton setBadgePadding:3];
        
        // [self.navigationItem setRightBarButtonItem:button];
        btn.tag=1;
        [self.navigationController.navigationBar addSubview:btn];
        
        btn=nil;

    }
}

-(void)myCart{
    MyCart *cart=[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"MyCart"];
    
    cart.productList=[DatabaseHandeler getProduct];
    
    //   NSLog(@"log %d",cart.productList.count);
    if(cart.productList.count<1){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error "
                                                            message:@"My Cart is empty"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
        return;
    }
    [self.navigationController pushViewController:cart animated:YES];
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if(attribute_index==-1){
        return MIN(30, quantity);
    }else{
     return pickerData.count;
    }
    
}

- (void)pickerViewController:(RMPickerViewController *)vc didSelectRows:(NSArray *)selectedRows{
    
    if(attribute_index==-1){

        NSString *str=[NSString stringWithFormat:@"%d",[[selectedRows objectAtIndex:selectedRows.count-1]intValue]+1];
        
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:(attributeIdList.count) inSection:0];
        
        UITableViewCell *cell=[self.tableView cellForRowAtIndexPath:indexPath];
        
        UIButton *btn=(UIButton*)[cell viewWithTag:42];


        [btn setTitle:str forState:UIControlStateNormal];
        selectedQuantity=str;
        
    }else{
     
       int i=[[selectedRows objectAtIndex:selectedRows.count-1]intValue];
        NSString *str=[[pickerData objectAtIndex:i]objectForKey:@"id"];
        

        [attributeIdList replaceObjectAtIndex:attribute_index withObject:str];

        NSString *name=[[pickerData objectAtIndex:i]objectForKey:@"name"];
        
       // specialAnsDic=[pickerData objectAtIndex:i];
        
        //[self.specialQuestion setTitle:str forState:UIControlStateNormal];
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:attribute_index inSection:0];
        
        UITableViewCell *cell=[self.tableView cellForRowAtIndexPath:indexPath];
        
        UIButton *btn=(UIButton*)[cell viewWithTag:42];

        [btn setTitle:name forState:UIControlStateNormal];
        // quantity=[[[pickerData objectAtIndex:i]objectForKey:@"available_quantity"]intValue];
        
        self.quantitybtn.enabled=YES;
        
      
        
       // NSString *string = [NSString stringWithFormat:@"%@/rest.php?method=check_stock&product_id=%@&is_special_question=true&special_answer_id=%@&application_code=%@",[Data getBaseUrl],[self.productData objectForKey:@"product_id"],[specialAnsDic objectForKey:@"id"],[Data getAppCode]];
        
        //[self checkQuantity:string];

        
    }
    
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    if(attribute_index==-1){
        return [NSString stringWithFormat:@"%d",(int)(row+1)];
    }else{
        NSString *str =[[pickerData objectAtIndex:row]objectForKey:@"name"];
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


#pragma mark -Attribute Functionality




-(IBAction)selectAttribute:(id)sender{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    
    
    if(indexPath.row>=attributeList.count){
        
        if(attributeList.count==0){
             attribute_index=-1;
            quantity=[[self.productData objectForKey:@"general_available_quantity"]intValue];
            RMPickerViewController *pickerVC = [RMPickerViewController pickerController];
            pickerVC.delegate = self;
            
            [pickerVC show];
            return;
        }
        
        if(![self isEmptyArray]){
            attribute_index=-1;
            
            quantity=[self getQuantity];
            if(quantity==0){
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                    message:@"Sorry.Product with this attribute is not available Right now.you can try other attributes"
                                                                   delegate:nil
                                                          cancelButtonTitle:@"Ok"
                                                          otherButtonTitles:nil];
                [alertView show];
                return;

            }
             RMPickerViewController *pickerVC = [RMPickerViewController pickerController];
             pickerVC.delegate = self;
                
             [pickerVC show];
            
            
            
            
        }else{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:@"Please select all the attributs first."                                                           delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
            [alertView show];
            return;

        }
        
       
        
    }else{
        
        attribute_index=indexPath.row;
        pickerData=[[attributeList objectAtIndex:attribute_index]objectForKey:@"attribute_values"];
        RMPickerViewController *pickerVC = [RMPickerViewController pickerController];
        pickerVC.delegate = self;
        
        [pickerVC show];
    }
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return (attributeList.count+1);
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"attributeCell"];
    UILabel *type=(UILabel *)[cell viewWithTag:41];
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, cell.contentView.frame.size.height - 6.0, cell.contentView.frame.size.width, 6)];
    
    lineView.backgroundColor = [UIColor colorWithRed:(233.0f/255.0f) green:(231.0f/255.0f) blue:(238.0f/255.0f) alpha:1];
    [cell.contentView addSubview:lineView];
    
    if((indexPath.row>=attributeList.count)){
        type.text=@"Quantity";
        return cell;
    }
   // NSLog(@"index %d AList%d",indexPath.row,attributeList.count);
    type.text=[[attributeList objectAtIndex:indexPath.row]objectForKey:@"name"];
    return cell;
}

-(BOOL)isEmptyArray{
    
    for(int i=0;i<attributeIdList.count;i++){
        if([attributeIdList objectAtIndex:i]==[NSNull null]){
            return YES;
        }
    }
    
    
    return NO;
}

-(int)getQuantity{
    NSString *str=@"";
    for(int i=0;i<attributeIdList.count;i++){
        
        
       str=[str stringByAppendingString:[attributeIdList objectAtIndex:i]];
        if(i<attributeIdList.count-1){
             str=[str stringByAppendingString:@","];
        }
        
            }
    

    
    NSMutableArray *varients=[self.productData objectForKey:@"variants"];
    
    for(int i=0;i<varients.count;i++){
        NSMutableDictionary *dic=[varients objectAtIndex:i];
        
        if([str isEqualToString:[dic objectForKey:@"attribute_value_set"]]){
            
            varientID=[dic objectForKey:@"id"];
           

            return  [[dic objectForKey:@"quantity"]intValue];
        }
    }
    
    return 0;
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
