//
//  RecentViewController.m
//  kenakata
//
//  Created by MC MINI on 11/3/14.
//  Copyright (c) 2014 OnlineKenakata. All rights reserved.
//

#import "RecentViewController.h"
#import "RateView.h"
#import "TextStyling.h"
#import "Product.h"
#import "UIImageView+WebCache.h"
#import "ProductDetails.h"
#import "DatabaseHandeler.h"



@interface RecentViewController ()

@end

@implementation RecentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    productList=[[NSMutableArray alloc]init];
    

    productList=[DatabaseHandeler getAllProducts];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    NSMutableDictionary *dic = [NSKeyedUnarchiver unarchiveObjectWithData:[ud objectForKey:@"get_user_data"]];
    
    currency=[[[dic objectForKey:@"success"]objectForKey:@"user"]objectForKey:@"currency"];
    
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    productList=[DatabaseHandeler getAllProducts];
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
   
    
   
    
  
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"productGrid1" forIndexPath:indexPath];
        
        // Configure the cell...
        cell.layer.shouldRasterize = YES;
        cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
        
        Product *dic=[productList objectAtIndex:indexPath.row];
        
        UILabel* productName=(UILabel *)[cell viewWithTag:304];
        UIImageView *thumbnil=(UIImageView *)[cell viewWithTag:301];
        UIImageView *toping=(UIImageView *) [cell viewWithTag:302];
        
        UIImageView *logo=(UIImageView *)[cell viewWithTag:309];
        
        UILabel *oldPrice =(UILabel *)[cell viewWithTag:305];
        UIView *back=[cell viewWithTag:307];
        RateView *starRating=(RateView *)[cell viewWithTag:308];
        
        [self starRaterShow:starRating withView:back starcount:[dic.rating floatValue]];
        
        UILabel *newPrice=(UILabel *) [cell viewWithTag:306];
        UILabel *totalFavorite=(UILabel *)[cell viewWithTag:311];
        
        totalFavorite.text=[NSString stringWithFormat:@"%d",[dic.totalFvt intValue]];
        
        //NSLog(@" %@  %d",[dic objectForKey:@"name"],[[dic objectForKey:@"total_favorites"] intValue]);
        
        if([dic.hasFvt intValue]==1){
            UIImageView *favorite=(UIImageView *)[cell viewWithTag:310];
            
            
            [favorite setImage:[UIImage imageNamed:@"icon_favorite.png"]];
            
        }
    
    
    
        
        
        NSString *key=[NSString stringWithFormat:@"marchent_data_%@",dic.marchantID];
        
        NSString *marchentLogo=[[[NSUserDefaults standardUserDefaults] objectForKey:key]objectForKey:@"logo"];
        
        [logo sd_setImageWithURL:[NSURL URLWithString:marchentLogo]
                placeholderImage:[UIImage imageNamed:@"icon"]];
        //
        productName.text=@"";
        thumbnil.image=nil;
        toping.image=nil;
        oldPrice.text=@"";
        newPrice.text=@"";
    NSString * imgurl = dic.THUMBNAIL_IMAGE_URL;//[[[dic objectForKey:@"images"] objectAtIndex:0]objectForKey:@"thumbnail_image_url"];
        
    NSLog(@"%@",dic.THUMBNAIL_IMAGE_URL);
        productName.attributedText=[TextStyling AttributForTitle:[NSString stringWithFormat:@"%@",dic.name]];
        
        [thumbnil sd_setImageWithURL:[NSURL URLWithString:imgurl]
                    placeholderImage:[UIImage imageNamed:@"bg_grid_image_stub.png"]];
        
        int tag = (int)[dic.PRODUCT_TAG integerValue];
        if(tag==1){
            toping.image=[UIImage imageNamed:@"tag_new.png"];
            
            oldPrice.attributedText=[TextStyling AttributForPrice:[NSString stringWithFormat:@"%@ %@",currency,dic.PRICE]];
        }else if (tag==2){
            toping.image=[UIImage imageNamed:@"tag_sale.png"];
            
            
            oldPrice.attributedText = [TextStyling AttributForPriceStrickThrough:[NSString stringWithFormat:@"%@ %@",currency,dic.OLD_PRICE]];
            
            
            
            newPrice.attributedText=[TextStyling AttributForPrice:[NSString stringWithFormat:@"%@ %@",currency,dic.PRICE]];
            
        }else{
            
            oldPrice.attributedText=[TextStyling AttributForPrice:[NSString stringWithFormat:@"%@ %@",currency,dic.PRICE]];
            
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




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
