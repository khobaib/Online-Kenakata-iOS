//
//  MyCart.m
//  OnlineKenakata
//
//  Created by Rabby Alam on 7/19/14.
//  Copyright (c) 2014 OnlineKenakata. All rights reserved.
//

#import "MyCart.h"
#import "Product.h"
#import "DatabaseHandeler.h"
#import "UIImageView+WebCache.h"
#import "AFNetworking.h"
#import "ProceedToCheckout.h"
#import "Data.h"

@interface MyCart ()

@end

@implementation MyCart

@synthesize productList;
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
    counter=0;
    [self initLoading];
    
    serverData=NO;
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    NSMutableDictionary *dic = [NSKeyedUnarchiver unarchiveObjectWithData:[ud objectForKey:@"get_user_data"]];
    
    currency=[[[dic objectForKey:@"success"]objectForKey:@"user"]objectForKey:@"currency"];
    [self setValueOntop];
}


-(void)initLoading{
    CGFloat x= self.view.frame.size.width/2-65;
    CGFloat y =(self.view.frame.size.height-self.navigationController.navigationBar.frame.size.height-self.tabBarController.tabBar.frame.size.height)/2-25;
    
    loading=[[LoadingView alloc]initWithFrame:CGRectMake(x, y, 130, 50)];
    loading.hidden=YES;
    [self.view addSubview:loading];
}

