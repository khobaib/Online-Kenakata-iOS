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
#import "ProductList.h"
#import "Data.h"
#import "TextStyling.h"
#import "ProductDetails.h"
//#import "Constant.h"

#import "LoginViewController.h"
#import "SignupViewController.h"
#import "RateView.h"


@interface FirstViewController ()

@end

@implementation FirstViewController




- (void)viewDidLoad
{
    [super viewDidLoad];
    catagoryList=[[NSMutableArray alloc]init];
    productList=[[NSMutableArray alloc]init];
    self.collectionview.hidden=YES;
    self.searchBar.hidden=YES;
    if(loading==nil){
        [self initLoading];

    }
    
    [self initScroller];
    isSearched=NO;
    NSLog(@"%f",_image.size.width);

    [self addPullToRefresh];
    counter=0;
    searchCounter=0;
    
    [self get_categories_by_parent_cateogory_id];

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
    
    self.collectionview.hidden=NO;
    self.searchBar.hidden=NO;
    self.scrollView.hidden=YES;
    self.signinButton.hidden=YES;
   
    self.tabBarController.navigationItem.title=@"Catalogue";
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    float endScrolling = scrollView.contentOffset.y + scrollView.frame.size.height;
    if (endScrolling >= scrollView.contentSize.height && counter!=-1)
    {
        if(isSearched && searchCounter!=-1){
            searchCounter++;
            [self searchMethod];
            
            return;
        }
        if(!isSearched){
            counter++;
            [self get_categories_by_parent_cateogory_id];
            NSLog(@"start");
        }
        
    }
}


- (void)addPullToRefresh
{
    refreshControl = [[UIRefreshControl alloc]
                      init];
    refreshControl.tintColor = [UIColor blackColor];
    
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    
  //  UITableViewController *tableViewController = [[UITableViewController alloc] init];
    //tableViewController.tableView = self.tableView;
    //tableViewController.refreshControl=refreshControl;
}


-(void)parsCatagoryList:(id)data{

    NSMutableDictionary *dic = (NSMutableDictionary *)data;
    
    if(counter<0){
        NSMutableArray *arr=[[dic objectForKey:@"success"]objectForKey:@"tags"];
        
        [catagoryList addObjectsFromArray:[arr mutableCopy]];
        
        if(arr.count==0 || arr.count%12!=0){
            counter=-1;
        }
        
    }else{
        [catagoryList addObjectsFromArray:[[[dic objectForKey:@"success"]objectForKey:@"tags"] mutableCopy]];

        if(catagoryList.count==0 || catagoryList.count%12!=0){
            counter=-1;
        }
    }
   

    
    

    productList=[[dic objectForKey:@"success"]objectForKey:@"products"];
    [refreshControl endRefreshing];
    [loading StopAnimating];
    loading.hidden=YES;
    [self.collectionview reloadData];
    
    
  
    
    
   // NSLog(@"%@",tableData);
}

-(void)get_categories_by_parent_cateogory_id{
    
    NSString *string = [NSString stringWithFormat:@"%@/rest_kenakata.php?method=get_all_tags&application_code=%@&start=%d",[Data getBaseUrl],[Data getAppCode],counter];
   
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

-(NSInteger )numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{

    
        return catagoryList.count+productList.count;
    

}


-(void)viewWillAppear:(BOOL)animated{
   [super viewWillAppear:animated];
    
    self.tabBarController.navigationItem.title=@"Catalogue";

}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
     NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    NSString *token=(NSString *)[ud objectForKey:@"token"];
    if(token!=nil){
        
        self.signinButton.hidden=YES;

        
    }
      NSLog(@"%@",token);

}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
 
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellGrid" forIndexPath:indexPath];

    


    
    if(indexPath.row>=catagoryList.count){
        
        
        
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellProduct" forIndexPath:indexPath];
        
        // Configure the cell...
        
        
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
    
    
    UILabel * title=(UILabel *)[cell viewWithTag:151];
    UIImageView *thumbnil=(UIImageView* )[cell viewWithTag:150];
    title.text=@"";
    thumbnil.image=nil;
    
    NSMutableDictionary *dic=[catagoryList objectAtIndex:indexPath.row];
    

    
  //  title.text=[dic objectForKey:@"cat_name"];
    title.attributedText=[TextStyling AttributForTitle:[dic objectForKey:@"name"]];
    NSString *imgurl=[NSString stringWithFormat:@"%@",[dic objectForKey:@"image_url"]];

    
    [thumbnil sd_setImageWithURL:[NSURL URLWithString:imgurl]
    placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
     return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
   // NSLog(@"%ld",(long)indexPath.row);
    
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
        NSString *str = [[catagoryList objectAtIndex:indexPath.row]objectForKey:@"id"];
        
        pList.productId=str;
        pList.catagoryName=[[catagoryList objectAtIndex:indexPath.row]objectForKey:@"cat_name"];
        [self.navigationController pushViewController:pList animated:YES];


    }
    
    
 //  [collectionView deselectRowAtIndexPath:indexPath animated:YES];

    
}

