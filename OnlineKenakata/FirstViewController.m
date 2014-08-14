//
//  FirstViewController.m
//  OnlineKenakata-Demo
//
//  Created by Rabby Alam on 7/8/14.
//  Copyright (c) 2014 rabbi. All rights reserved.
//

#import "FirstViewController.h"
#import "UIImageView+WebCache.h"
#import "AFNetworking/AFNetworking.h"
#import  "ProductList.h"
#import "Data.h"
#import "TextStyling.h"
#import "ProductDetails.h"
//#import "Constant.h"

#import "LoginViewController.h"
#import "SignupViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController




- (void)viewDidLoad
{
    [super viewDidLoad];
    catagoryList=[[NSMutableArray alloc]init];
    productList=[[NSMutableArray alloc]init];
    self.tableView.hidden=YES;
    self.searchBar.hidden=YES;
    if(loading==nil){
        [self initLoading];

    }
    
    [self initScroller];
    NSLog(@"%f",_image.size.width);

    [self addPullToRefresh];
    
    [self get_categories_by_parent_cateogory_id];

    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    NSMutableDictionary *dic = [NSKeyedUnarchiver unarchiveObjectWithData:[ud objectForKey:@"get_user_data"]];

    currency=[[[dic objectForKey:@"success"]objectForKey:@"user"]objectForKey:@"currency"];

    isSearched=NO;
}

-(void)initLoading{
    CGFloat x= self.view.frame.size.width/2-65;
    CGFloat y =(self.view.frame.size.height-self.navigationController.navigationBar.frame.size.height-self.tabBarController.tabBar.frame.size.height)/2-25;
    
    loading=[[LoadingView alloc]initWithFrame:CGRectMake(x, y, 130, 50)];
    loading.hidden=YES;
    [self.view addSubview:loading];
}
-(void)refresh:(id)sender {
    
    [self get_categories_by_parent_cateogory_id];
}

- (void)initScroller
{
	// Do any additional setup after loading the view, typically from a nib
    CGFloat ratio = CGRectGetWidth(self.scrollView.bounds) / _image.size.width;
    
    CGSize size;
    size.width=CGRectGetWidth(self.scrollView.bounds);
    size.height=_image.size.height*ratio;
    UIImageView * imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, size.width, size.height)];
    self.scrollView.contentSize=size;
    imageView.image=_image;
    
    UITapGestureRecognizer *tapgesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOnScroll)];
    tapgesture.numberOfTapsRequired=1;
    tapgesture.enabled=YES;
    
    
    [self.scrollView addSubview:imageView];
    [self.scrollView addGestureRecognizer:tapgesture];
    
    tapgesture=nil;
    _image=nil;
}


-(void)tapOnScroll{
    
    self.tableView.hidden=NO;
    self.searchBar.hidden=NO;
    self.scrollView.hidden=YES;
    
}



- (void)addPullToRefresh
{
    refreshControl = [[UIRefreshControl alloc]
                      init];
    refreshControl.tintColor = [UIColor blackColor];
    
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    
    UITableViewController *tableViewController = [[UITableViewController alloc] init];
    tableViewController.tableView = self.tableView;
    tableViewController.refreshControl=refreshControl;
}


-(void)parsCatagoryList:(id)data{

    NSMutableDictionary *dic = (NSMutableDictionary *)data;
    catagoryList=[[dic objectForKey:@"success"]objectForKey:@"categories"];
    productList=[[dic objectForKey:@"success"]objectForKey:@"products"];
    [refreshControl endRefreshing];
    [loading StopAnimating];
    loading.hidden=YES;
    [self.tableView reloadData];
    
   // NSLog(@"%@",tableData);
}

-(void)get_categories_by_parent_cateogory_id{
    
    NSString *string = [NSString stringWithFormat:@"%@/rest.php?method=get_categories_by_parent_cateogory_id&parent_category_id=0&application_code=%@",[Data getBaseUrl],[Data getAppCode]];
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // 2
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self parsCatagoryList:responseObject];
        
        
        
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
        return (catagoryList.count+productList.count);
    

}