-(void)setValueOntop{
    self.subTotalLable.text=[NSString stringWithFormat:@"Sub total (%luitems):",(unsigned long)productList.count];
    int total=0;
    NSString *str=@"";

    for (int i=0; i<productList.count; i++) {
        Product *product=[productList objectAtIndex:i];
        
        total+= [product.PRICE intValue]*[product.QUANTITY intValue];
        
        if(i!=0){
            str=[NSString stringWithFormat:@"%@,%@",str,product.ID];
        }else{
            str=product.ID;
        }

    }
    
    self.total.text=[NSString stringWithFormat:@"%@%d",currency,total];
    self.subTotal.text=[NSString stringWithFormat:@"%@%d",currency,total];
    [self checkAvailablity:str];
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
   
    serverProductList=[[dic objectForKey:@"success"]objectForKey:@"products"];
    [loading StopAnimating];
    loading.hidden=YES;
    serverData=YES;
    
    [self.tableview reloadData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return productList.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
 
    UITableViewCell *Cell=[tableView dequeueReusableCellWithIdentifier:@"CellMyCart" forIndexPath:indexPath];
    
    if(productList.count>0){
        
        Product *product=[productList objectAtIndex:indexPath.row];
        UILabel *name=(UILabel *)[Cell viewWithTag:703];
        UILabel *itemCode=(UILabel *)[Cell viewWithTag:704];
        UILabel *spcl=(UILabel *)[Cell viewWithTag:705];
        UILabel *price=(UILabel *)[Cell viewWithTag:706];
        UILabel *quantityLable=(UILabel *)[Cell viewWithTag:707];
        UILabel *total=(UILabel *)[Cell viewWithTag:708];
        UIImageView *thumbnil=(UIImageView *)[Cell viewWithTag:701];
        UIImageView *toping = (UIImageView *)[Cell viewWithTag:702];
        UILabel *stocIndicator=(UILabel *) [Cell viewWithTag:710];
    
        

        
        
        if(serverData){
            NSMutableDictionary *data=[self getProduct:product.ID];
            
            name.text=[data objectForKey:@"name"];
            itemCode.text=[NSString stringWithFormat:@"Item Code %@",[data objectForKey:@"sku"]];
            NSString *spclQusText =[data objectForKey:@"special_question" ];

            if([spclQusText  isEqualToString:@""]){
                spcl.hidden=YES;
                int GAQ=[[data objectForKey:@"general_available_quantity"]intValue];
                if(GAQ<1){
                    stocIndicator.text=@"Out of stock";
                    [stocIndicator setTextColor:[UIColor redColor]];
                    counter++;
                    quantityLable.text= [NSString stringWithFormat:@"Quantity #%@",product.QUANTITY];


                }else if ([product.QUANTITY intValue]>GAQ){
                    stocIndicator.text=[NSString stringWithFormat:@"Only %d left",GAQ];
                    [stocIndicator setTextColor:[UIColor orangeColor]];
                    quantityLable.text= [NSString stringWithFormat:@"Quantity #%d",GAQ];

                }else {
                    stocIndicator.text=@"In stock";
                    [stocIndicator setTextColor:[UIColor greenColor]];
                    quantityLable.text= [NSString stringWithFormat:@"Quantity #%@",product.QUANTITY];


                }
            }else{
                spcl.text=[NSString stringWithFormat:@"%@: %@",[data objectForKey:@"special_question"],product.SPECIAL_ANS_TEXT];//product.SPECIAL_QUESTION_TEXT,product.SPECIAL_ANS_TEXT];
                int gaq;
                NSArray *arr=[data objectForKey:@"special_answers"];
                for(int i=0;i<arr.count;i++){
                    NSString *txt=[[arr objectAtIndex:i]objectForKey:@"id"];
                    if([product.SPECIAL_ANS_ID isEqualToString:txt]){
                        gaq=[[[arr objectAtIndex:i]objectForKey:@"available_quantity"]intValue];

                        break;
                    }
                }
                
                if(gaq<1){
                    stocIndicator.text=@"Out of stock";
                    [stocIndicator setTextColor:[UIColor redColor]];
                    counter++;
                    quantityLable.text= [NSString stringWithFormat:@"Quantity #%@",product.QUANTITY];

                    
                }else if ([product.QUANTITY intValue]>gaq){
                    stocIndicator.text=[NSString stringWithFormat:@"Only %d left",gaq];
                    [stocIndicator setTextColor:[UIColor orangeColor]];
                    quantityLable.text= [NSString stringWithFormat:@"Quantity #%d",gaq];


                }else {
                    stocIndicator.text=@"In stock";
                    [stocIndicator setTextColor:[UIColor greenColor]];
                    quantityLable.text= [NSString stringWithFormat:@"Quantity #%@",product.QUANTITY];

                }
            }
            price.text=[NSString stringWithFormat:@"%@:%@",currency, [data objectForKey:@"price"]];
            
            
            int x=[[data objectForKey:@"price"] intValue]*[product.QUANTITY intValue];
            
            total.text=[NSString stringWithFormat:@"%@:%d",currency,x];
            NSString *thumbUrl=[[[data objectForKey:@"images"]objectAtIndex:0]objectForKey:@"thumbnail_image_url"];
            [thumbnil setImageWithURL:[NSURL URLWithString:thumbUrl]
                     placeholderImage:[UIImage imageNamed:@"placeholder.gif"]];
            
            int tag = [[data objectForKey:@"tag"] intValue];
            if(tag==1){
                toping.image=[UIImage imageNamed:@"tag_new.png"];
                
            }else if (tag==2){
                toping.image=[UIImage imageNamed:@"tag_sale.png"];
                
            }
            
            
        }else{
            name.text=product.name;
            itemCode.text=[NSString stringWithFormat:@"Item Code %@",product.ITEM_CODE];
            if([product.SPECIAL_QUESTION_TEXT isEqualToString:@""]){
                spcl.hidden=YES;
            }else{
                spcl.text=[NSString stringWithFormat:@"%@: %@",product.SPECIAL_QUESTION_TEXT,product.SPECIAL_ANS_TEXT];
                
            }
            price.text=[NSString stringWithFormat:@"%@:%@",currency, product.PRICE];
            
            quantityLable.text= [NSString stringWithFormat:@"Quantity #%@",product.QUANTITY];
            
            int x=[product.PRICE intValue]*[product.QUANTITY intValue];
            
            total.text=[NSString stringWithFormat:@"%@:%d",currency,x];
            
            [thumbnil setImageWithURL:[NSURL URLWithString:product.THUMBNAIL_IMAGE_URL]
                     placeholderImage:[UIImage imageNamed:@"placeholder.gif"]];
            
            int tag = [product.PRODUCT_TAG intValue];
            if(tag==1){
                toping.image=[UIImage imageNamed:@"tag_new.png"];
                
            }else if (tag==2){
                toping.image=[UIImage imageNamed:@"tag_sale.png"];
                
            }
        }
        
        
    }
    
    return Cell;
}

-(IBAction)quantity:(id)sender{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableview];
    quantity = [self.tableview indexPathForRowAtPoint:buttonPosition];
    Product *product=[productList objectAtIndex:quantity.row];
    NSMutableDictionary *dic=[self getProduct:product.ID];
    
    NSString *spclQusText =[dic objectForKey:@"special_question" ];
    
    if([spclQusText  isEqualToString:@""]){
        editQuantity=[[dic objectForKey:@"general_available_quantity"]intValue];

    }else{
      NSArray *arr=[dic objectForKey:@"special_answers"];
        for(int i=0;i<arr.count;i++){
            NSString *txt=[[arr objectAtIndex:i]objectForKey:@"id"];
            if([product.SPECIAL_ANS_ID isEqualToString:txt]){
                editQuantity=[[[arr objectAtIndex:i]objectForKey:@"available_quantity"]intValue];

                break;
            }
        }
    }
    
    
    RMPickerViewController *pickerVC = [RMPickerViewController pickerController];
    pickerVC.delegate = self;
    
    [pickerVC show];

    
}

