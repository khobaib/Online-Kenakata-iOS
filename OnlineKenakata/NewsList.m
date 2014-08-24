//
//  NewsList.m
//  OnlineKenakata-Demo
//
//  Created by Rabby Alam on 7/10/14.
//  Copyright (c) 2014 rabbi. All rights reserved.
//

#import "NewsList.h"
#import "AFNetworking.h"
#import "NewsDetail.h"
#import "Data.h"
#import "TextStyling.h"

@interface NewsList ()

@end

@implementation NewsList

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)initLoading{
    CGFloat x= self.view.frame.size.width/2-65;
    CGFloat y =(self.view.frame.size.height-self.navigationController.navigationBar.frame.size.height-self.tabBarController.tabBar.frame.size.height)/2-25;
    // NSLog(@"%f  %f",x,y);
    
    loading=[[LoadingView alloc]initWithFrame:CGRectMake(x, y, 130, 50)];
    loading.hidden=YES;
    [self.view addSubview:loading];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.tabBarController.navigationItem.title=@"News";
}
-(void)getOffer{
    
    NSString *string = [NSString stringWithFormat:@"%@/rest.php?method=get_news&application_code=%@",[Data getBaseUrl],[Data getAppCode]];
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // 2
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self parsOfferList:responseObject];
        
        
        
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

- (void)addPullToRefresh
{
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]
                                        init];
    refreshControl.tintColor = [UIColor blackColor];
    
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    
    self.refreshControl=refreshControl;
}
-(void)refresh:(id)sender{
    [self getOffer];
}

-(void)parsOfferList:(id)data{
    
    NSMutableDictionary *dic = (NSMutableDictionary *)data;
    newsData=[[dic objectForKey:@"success"]objectForKey:@"news"];
    [self.refreshControl endRefreshing];
    [loading StopAnimating];
    loading.hidden=YES;
    [self.tableView reloadData];
    
    //NSLog(@"%@",newsData);
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    newsData=[[NSMutableArray alloc]init];
    
    [self initLoading];
    [self addPullToRefresh];
    [self getOffer];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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

    if(newsData.count==0){
        return 0;
    }
    return newsData.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newsCell" forIndexPath:indexPath];
    
    // Configure the cell...
    if(newsData.count==0){
        return cell;
    }
    UILabel *title=(UILabel *)[cell viewWithTag:501];
    UILabel *description=(UILabel *)[cell viewWithTag:502];
    
    title.text=@"";
    description.text=@"";
    

    title.attributedText=[TextStyling AttributForOfferNewsTitle:[[newsData objectAtIndex:indexPath.row]objectForKey:@"news_title"]];
    

    description.attributedText=[TextStyling AttributForOfferNewsDescription:[[newsData objectAtIndex:indexPath.row]objectForKey:@"news_contents"]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NewsDetail *newsDtl=[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"newsOfferDetail"];
    
    NSDictionary *dic = [newsData objectAtIndex:indexPath.row];

    newsDtl.nameString=[dic objectForKey:@"news_title"];
    newsDtl.descriptionString=[dic objectForKey:@"news_contents"];

    
    [self.navigationController pushViewController:newsDtl animated:YES];
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
