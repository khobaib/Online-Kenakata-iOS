//
//  NewArraivalViewController.m
//  kenakata
//
//  Created by MC MINI on 11/9/14.
//  Copyright (c) 2014 OnlineKenakata. All rights reserved.
//

#import "NewArraivalViewController.h"
#import "RateView.h"
#import "TextStyling.h"
#import "Product.h"
#import "UIImageView+WebCache.h"
#import "ProductDetails.h"
#import "AFNetworking.h"
#import "Data.h"
#import "MBProgressHUD.h"

@interface NewArraivalViewController ()

@end

@implementation NewArraivalViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    productList=[[NSMutableArray alloc]init];
    counter=0;
    
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    NSMutableDictionary *dic = [NSKeyedUnarchiver unarchiveObjectWithData:[ud objectForKey:@"get_user_data"]];
    
    currency=[[[dic objectForKey:@"success"]objectForKey:@"user"]objectForKey:@"currency"];
    
    self.navigationItem.title=@"New Arrival";
    [self getNewArraivals];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.collectionView reloadData];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark collection view

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    
    
    return productList.count;
    
    
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"productGrid2" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.layer.shouldRasterize = YES;
    cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    NSMutableDictionary *dic=[productList objectAtIndex:indexPath.row];
    
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





-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    Product *dic = [productList objectAtIndex:indexPath.row];
    
    ProductDetails *prdtails;
    
    prdtails= [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"productDetails3"];
    
    
    
    
    NSMutableDictionary *dic1=[[NSMutableDictionary alloc]init];
    
    dic1[@"product_id"]=dic.ID;
    
    prdtails.productData=dic1;
    prdtails.similarProducrsData=productList;
    [self.navigationController pushViewController:prdtails animated:YES];
    
    
    
    
    
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


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    float endScrolling = scrollView.contentOffset.y + scrollView.frame.size.height;
    if (endScrolling >= scrollView.contentSize.height && counter!=-1)
    {
        counter++;
        [self getNewArraivals];
        
    }
}

-(void)getNewArraivals{
    
    NSString *string = [NSString stringWithFormat:@"%@/rest_kenakata.php?method=get_latest_products&application_code=%@&start=%d",[Data getBaseUrl],[Data getAppCode],counter];
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
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [manager POST:string parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            [self parsProductList:responseObject];
            
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
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
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            [self parsProductList:responseObject];
            
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            // 4
            
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
    
    
    [self.collectionView reloadData];
    
    
}




/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