-(NSMutableDictionary *)getProduct:(NSString *)productID{
    NSMutableDictionary *dic;
    for (int i=0; i<serverProductList.count; i++) {
        dic=[serverProductList objectAtIndex:i];
        if([[dic objectForKey:@"product_id"] isEqualToString:productID]){
            break;
        }
    }
    
    return dic;
    
}
-(IBAction)removeItem:(id)sender{
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableview];
    NSIndexPath *indexPath = [self.tableview indexPathForRowAtPoint:buttonPosition];
    
    Product *product=[productList objectAtIndex:indexPath.row];
    
    NSMutableDictionary* dic=[self getProduct:product.ID];
    
    NSString *spclQus=product.SPECIAL_QUESTION_TEXT;
    
    if([spclQus isEqualToString:@""]){
        int gaq=[[dic objectForKey:@"general_available_quantity"]intValue];
        if(gaq<1){
            counter--;
        }
    }else{
        int gaq;
        NSArray *arr=[dic objectForKey:@"special_answers"];
        for(int i=0;i<arr.count;i++){
            NSString *txt=[[arr objectAtIndex:i]objectForKey:@"id"];
            if([product.SPECIAL_ANS_ID isEqualToString:txt]){
                gaq=[[[arr objectAtIndex:i]objectForKey:@"available_quantity"]intValue];
                break;
            }
            
        }
        if(gaq<1){
            counter--;
        }
        


    }
    [DatabaseHandeler deletItem:product.TABLE_PRIMARY_KEY];
    [productList removeObjectAtIndex:indexPath.row];
    [self.tableview deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationAutomatic];

}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return MIN(30, editQuantity);
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [NSString stringWithFormat:@"%ld",(long)row+1];
}


- (void)pickerViewController:(RMPickerViewController *)vc didSelectRows:(NSArray *)selectedRows{
 
    int qNew=[[selectedRows lastObject]intValue]+1;
    UITableViewCell *cell=[self.tableview cellForRowAtIndexPath:quantity];
    
    UILabel *quantityLable=(UILabel *)[cell viewWithTag:707];
    
    Product *product=[productList objectAtIndex:quantity.row];

    
    NSMutableDictionary *dic=[self getProduct:product.ID];
    int x=[[dic objectForKey:@"price"] intValue]*qNew;
    UILabel *totalL=(UILabel *)[cell viewWithTag:708];

    totalL.text=[NSString stringWithFormat:@"%@:%d",currency,x];

    quantityLable.text= [NSString stringWithFormat:@"Quantity #%d",qNew];

    product.QUANTITY=[NSString stringWithFormat:@"%d",qNew];
    
    
    
    self.subTotalLable.text=[NSString stringWithFormat:@"Sub total (%luitems):",(unsigned long)productList.count];
    int total=0;
    for (int i=0; i<productList.count; i++) {
        Product *product=[productList objectAtIndex:i];
        
        total+= [product.PRICE intValue]*[product.QUANTITY intValue];
        
        
    }
    
    self.total.text=[NSString stringWithFormat:@"%@%d",currency,total];
    self.subTotal.text=[NSString stringWithFormat:@"%@%d",currency,total];

    [DatabaseHandeler updateQuantity:qNew productID:product.ID];
    
}

/**
 This delegate method is called when the user selects the cancel button or taps the darkened background (if `backgroundTapsDisabled` is set to NO).
 
 @param vc The picker view controller that just canceled.
 */
- (void)pickerViewControllerDidCancel:(RMPickerViewController *)vc{
    
}

-(IBAction)proceedToCheckOut:(id)sender{
    if(counter!=0){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error "
                                                            message:@"Please remove the out of stock item"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
        return ;
    }
    
    ProceedToCheckout *pcd=[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"proceedToCheckOut"];
    pcd.productList=productList;
    
    [self.navigationController pushViewController:pcd animated:YES];
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
