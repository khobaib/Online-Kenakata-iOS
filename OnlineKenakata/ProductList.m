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
#import "RateView.h"
#import <QuartzCore/QuartzCore.h>
#import "MBProgressHUD.h"

@interface ProductList ()

@end

@implementation ProductList


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.title=self.catagoryName;
    self.screenName=@"Product List";
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

   
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    productList=[[NSMutableArray alloc]init];
    catagoryList=[[NSMutableArray alloc]init];

    counter =0;
    
    if(loading==nil){
        [self initLoading];
    }
    
    isLoading=NO;
        
    [self get_categories_by_parent_cateogory_id];

    
    
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];

    NSMutableDictionary *dic = [NSKeyedUnarchiver unarchiveObjectWithData:[ud objectForKey:@"get_user_data"]];

    currency=[[[dic objectForKey:@"success"]objectForKey:@"user"]objectForKey:@"currency"];
    
    
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    float endScrolling = scrollView.contentOffset.y + scrollView.frame.size.height;
    if (endScrolling >= scrollView.contentSize.height && counter!=-1)
    {
        counter++;
        isLoading=YES;
        [self.collectionView reloadData];
        [self get_categories_by_parent_cateogory_id];

    }
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
    
  //  self.refreshControl=refreshControl;
    
}

-(void)refresh:(id)sender {
    
    [self get_categories_by_parent_cateogory_id];
}

-(void)get_categories_by_parent_cateogory_id{
    
    if(!isLoading){
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    
    NSString *string = [NSString stringWithFormat:@"%@/rest_kenakata.php?method=get_products_by_tag_id&tag_id=%@&application_code=%@&start=%d",[Data getBaseUrl],self.productId,[Data getAppCode],counter];
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
   // NSLog(@"%@",string);
    // 2
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    NSString *token=(NSString *)[ud objectForKey:@"token"];
    if(token!=nil){
        

        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        NSMutableDictionary *params=[[NSMutableDictionary alloc]init];
        [params setObject:token forKey:@"token"];
        
        [manager POST:string parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            if(!isLoading){
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }
            [self parsProductList:responseObject];
            
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            // 4
            
            if(!isLoading){
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }
            
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error catagory List"
                                                                message:[error localizedDescription]
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
            [alertView show];
        }];

        
        
        
    }else{
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        
        operation.responseSerializer = [AFJSONResponseSerializer serializer];
        
        
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            if(!isLoading){
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }
            [self parsProductList:responseObject];
            
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            // 4
            if(!isLoading){
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error catagory List"
                                                                message:[error localizedDescription]
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
            [alertView show];
        }];
        
        
        [operation start];

    }
    
   
    
    
    // 5
    //  [self.indecator startAnimating];
 
    
    
    
}