- (void)collectionView:(UICollectionView *)colView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell* cell = [colView cellForItemAtIndexPath:indexPath];
 
    //set color with animation
    [UIView animateWithDuration:0.2
                          delay:0
                        options:(UIViewAnimationOptionAllowUserInteraction)
                     animations:^{
                         [cell setBackgroundColor:[UIColor colorWithRed:232/255.0f green:232/255.0f blue:232/255.0f alpha:1]];
                     }
                     completion:nil];
}

- (void)collectionView:(UICollectionView *)colView  didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell* cell = [colView cellForItemAtIndexPath:indexPath];
    //set color with animation
    [UIView animateWithDuration:0.2
                          delay:0
                        options:(UIViewAnimationOptionAllowUserInteraction)
                     animations:^{
                         [cell setBackgroundColor:[UIColor clearColor]];
                     }
                     completion:nil ];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchTextt{

    if([searchTextt isEqualToString:@""]){
        [self endSearch];
    }
    
    
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

- (void)searchMethod {
    [overlayButton removeFromSuperview];
    
    isSearched=YES;
    NSString *string = [NSString stringWithFormat:@"%@/rest_kenakata.php?method=get_prod_tag_by_search&search_value=%@&start=%d&application_code=%@",[Data getBaseUrl],searchText,searchCounter,[Data getAppCode]];
    
    NSURL *url = [NSURL URLWithString:[string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // 2
    
    NSLog(@"%@",string);
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

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    UITextField *searchField = [searchBar valueForKey:@"_searchField"];
    searchText=searchField.text;
    
    [searchField resignFirstResponder];
    [self searchMethod];
    
    


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

    [self.collectionview reloadData];

    isSearched=YES;
    [loading StopAnimating];
    loading.hidden=YES;
    
}
-(void)parsForSearch:(id) respons{
    NSMutableDictionary *dic=(NSMutableDictionary *)respons;

    if(searchCounter==0){
        backupCatList=[[NSMutableArray alloc]initWithArray:catagoryList];
        backupproDuctList=[[NSMutableArray alloc]initWithArray:productList];
        
        catagoryList=[[[[dic objectForKey:@"success"]objectForKey:@"user" ] objectForKey:@"tags"] mutableCopy];
        productList=[[[[dic objectForKey:@"success"]objectForKey:@"user" ] objectForKey:@"products"] mutableCopy];
        
        if(productList.count==0 || productList.count%12!=0){
            searchCounter=-1;
        }
        
        
    }else{
        [catagoryList addObjectsFromArray:[[[[dic objectForKey:@"success"]objectForKey:@"user" ] objectForKey:@"tags"] mutableCopy]];
        [productList addObjectsFromArray:[[[[dic objectForKey:@"success"]objectForKey:@"user" ] objectForKey:@"products"] mutableCopy]];
        
        if(productList.count==0 || productList.count%12!=0){
            searchCounter=-1;
        }
        
    
    }
    
    
    NSLog(@" %lu %lu",(unsigned long)productList.count,(unsigned long)catagoryList.count);
    
   
    
    [refreshControl endRefreshing];

    if(catagoryList.count==0&&productList.count==0){
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Not Found" message:@"Nothing foud " delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
        [self endSearch];
        
        
    }else{
        [self.collectionview reloadData];
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
    [self.collectionview reloadData];
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