-(void)viewWillAppear:(BOOL)animated{
   [super viewWillAppear:animated];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
 
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellCat"];

    if(catagoryList.count+productList.count==0){
        return cell;

    }
    
    if(indexPath.row>=catagoryList.count){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"productCell" forIndexPath:indexPath];
        
        // Configure the cell...
        
        
        NSMutableDictionary *dic=[productList objectAtIndex:indexPath.row];
        
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
        
        [thumbnil setImageWithURL:[NSURL URLWithString:imgurl]
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
    
    
    [thumbnil setImageWithURL:[NSURL URLWithString:imgurl]
    placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
     return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(catagoryList.count<=indexPath.row){
        
        NSMutableDictionary *dic = [productList objectAtIndex:indexPath.row];
        
        ProductDetails *prdtails;
        NSString *spclQus=[dic objectForKey:@"special_question"];
        int available =[[dic objectForKey:@"general_available_quantity"]intValue];
        
        if([spclQus isEqualToString:@""]){
            if(available<1){
                prdtails= [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ProductDetails2"];
                NSLog(@"in no button");
                
            }else{
                prdtails= [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"productdetails"];
                
            }
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

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{

    if([searchText isEqualToString:@""]){
        [self endSearch];
    }
    
    
}
-(void)get_products_by_parent_cateogory_id:(NSString *)product{
    
    NSString *string = [NSString stringWithFormat:@"%@/rest.php?method=get_categories_by_parent_cateogory_id&parent_category_id=%@&application_code=%@",[Data getBaseUrl],product,[Data getAppCode]];
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

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
  
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    UITextField *searchField = [searchBar valueForKey:@"_searchField"];
    
    [searchField resignFirstResponder];
    [overlayButton removeFromSuperview];
    
    
    NSString *string = [NSString stringWithFormat:@"%@/rest.php?method=get_prod_cat_by_search&search_value=%@&application_code=%@",[Data getBaseUrl],searchField.text,[Data getAppCode]];
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // 2
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self parsForSearch:responseObject];
        
        
        
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
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    float y=searchBar.frame.origin.y+searchBar.frame.size.height;
   overlayButton = [[UIButton alloc] initWithFrame:CGRectMake(0, y, 320, self.view.frame.size.height-y)];
    
    overlayButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3f];
    
    [overlayButton addTarget:self action:@selector(hideKeyboard:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:overlayButton];
}

- (void)hideKeyboard:(UIButton *)sender
{
    [self.searchBar resignFirstResponder];
    [sender removeFromSuperview];
}
-(void)parsProductList:(id) respons{
    NSMutableDictionary *dic=(NSMutableDictionary *)respons;
    
    catagoryList=[[dic objectForKey:@"success"]objectForKey:@"categories"];
    productList=[[dic objectForKey:@"success"]objectForKey:@"products"];
    [refreshControl endRefreshing];

    [self.tableView reloadData];

    isSearched=YES;
    [loading StopAnimating];
    loading.hidden=YES;
    
}
-(void)parsForSearch:(id) respons{
    NSMutableDictionary *dic=(NSMutableDictionary *)respons;

    backupCatList=[[NSMutableArray alloc]initWithArray:catagoryList];
    backupproDuctList=[[NSMutableArray alloc]initWithArray:productList];
    
    catagoryList=[[dic objectForKey:@"success"]objectForKey:@"categories"];
    productList=[[dic objectForKey:@"success"]objectForKey:@"products"];
    [refreshControl endRefreshing];
    
    if(catagoryList.count==0&&productList.count==0){
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Not Found" message:@"Nothing foud " delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
        [self endSearch];
        
        
    }else{
        [self.tableView reloadData];
    }

    
    [loading StopAnimating];
    loading.hidden=YES;
}
-(void)endSearch{
    if(backupproDuctList==nil && backupCatList==nil){
        return;
    }
    
    productList=backupproDuctList;
    catagoryList=backupCatList;
    [self.tableView reloadData];
    backupCatList=nil;
    backupproDuctList=nil;
    isSearched=NO;
}

-(IBAction)loginBtn:(id)sender{
    LoginViewController *lvc=[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"loginScreen"];
    [self presentViewController:lvc animated:YES completion:^{}];
    
}
-(IBAction)signupBtn:(id)sender{
    
    SignupViewController *svc=[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"Signup"];
    [self presentViewController:svc animated:YES completion:^{}];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