-(void)parsProductList:(id) respons{
    NSMutableDictionary *dic=(NSMutableDictionary *)respons;
    

    if(counter==0){
        NSMutableArray *Arraytemp=[[dic objectForKey:@"success"]objectForKey:@"products"];

        [productList addObjectsFromArray:[Arraytemp mutableCopy]];
        if(Arraytemp.count==0||Arraytemp.count%12!=0){
            counter=-1;
        }
        
    }else{
        NSMutableArray *arr=[[dic objectForKey:@"success"]objectForKey:@"products"];
        [productList addObjectsFromArray:[arr mutableCopy]];
        
        if(arr.count==0 || arr.count%12!=0){
            counter=-1;
        }
    }
    
    catagoryList=[[dic objectForKey:@"success"]objectForKey:@"categories"];

    isLoading=NO;
    [self.collectionView reloadData];
  //  [self.refreshControl endRefreshing];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
  [[SDImageCache sharedImageCache] clearMemory];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    

    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
   
    if(isLoading){
      return  productList.count+1;
    }
    
    return productList.count;
    


}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"productGrid" forIndexPath:indexPath];
    
    if(catagoryList.count+productList.count==0){
        return cell;
        
    }
    
    if(isLoading && indexPath.row>=productList.count){
        
        UICollectionViewCell *cell1 = [collectionView dequeueReusableCellWithReuseIdentifier:@"loading" forIndexPath:indexPath];
      
        UIActivityIndicatorView *view=(UIActivityIndicatorView *)[cell1 viewWithTag:221];
        [view startAnimating];
       
        
        return cell1;
    }

    if(indexPath.row>=catagoryList.count){
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"productGrid" forIndexPath:indexPath];
        
        // Configure the cell...
        cell.layer.shouldRasterize = YES;
        cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
        
        NSMutableDictionary *dic=[productList objectAtIndex:indexPath.row-catagoryList.count];
        
        UILabel* productName=(UILabel *)[cell viewWithTag:304];
        UIImageView *thumbnil=(UIImageView *)[cell viewWithTag:301];
        UIImageView *toping=(UIImageView *) [cell viewWithTag:302];
        
        UIImageView *logo=(UIImageView *)[cell viewWithTag:309];
        
        UILabel *oldPrice =(UILabel *)[cell viewWithTag:305];
        UIView *back=[cell viewWithTag:307];
        RateView *starRating=(RateView *)[cell viewWithTag:308];
        
        [self starRaterShow:starRating withView:back starcount:[[dic objectForKey:@"average_rating"]floatValue]];
        
        UILabel *newPrice=(UILabel *) [cell viewWithTag:306];
        UILabel *totalFavorite=(UILabel *)[cell viewWithTag:311];
        
        totalFavorite.text=[NSString stringWithFormat:@"%d",[[dic objectForKey:@"total_favorites"] intValue]];
        
        //NSLog(@" %@  %d",[dic objectForKey:@"name"],[[dic objectForKey:@"total_favorites"] intValue]);

        if([[dic objectForKey:@"has_favorited"]intValue]==1){
            UIImageView *favorite=(UIImageView *)[cell viewWithTag:310];
            

            [favorite setImage:[UIImage imageNamed:@"icon_favorite.png"]];

        }
        
      
        
        NSString *key=[NSString stringWithFormat:@"marchent_data_%@",[dic objectForKey:@"user_id"]];
        
        NSString *marchentLogo=[[[NSUserDefaults standardUserDefaults] objectForKey:key]objectForKey:@"logo"];
     
       
        [logo sd_setImageWithURL:[NSURL URLWithString:marchentLogo]
                placeholderImage:[UIImage imageNamed:@"icon"]];
        //
        productName.text=@"";
        thumbnil.image=nil;
        toping.image=nil;
        oldPrice.text=@"";
        newPrice.text=@"";
        NSString * imgurl = [[[dic objectForKey:@"images"] objectAtIndex:0]objectForKey:@"thumbnail_image_url"];
        
        
        productName.attributedText=[TextStyling AttributForTitle:[NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]]];
        
        [thumbnil sd_setImageWithURL:[NSURL URLWithString:imgurl]
                 placeholderImage:[UIImage imageNamed:@"bg_grid_image_stub.png"]];
        
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
   
    /*
    UILabel * title=(UILabel *)[cell viewWithTag:202];
    UIImageView *thumbnil=(UIImageView* )[cell viewWithTag:201];
    title.text=@"";
    thumbnil.image=nil;
    
    NSMutableDictionary *dic=[catagoryList objectAtIndex:indexPath.row];
    
    
    //  title.text=[dic objectForKey:@"cat_name"];
    title.attributedText=[TextStyling AttributForTitle:[dic objectForKey:@"cat_name"]];
    NSString *imgurl=[NSString stringWithFormat:@"%@",[dic objectForKey:@"thumb_image_url"]];
    
    
    [thumbnil sd_setImageWithURL:[NSURL URLWithString:imgurl]
             placeholderImage:[UIImage imageNamed:@"placeholder.png"]];*/
    
    return cell;
}





-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if(catagoryList.count<=indexPath.row){
    
        NSMutableDictionary *dic = [productList objectAtIndex:indexPath.row];
        
        ProductDetails *prdtails;
       
        int available =[[dic objectForKey:@"add_to_cart"]intValue];
        
       
            if(available<1){
                prdtails= [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"productDetails3"];
               // prdtails.cartBtn.hidden=YES;
                NSLog(@"in no button");
                //productDetails3
            }else{
                prdtails= [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"productDetails3"];
                
            }


        
        
        prdtails.productData=dic;
        prdtails.similarProducrsData=productList;
        [self.navigationController pushViewController:prdtails animated:YES];
        
        
    }else{//productDetails3
        ProductList *pList=[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"productList"];
        NSString *str = [[catagoryList objectAtIndex:indexPath.row]objectForKey:@"cat_id"];
        
        pList.productId=str;
        [self.navigationController pushViewController:pList animated:YES];
    }
    
    
   // [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}




