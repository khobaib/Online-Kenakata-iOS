//
//  Offers.m
//  OnlineKenakata-Demo
//
//  Created by Rabby Alam on 7/10/14.
//  Copyright (c) 2014 rabbi. All rights reserved.
//

#import "Offers.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "OfferDetail.h"
#import "NewsDetail.h"
#import "Data.h"
#import "TextStyling.h"


@interface Offers ()

@end

@implementation Offers

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    [self initLoading];
    [self addPullToRefresh];
    [self getOffer];
   
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
     self.tabBarController.navigationItem.title=@"Offers";
}
-(void)initLoading{
    CGFloat x= self.view.frame.size.width/2-65;
    CGFloat y =(self.view.frame.size.height-self.navigationController.navigationBar.frame.size.height-self.tabBarController.tabBar.frame.size.height)/2-25;
   // NSLog(@"%f  %f",x,y);
    
    loading=[[LoadingView alloc]initWithFrame:CGRectMake(x, y, 130, 50)];
    loading.hidden=YES;
    [self.view addSubview:loading];
}


-(void)getOffer{
 
    NSString *string = [NSString stringWithFormat:@"%@/rest.php?method=get_offers&application_code=%@",[Data getBaseUrl],[Data getAppCode]];
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
    tableData=[[dic objectForKey:@"success"]objectForKey:@"offers"];
    [self.refreshControl endRefreshing];
    [loading StopAnimating];
    loading.hidden=YES;
    [self.tableView reloadData];
    
   // NSLog(@"%@",tableData);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if(tableData.count==0){
        return 0;
    }
    return tableData.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"offerCell"];
    
    if(tableData.count==0){
        return cell;
    }
        UILabel *offer=(UILabel *)[cell viewWithTag:402];
    UILabel *detail=(UILabel *)[cell viewWithTag:403];
    UIImageView *thumbnil=(UIImageView *)[cell viewWithTag:401];
    
    offer.text=@"";
    detail.text=@"";
    thumbnil.image=nil;
    

    offer.attributedText=[TextStyling AttributForOfferNewsTitle:[[tableData objectAtIndex:indexPath.row]objectForKey:@"name"]];
    

    detail.attributedText=[TextStyling AttributForOfferNewsDescription:[[tableData objectAtIndex:indexPath.row]objectForKey:@"description"]];
    
    
    NSArray *imgArray=[[tableData objectAtIndex:indexPath.row]objectForKey:@"images"];


    if(imgArray.count!=0){
        NSString *imgurl=[[imgArray objectAtIndex:0]objectForKey:@"thumbnail_image_url"];
        
        
        [thumbnil sd_setImageWithURL:[NSURL URLWithString:imgurl]
                 placeholderImage:[UIImage imageNamed:@"placeholder.gif"]];
    }
    
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    

    NSArray *imgArray=[[tableData objectAtIndex:indexPath.row]objectForKey:@"images"];

    if(imgArray.count==0){
     
        NewsDetail *newsDtl=[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"newsOfferDetail"];
        
        NSDictionary *dic = [tableData objectAtIndex:indexPath.row];
        
        
        newsDtl.nameString=[dic objectForKey:@"name"];
        newsDtl.descriptionString=[dic objectForKey:@"description"];
        
        [self.navigationController pushViewController:newsDtl animated:YES];

    }else{
        
        NSMutableDictionary *dic = [tableData objectAtIndex:indexPath.row];
        OfferDetail *ofrdtls = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"offerDetail"];


        ofrdtls.offerData=dic;
        [self.navigationController pushViewController:ofrdtls animated:YES];
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
