//
//  ProductList.m
//  OnlineKenakata-Demo
//
//  Created by Rabby Alam on 7/9/14.
//  Copyright (c) 2014 rabbi. All rights reserved.
//

#import "ProductList.h"
#import "UIImageView+WebCache.h"
#import "AFNetworking/AFNetworking.h"
#import "ProductDetails.h"
#import "Data.h"
#import "TextStyling.h"
@interface ProductList ()

@end

@implementation ProductList

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.title=self.catagoryName;
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    productList=[[NSMutableArray alloc]init];
    catagoryList=[[NSMutableArray alloc]init];

    
    if(loading==nil){
        [self initLoading];
    }
        
        
    [self get_categories_by_parent_cateogory_id];

    
    
    
    [self addPullToRefresh];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];

    NSMutableDictionary *dic = [NSKeyedUnarchiver unarchiveObjectWithData:[ud objectForKey:@"get_user_data"]];

    currency=[[[dic objectForKey:@"success"]objectForKey:@"user"]objectForKey:@"currency"];
    
    
    
}

-(void)initLoading{
    CGFloat x= self.view.frame.size.width/2-65;
    CGFloat y =(self.view.frame.size.height-self.navigationController.navigationBar.frame.size.height-self.tabBarController.tabBar.frame.size.height)/2-25;
    
    loading=[[LoadingView alloc]initWithFrame:CGRectMake(x, y, 130, 50)];
    loading.hidden=YES;
    [self.view addSubview:loading];
}


- (void)addPullToRefresh
{
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]
                      init];
    refreshControl.tintColor = [UIColor blackColor];
    
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    
    self.refreshControl=refreshControl;
    
}

-(void)refresh:(id)sender {
    
    [self get_categories_by_parent_cateogory_id];
}

-(void)get_categories_by_parent_cateogory_id{
    
    NSString *string = [NSString stringWithFormat:@"%@/rest.php?method=get_categories_by_parent_cateogory_id&parent_category_id=%@&application_code=%@",[Data getBaseUrl],self.productId,[Data getAppCode]];
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
        loading.hidden=YES;
        [loading StopAnimating];
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
    productList=[[dic objectForKey:@"success"]objectForKey:@"products"];
    catagoryList=[[dic objectForKey:@"success"]objectForKey:@"categories"];

    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
    [loading StopAnimating];
    loading.hidden=YES;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
    
    
    return productList.count+catagoryList.count;
    


}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellCat"];
    
    if(catagoryList.count+productList.count==0){
        return cell;
        
    }

    if(indexPath.row>=catagoryList.count){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellProdect" forIndexPath:indexPath];
        
        // Configure the cell...
        
        
        NSMutableDictionary *dic=[productList objectAtIndex:indexPath.row-catagoryList.count];
        
        UILabel* productName=(UILabel *)[cell viewWithTag:304];
        UIImageView *thumbnil=(UIImageView *)[cell viewWithTag:301];
        UIImageView *toping=(UIImageView *) [cell viewWithTag:302];
        
        UILabel *oldPrice =(UILabel *)[cell viewWithTag:305];
        UILabel *newPrice=(UILabel *) [cell viewWithTag:306];
        //
        productName.text=@"";
        thumbnil.image=nil;
        toping.image=nil;
        oldPrice.text=@"";
        newPrice.text=@"";
        NSString * imgurl = [[[dic objectForKey:@"images"] objectAtIndex:0]objectForKey:@"thumbnail_image_url"];
        
        
        productName.attributedText=[TextStyling AttributForTitle:[NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]]];
        
        [thumbnil sd_setImageWithURL:[NSURL URLWithString:imgurl]
                 placeholderImage:[UIImage imageNamed:@"placeholder.gif"]];
        
        int tag = (int)[[dic objectForKey:@"tag"] integerValue];
        if(tag==1){
            toping.image=[UIImage imageNamed:@"tag_new.png"];
            
            oldPrice.attributedText=[TextStyling AttributForPrice:[NSString stringWithFormat:@"%@ %@",currency,[dic objectForKey:@"price"]]];
        }else if (tag==2){
            toping.image=[UIImage imageNamed:@"tag_sale.png"];
            
            
            oldPrice.attributedText = [TextStyling AttributForPriceStrickThrough:[NSString stringWithFormat:@"%@ %@",currency,[dic objectForKey:@"old_price"]]];
            
            
            
            newPrice.attributedText=[TextStyling AttributForPrice:[NSString stringWithFormat:@"%@ %@",currency,[dic objectForKey:@"price"]]];
            
        }else{
            
            oldPrice.attributedText=[TextStyling AttributForPrice:[NSString stringWithFormat:@"%@ %@",currency,[dic objectForKey:@"price"]]];
            
        }
        
        
        // NSLog(@"%@",[NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]]);
        
        return cell;
    }
    UILabel * title=(UILabel *)[cell viewWithTag:202];
    UIImageView *thumbnil=(UIImageView* )[cell viewWithTag:201];
    title.text=@"";
    thumbnil.image=nil;
    
    NSMutableDictionary *dic=[catagoryList objectAtIndex:indexPath.row];
    
    
    //  title.text=[dic objectForKey:@"cat_name"];
    title.attributedText=[TextStyling AttributForTitle:[dic objectForKey:@"cat_name"]];
    NSString *imgurl=[NSString stringWithFormat:@"%@",[dic objectForKey:@"thumb_image_url"]];
    
    
    [thumbnil sd_setImageWithURL:[NSURL URLWithString:imgurl]
             placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(catagoryList.count<=indexPath.row){
    
        NSMutableDictionary *dic = [productList objectAtIndex:indexPath.row];
        
        ProductDetails *prdtails;
       
        int available =[[dic objectForKey:@"add_to_cart"]intValue];
        
       
            if(available<1){
                prdtails= [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ProductDetails2"];
                NSLog(@"in no button");
                
            }else{
                prdtails= [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"productdetails"];
                
            }
      
        
        
        prdtails.productData=dic;
        
        [self.navigationController pushViewController:prdtails animated:YES];
        
        
    }else{
        ProductList *pList=[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"productList"];
        NSString *str = [[catagoryList objectAtIndex:indexPath.row]objectForKey:@"cat_id"];
        
        pList.productId=str;
        [self.navigationController pushViewController:pList animated:YES];
    }
    
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}




/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