-(void)starRaterShow:(RateView *)starRater withView:(UIView *)starRaterBack starcount:(float) rating{
    
    
    /*
    starRater.starImage=[UIImage imageNamed:@"star.png"];
    starRater.starHighlightedImage=[UIImage imageNamed:@"starhighlighted.png"];
    
   starRater.maxRating = 5.0;
    
    starRater.horizontalMargin = 0;
   starRater.editable=NO;
    starRater.rating= rating;//[[[self.productData objectForKey:@"review_detail"]objectForKey:@"average_rating"] floatValue];
    
    
    starRater.displayMode=EDStarRatingDisplayAccurate;
   [starRater setNeedsDisplay];*/
    
   // starRater.tintColor=[UIColor colorWithRed:(253.0f/255.0f) green:(181.0f/255.0f)blue:(13.0f/255.0f) alpha:1.0f];
    
    starRater.fullSelectedImage=[UIImage imageNamed:@"starhighlighted.png"];
    starRater.notSelectedImage=[UIImage imageNamed:@"star.png"];
    starRater.maxRating=5;
    starRater.rating=rating;
    starRater.editable=NO;
    
    
    [starRaterBack setAlpha:0.50];
   
   
}


#pragma mark sorting functions

-(IBAction)sort:(id)sender{
    RMPickerViewController *pickerVC = [RMPickerViewController pickerController];
    pickerVC.delegate = self;
    [pickerVC show];
    
}


- (void)pickerViewController:(RMPickerViewController *)vc didSelectRows:(NSArray *)selectedRows{

    int i=[[selectedRows objectAtIndex:0]intValue];
    
    if(i==0){
        NSArray *sortDescriptors = [NSArray arrayWithObject:[self getDesctiptorwithkey:@"price" ascending:NO]];
        NSArray *sortedArray;
        sortedArray = [productList sortedArrayUsingDescriptors:sortDescriptors];
        
        productList=[sortedArray mutableCopy];
        [self.collectionView reloadData];
        
    }else if (i==1){
        
        NSArray *sortDescriptors = [NSArray arrayWithObject:[self getDesctiptorwithkey:@"price" ascending:YES]];
        NSArray *sortedArray;
        sortedArray = [productList sortedArrayUsingDescriptors:sortDescriptors];
        
        productList=[sortedArray mutableCopy];
        [self.collectionView reloadData];
        
    }/*else if(i==2){
        
        NSArray *sortDescriptors = [NSArray arrayWithObject:[self getDesctiptorwithkey:@"total_favorites" ascending:NO]];
        NSArray *sortedArray;
        sortedArray = [productList sortedArrayUsingDescriptors:sortDescriptors];
        
        productList=[sortedArray mutableCopy];
        [self.collectionView reloadData];

    }*/else if (i==2){
        NSSortDescriptor *sortDescriptor;
        
        sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"tag" ascending:NO comparator:^(id obj1, id obj2) {
            
            if ([obj1 integerValue] ==1) {
                return (NSComparisonResult)NSOrderedDescending;
            }else{
                return (NSComparisonResult)NSOrderedAscending;
            }
            return (NSComparisonResult)NSOrderedSame;
        }];

        
        NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
        NSArray *sortedArray;
        sortedArray = [productList sortedArrayUsingDescriptors:sortDescriptors];
        
        productList=[sortedArray mutableCopy];
        [self.collectionView reloadData];

        
    }else if (i==3){
        NSArray *sortDescriptors = [NSArray arrayWithObject:[self getDesctiptorwithkey:@"tag" ascending:NO]];
        NSArray *sortedArray;
        sortedArray = [productList sortedArrayUsingDescriptors:sortDescriptors];
        
        productList=[sortedArray mutableCopy];
        [self.collectionView reloadData];
    }
    
    [self.collectionView setContentOffset:CGPointZero animated:NO];
}

-(NSSortDescriptor *)getDesctiptorwithkey:(NSString *)key ascending:(BOOL)bol{
    NSSortDescriptor *sortDescriptor;
    
    sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:key ascending:bol comparator:^(id obj1, id obj2) {
        
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    return sortDescriptor;
}

- (void)pickerViewControllerDidCancel:(RMPickerViewController *)vc{
    
    
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 4;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if(row==0){
        return @"Price - High to Low";
     }
    if(row==1){
        return @"Price - Low to High";
        
    }
    if(row==2){
        return @"Newest First";
    }
    if(row==3){
        return @"Discounts First";
    }
    
    
    return @"Default";
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
