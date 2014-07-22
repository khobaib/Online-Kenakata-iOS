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
//#import "Constant.h"


@interface FirstViewController ()

@end

@implementation FirstViewController




- (void)viewDidLoad
{
    [super viewDidLoad];
    tableData=[[NSMutableArray alloc]init];
    
    self.tableView.hidden=YES;
    
    if(loading==nil){
        [self initLoading];

    }
    
    [self initScroller];
    
    NSLog(@"%f",_image.size.width);

    [self addPullToRefresh];
    
    [self get_categories_by_parent_cateogory_id];

    
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
    tableData=[[dic objectForKey:@"success"]objectForKey:@"categories"];
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
    if(tableData.count==0){
        return 1;
    }else{
        return tableData.count;
    }

}


-(void)viewWillAppear:(BOOL)animated{
   [super viewWillAppear:animated];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
 
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellCat"];

    if(tableData.count==0){
        return cell;

    }
    UILabel * title=(UILabel *)[cell viewWithTag:202];
    UIImageView *thumbnil=(UIImageView* )[cell viewWithTag:201];
    
    NSMutableDictionary *dic=[tableData objectAtIndex:indexPath.row];
    title.text=[dic objectForKey:@"cat_name"];
    NSString *imgurl=[NSString stringWithFormat:@"%@",[dic objectForKey:@"thumb_image_url"]];
    
    
    [thumbnil setImageWithURL:[NSURL URLWithString:imgurl]
    placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
     return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableDictionary *dic=[tableData objectAtIndex:indexPath.row];
    ProductList *prdtList=[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"productList"];
    prdtList.productId=[NSString stringWithFormat:@"%@",[dic objectForKey:@"cat_id"]];
    
    [self.navigationController pushViewController:prdtList animated:YES];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
