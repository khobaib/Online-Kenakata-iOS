//
//  ProductDetails.m
//  OnlineKenakata-Demo
//
//  Created by Rabby Alam on 7/9/14.
//  Copyright (c) 2014 rabbi. All rights reserved.
//

#import "ProductDetails.h"
#import "UIImageView+WebCache.h"
#import "share.h"
#import "AddToCart.h"
#import "MBProgressHUD.h"
#import "TextStyling.h"
#import "Review.h"
#import "AFNetworking.h"
#import "Data.h"
#import "LoginViewController.h"
#import "DatabaseHandeler.h"
#import "Product.h"
@interface ProductDetails ()

@end

@implementation ProductDetails

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)loadPage:(NSInteger)page {
    if (page < 0 || page >= self.pageImages.count) {
        // If it's outside the range of what you have to display, then do nothing
        return;
    }
    
    // 1
    UIView *pageView = [self.pageViews objectAtIndex:page];
    if ((NSNull*)pageView == [NSNull null]) {
        // 2
        CGRect frame = self.scrollView.bounds;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0.0f;
        
        // 3
        UIImageView *newPageView = [[UIImageView alloc] init];
        [newPageView setFrame:CGRectMake(4, 4, frame.size.width-18, frame.size.height-18)];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:newPageView animated:YES];
        hud.labelText = @"Loading";
        
        
        
        [newPageView sd_setImageWithURL:[NSURL URLWithString:[self.pageImages objectAtIndex:page]]
                    placeholderImage:[UIImage imageNamed:@"placeholder.png"]
                           completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType,NSURL *imageURL) {
                               
                               [hud hide:YES];
                               
                               
                           }];
        
       
        //newPageView.contentMode = UIViewContentModeScaleAspectFit;
        
        
        
        
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(frame.origin.x+5, frame.origin.y+5, frame.size.width-10, frame.size.height-10)];
        UIColor *color=[UIColor whiteColor]; //[UIColor colorWithRed:0.75f  green:0.75f blue:0.75f alpha:1.0f];
        
      
        
        
        
        [view setBackgroundColor:color];
        
        [view addSubview:newPageView];
        [self.scrollView addSubview:view];
        
        FBLikeControl *like = [[FBLikeControl alloc] init];
        like.objectID =[self.pageImages objectAtIndex:page];
        [self.scrollView addSubview:like];
        // 4
        [self.pageViews replaceObjectAtIndex:page withObject:newPageView];
    }
}


- (void)purgePage:(NSInteger)page {
    if (page < 0 || page >= self.pageImages.count) {
        // If it's outside the range of what you have to display, then do nothing
        return;
    }
    
    // Remove a page from the scroll view and reset the container array
    UIView *pageView = [self.pageViews objectAtIndex:page];
    if ((NSNull*)pageView != [NSNull null]) {
        [pageView removeFromSuperview];
        [self.pageViews replaceObjectAtIndex:page withObject:[NSNull null]];
    }
}

- (void)loadVisiblePages {
    // First, determine which page is currently visible
    CGFloat pageWidth = self.scrollView.frame.size.width;
    NSInteger page = (NSInteger)floor((self.scrollView.contentOffset.x * 2.0f + pageWidth) / (pageWidth * 2.0f));

    // Update the page control
    self.pageControl.currentPage = page;
    
    // Work out which pages you want to load
    NSInteger firstPage = page - 1;
    NSInteger lastPage = page + 1;
    
    // Purge anything before the first page
    for (NSInteger i=0; i<firstPage; i++) {
        [self purgePage:i];
    }
    
	// Load pages in our range
    for (NSInteger i=firstPage; i<=lastPage; i++) {
        [self loadPage:i];
    }
    
	// Purge anything after the last page
    for (NSInteger i=lastPage+1; i<self.pageImages.count; i++) {
        [self purgePage:i];
    }
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 4
 

    [self addShareButton];
    
}

- (void)setValueOnUI
{
    self.name.attributedText=[TextStyling AttributForTitle:[self.productData objectForKey:@"name"]];
    
    [self.cartBtn setBackgroundColor:[TextStyling appColor]];
    
    int tag = (int)[[self.productData objectForKey:@"tag"] integerValue];
    if(tag==1){
        
        
        self.oldPrice.attributedText=[TextStyling AttributForPrice:[NSString stringWithFormat:@"%@ %@",currency,[self.productData objectForKey:@"price"]]];
    }else if (tag==2){
        
        self.oldPrice.attributedText = [TextStyling AttributForPriceStrickThrough:[NSString stringWithFormat:@"%@ %@",currency,[self.productData objectForKey:@"old_price"]]];
        
        
        self.priceNew.attributedText=[TextStyling AttributForPrice:[NSString stringWithFormat:@"%@ %@",currency,[self.productData objectForKey:@"price"]]];
    }else{
        
        self.oldPrice.attributedText=[TextStyling AttributForPrice:[NSString stringWithFormat:@"%@ %@",currency,[self.productData objectForKey:@"price"]]];
        
    }
    

    self.favoritNumber.text=[NSString stringWithFormat:@"%d",[[self.productData objectForKey:@"total_favorites"] intValue]];
    
    
    NSString *key=[NSString stringWithFormat:@"marchent_data_%@",[self.productData objectForKey:@"user_id"]];
    
    NSString *marchentLogo=[[[NSUserDefaults standardUserDefaults] objectForKey:key]objectForKey:@"logo"];
    
    [self.logoImageView sd_setImageWithURL:[NSURL URLWithString:marchentLogo]
            placeholderImage:[UIImage imageNamed:@"icon"]];
    

    if([[self.productData objectForKey:@"has_favorited"]intValue]==1){
        [self.favButton setImage:[UIImage imageNamed:@"icon_favorite.png"] forState:UIControlStateNormal];
        favFlag=YES;
    }
    
    //NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
    
    //CGRect rect = [string boundingRectWithSize:CGSizeMake(self.productDetails.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    

   // NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
    
   // CGRect rect = [string boundingRectWithSize:CGSizeMake(self.productDetails.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];

    
    //[self.productDetails setFrame:rect];

    NSString *string ;
    if([self.productData objectForKey:@"description"]==[NSNull null]){
        string=@"Not Available";
    }else{
        string=[self.productData objectForKey:@"description"];
    }


    
    [self.productDetails setScrollEnabled:YES];
    [self.productDetails setAttributedText:[TextStyling AttributForDescription:string]];
    [self.productDetails sizeToFit];
    [self.productDetails setScrollEnabled:NO];
    
    [self frameUpdateFrom:self.productDetails To:self.itemCodeLable];
    [self frameUpdateFrom:self.productDetails To:self.itemCode];
    [self frameUpdateFrom:self.itemCodeLable To:self.similarProductLable];
    [self frameUpdateFrom:self.similarProductLable To:self.collectionView];
    
    
    int available =[[self.productData objectForKey:@"add_to_cart"]intValue];
    

    if(available>0){
        self.itemCode.text=[self.productData objectForKey:@"sku"];
        
    }else{
        self.itemCode.hidden=YES;
        self.itemCodeLable.hidden=YES;
    }
    NSString *spclQus=[self.productData objectForKey:@"special_question"];
    if([spclQus isEqualToString:@""]){
        if(available<1){
            self.cartBtn.hidden=YES;
            
            
            
            [UIView animateWithDuration:0.1 animations:^{
                CGRect f = self.scrl.frame;
                f.size.height = 350;//0.0f+self.navigationController.navigationBar.frame.size.height+20;
                self.scrl.frame = f;
            }];
            
        }
    }

   // NSLog(@"item code %f  detail %f",self.itemCode.frame.origin.y,self.productDetails.frame.origin.y);
    
}


-(void)TapOnMarchentLogo:(id)sender{

    NSString *key=[NSString stringWithFormat:@"marchent_data_%@",[self.productData objectForKey:@"user_id"]];
    NSDictionary *mDic=[[NSUserDefaults standardUserDefaults] objectForKey:key];
    
    NSString *name = [NSString stringWithFormat:@"Merchant Info:%@",[mDic objectForKey:@"user_name"]];
    NSString *detail=[NSString stringWithFormat:@"Phone:%@\nE-mail:%@\nAddress:%@\nDelivery charge:%@",[mDic objectForKey:@"user_phone"],[mDic objectForKey:@"email_address"],[mDic objectForKey:@"user_address"],[mDic objectForKey:@"delivery_charge"]];
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:name message:detail delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles: nil];
    
    [alert show];
    

}

-(void)frameUpdateFrom:(UIView *)from To:(UIView *)to{
    CGRect frame=to.frame;
    frame.origin.y=from.frame.origin.y+from.frame.size.height+10;
    
    
    [to setFrame:frame];
    

}
- (void)initImageSlider
{
    [self.scrl setContentSize:CGSizeMake(320, 600)];
    [self.scrl setScrollEnabled:YES];
    self.pageControl.layer.cornerRadius=7;
    self.pageImages=[[NSMutableArray alloc]init];
    self.similarProductPage=[[NSMutableArray alloc]init];
    
    NSMutableArray *images=[self.productData objectForKey:@"images"];
    
    for(int i=0;i<images.count;i++){
        NSString *url=[[images objectAtIndex:i]objectForKey:@"image_url"];
        [self.pageImages addObject:url];
    }
    
    self.pageControl.currentPage=0;
    self.pageControl.numberOfPages=self.pageImages.count;
    
    self.pageViews = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < self.pageImages.count; ++i) {
        [self.pageViews addObject:[NSNull null]];
    }
    for(NSInteger i = 0;i<self.similarProducrsData.count;++i){
        [self.similarProductPage addObject:[NSNull null]];
    }
    
    
    [self.pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
}

-(void)initOntap{
    
    UITapGestureRecognizer *logoTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TapOnMarchentLogo:)];
    logoTap.numberOfTapsRequired=1;
    [self.logoImageView addGestureRecognizer:logoTap];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    singleTap.numberOfTapsRequired = 1;
    [self.scrollView addGestureRecognizer:singleTap];
    
   
    
    
  
}
-(void)onTap: (UIGestureRecognizer *)recognizer{
    [self openImageViewer];

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    NSMutableDictionary *dic = [NSKeyedUnarchiver unarchiveObjectWithData:[ud objectForKey:@"get_user_data"]];;
    
    currency=[[[dic objectForKey:@"success"]objectForKey:@"user"]objectForKey:@"currency"];
    
    favFlag=NO;
    self.similarProducrsData=[[NSMutableArray alloc]init];
    [self initLoading];

    [self loadData];
    
    // NSLog(@"%@",self.pageImages);
    // Do any additional setup after loading the view.
}


-(IBAction)favButtonPressed:(id)sender{
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    NSString *token=(NSString *)[ud objectForKey:@"token"];
    if(token!=nil){
        if(favFlag){
            int count=[self.favoritNumber.text intValue];
            count--;
            self.favoritNumber.text=[NSString stringWithFormat:@"%d",count];
            [self.favButton setImage:[UIImage imageNamed:@"icon_unfavorite.png"] forState:UIControlStateNormal];
            
            [self updateFav:[NSNumber numberWithInt:0] forToken:token];
            
        }else{
            int count=[self.favoritNumber.text intValue];
            count++;
            self.favoritNumber.text=[NSString stringWithFormat:@"%d",count];
            [self.favButton setImage:[UIImage imageNamed:@"icon_favorite.png"] forState:UIControlStateNormal];
            
            [self updateFav:[NSNumber numberWithInt:1] forToken:token];
            
        }
        favFlag=!favFlag;
        
    }else{
        
        LoginViewController *loginVC=[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"loginScreen"];
        
        [self.navigationController pushViewController:loginVC animated:YES];
    }
   
}

-(void)updateFav:(NSNumber *)fav forToken:(NSString *)token{
    NSMutableDictionary *params=[[NSMutableDictionary alloc]init];
    [params setObject:token forKey:@"token"];
    [params setObject:[self.productData objectForKey:@"product_id"] forKey:@"product_id"];
    [params setObject:fav forKey:@"favorited"];
    
    
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSString *str=[NSString stringWithFormat:@"%@/rest.php?method=favorites&application_code=%@",[Data getBaseUrl],[Data getAppCode]];
    
  //  NSLog(@"%@",str);
    
    [manager POST:str parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dic1=(NSDictionary *)responseObject;
        
        if([[dic1 objectForKey:@"success"] isEqualToString:@"ok"]){
           
        
        }else{
            if(favFlag){
                int count=[self.favoritNumber.text intValue];
                count--;
                self.favoritNumber.text=[NSString stringWithFormat:@"%d",count];
                [self.favButton setImage:[UIImage imageNamed:@"icon_unfavorite.png"] forState:UIControlStateNormal];
            }else{
                int count=[self.favoritNumber.text intValue];
                count++;
                self.favoritNumber.text=[NSString stringWithFormat:@"%d",count];
                [self.favButton setImage:[UIImage imageNamed:@"icon_favorite.png"] forState:UIControlStateNormal];
                
            }
            favFlag=!favFlag;

        }
       // NSLog(@"JSON: %@", responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       
    }];
    
}

-(void)loadData{
    
    NSString *string = [NSString stringWithFormat:@"%@/rest_kenakata.php?method=get_products_by_product_ids&product_ids=%@&application_code=%@",[Data getBaseUrl],[self.productData objectForKey:@"product_id"],[Data getAppCode]];
    
    
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    
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
            [self parsProducts:responseObject];
            
            
            
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

            [self parsProducts:responseObject];
            
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];

          
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error catagory List"
                                                                message:[error localizedDescription]
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
            [alertView show];
        }];
        
        
        [operation start];
        
    }
    
}
-(void)parsProducts:(id)respons{
    [loading StopAnimating];
    loading.hidden=YES;
    NSMutableDictionary *dic1=(NSMutableDictionary *)respons;
    self.productData=[[[dic1 objectForKey:@"success"]objectForKey:@"products"]objectAtIndex:0];
    self.similarProducrsData=[self.productData objectForKey:@"similar_products"];
    

    [self starRaterShow];
    
   // NSLog(@"%@",self.productData);
    // 5
    
    
    [self initImageSlider];
    
    [self initOntap];
    
    CGSize pagesScrollViewSize = self.scrollView.frame.size;
    self.scrollView.contentSize = CGSizeMake(pagesScrollViewSize.width * self.pageImages.count, pagesScrollViewSize.height);
    
    
   // self.horizontalScroller.contentSize=CGSizeMake(120*self.similarProducrsData.count, self.horizontalScroller.frame.size.height);

    [self loadVisiblePages];
    
    //[self loadVisibleSimilarProduct];
    [self setValueOnUI];
    [self saveProduct];

    [self.collectionView reloadData];

    
}




-(void)starRaterShow{
    
    
    self.starRater.fullSelectedImage=[UIImage imageNamed:@"starhighlighted.png"];
    self.starRater.notSelectedImage=[UIImage imageNamed:@"star.png"];
    self.starRater.maxRating=5;
    
    self.starRater.editable=NO;
    self.starRater.rating= [[self.productData objectForKey:@"average_rating"] floatValue];

    
    [self.starRater setNeedsDisplay];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ratingShow)];
    tap.numberOfTapsRequired=1;
    [self.starRater addGestureRecognizer:tap];
    [self.starRaterBack setAlpha:0.40];
    
    [self.starRaterBack.layer setCornerRadius:5.0f];
    
    // border
    [self.starRaterBack.layer setBorderColor:[UIColor grayColor].CGColor];
    [self.starRaterBack.layer setBorderWidth:1.5f];
    
    // drop shadow
    [self.starRaterBack.layer setShadowColor:[UIColor blackColor].CGColor];
    [self.starRaterBack.layer setShadowOpacity:0.6];
    [self.starRaterBack.layer setShadowRadius:3.0];
    [self.starRaterBack.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    

    /*
    NSMutableDictionary *arr=[[self.productData objectForKey:@"review_detail"]objectForKey:@"distribution"];
    int total=0;
    
    if(arr==nil){
        return;
    }
    for(int i=0;i<arr.count;i++){
        total+=[[arr objectForKey:[NSString stringWithFormat:@"%d",i]]intValue];
    }
    self.reviewNumber.text=[NSString stringWithFormat:@"%d Reviews",total];*/
}
-(void)ratingShow{

    Review *review=[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"CustomerReviews"];
    
    review.productID=[self.productData objectForKey:@"product_id"];
    [self.navigationController pushViewController:review animated:YES];
}

- (IBAction)changePage:(id)sender {
    CGFloat x = self.pageControl.currentPage * self.scrollView.frame.size.width;
    [self.scrollView setContentOffset:CGPointMake(x, 0) animated:YES];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // Load the pages that are now on screen
    if(scrollView.tag==2){
        [self loadVisiblePages];

    }else{
        [self loadVisibleSimilarProduct];
    }
}
-(IBAction)imageEnlarge:(id)sender{
    [self openImageViewer];
    
}
-(void)openImageViewer{
    
    NSMutableArray *images=[self.productData objectForKey:@"images"];
    photos=[[NSMutableArray alloc] init];
    for(int i=0;i<images.count;i++){
        NSString *url=[[images objectAtIndex:i]objectForKey:@"image_url"];

        [photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString: url]]];

    }

    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    
    // Set options
    browser.displayActionButton = NO; // Show action button to allow sharing, copying, etc (defaults to YES)
    browser.displayNavArrows = YES; // Whether to display left and right nav arrows on toolbar (defaults to NO)
    browser.displaySelectionButtons = NO; // Whether selection buttons are shown on each image (defaults to NO)
    browser.zoomPhotosToFill = YES; // Images that almost fill the screen will be initially zoomed to fill (defaults to YES)
    browser.alwaysShowControls = NO; // Allows to control whether the bars and controls are always visible or whether they fade away to show the photo full (defaults to NO)
    browser.enableGrid = YES; // Whether to allow the viewing of all the photo thumbnails on a grid (defaults to YES)
    browser.startOnGrid = NO; // Whether to start on the grid of thumbnails instead of the first photo (defaults to NO)
     // iOS 5 & 6 only: Decide if you want the photo browser full screen, i.e. whether the status bar is affected (defaults to YES)
    
    // Optionally set the current visible photo before displaying
    [browser setCurrentPhotoIndex:self.pageControl.currentPage];
    
    // Present
    [self.navigationController pushViewController:browser animated:YES];

    
}

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < photos.count)
        return [photos objectAtIndex:index];
    return nil;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)addShareButton{
    UIButton *sharebtn=[TextStyling sharebutton];

    [sharebtn addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];

    sharebtn.hidden=NO;
   // [self.navigationController.navigationBar addSubview:sharebtn];
    self.navigationItem.titleView=sharebtn;
    
    //[self.navigationItem.titleView addSubview:sharebtn];
}
-(void)shareButtonClick:(id)sender{
    UIActionSheet * action = [[UIActionSheet alloc]
                              initWithTitle:@"Share"
                              delegate:nil
                              cancelButtonTitle:@"Cancel"
                              destructiveButtonTitle:nil
                              otherButtonTitles:@"",nil];

    
   // UIAlertController *alert=[UIAlertController al]
       
    share *background = [[share alloc]initWithFrame:CGRectMake(0, 0, 320, 150) actionSheet:action];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dic1=[NSKeyedUnarchiver unarchiveObjectWithData:[ud objectForKey:@"get_user_data"]];
    
    
    NSMutableDictionary *dic=[[dic1 objectForKey:@"success"]objectForKey:@"user"];
    
    
    //fb twitter
    background.titleName=[NSString stringWithFormat:@"Recommended - %@ , by %@ , Call %@ . Download Online Kenakata (Android/iOS)",self.name.text,[dic objectForKey:@"user_name"],[dic objectForKey:@"user_phone"]];
    background.descriptionText=self.productDetails.text;
    NSString *imageURL=[[[self.productData objectForKey:@"images"]objectAtIndex:0]objectForKey:@"image_url"];
    background.url=imageURL;
    background.viewController=self;
    background.caption=@"";
    background.imageUrl=@"";
    background.delegate=self;
    
    //email
    background.emailBody=[NSString stringWithFormat:@"%@ \n%@ .\nDownload Online Kenakata (Android/iOS)",self.productDetails.text,imageURL];
    background.emailSub=[NSString stringWithFormat:@"Recommended - %@ , by %@ , Call %@ ",self.name.text,[dic objectForKey:@"user_name"],[dic objectForKey:@"user_phone"]];
    
   // background.image=
    //NSLog(@"%@",background.caption);
    
    background.backgroundColor = [UIColor whiteColor];
    
    
    [action addSubview:background];
    
    [action showInView:self.view];
    


}

-(void)setMessanger{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    NSMutableDictionary *dic1=[NSKeyedUnarchiver unarchiveObjectWithData:[ud objectForKey:@"get_user_data"]];
    NSMutableDictionary *dic=[[dic1 objectForKey:@"success"]objectForKey:@"user"];
    
   // NSLog(@"protocall");
    if(![MFMessageComposeViewController canSendText]) {
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warningAlert show];
        return;
    }
    
  //  NSArray *recipents = @[@"12345678", @"72345524"];
    NSString *message = [NSString stringWithFormat:@"Recommended - %@ , %@ , %@ .Download Online Kenakata (Android/iOS)",self.name.text,[dic objectForKey:@"user_name"],[dic objectForKey:@"user_phone"]];
    
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    //  [messageController setRecipients:recipents];
    [messageController setBody:message];
    
    // Present message view controller on screen
    [self presentViewController:messageController animated:YES completion:nil];
}
-(IBAction)TapHandlerMethod:(id)sender{
    [TextStyling Handle];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{
    switch (result) {
        case MessageComposeResultCancelled:
            break;
            
        case MessageComposeResultFailed:
        {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to send SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
            break;
        }
            
        case MessageComposeResultSent:
            break;
            
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)callButton:(id)sender{
  
    NSString *key=[NSString stringWithFormat:@"marchent_data_%@",[self.productData objectForKey:@"user_id"]];
   NSMutableDictionary *dic=[[ NSUserDefaults standardUserDefaults] objectForKey:key];
    
    NSString *phoneNumber = [@"telprompt://" stringByAppendingString:[dic objectForKey:@"user_phone"]];
    NSString *deviceType = [UIDevice currentDevice].model;
    //  NSLog(@"%@",deviceType);
    
    
    NSLog(@"%@",phoneNumber);
    
    if([deviceType isEqualToString:@"iPhone"]){
        
        NSLog(@"make call");
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"your device doesnt support calling"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
    }

}

-(IBAction)AddTocart:(id)sender{

    NSString *spclQus=[self.productData objectForKey:@"special_question"];

    AddToCart *cart;
    if([spclQus isEqualToString:@""]){
        cart=[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"addToCart4"];

    }else{
       cart=[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"addToCart4"];

    }
    cart.productData=self.productData;
    [self.navigationController pushViewController:cart animated:YES];
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
/*
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    AddToCart *cart=[segue destinationViewController];
    cart.productData=self.productData;
}

*/

#pragma mark -Save product

-(void)saveProduct{
    Product *product=[[Product alloc]init];
    
    product.ID=self.productData[@"product_id"];
    product.name=self.productData[@"name"];
    product.IMAGE_URL=self.productData[@"image_url"];
    product.THUMBNAIL_IMAGE_URL=[[self.productData[@"images"]objectAtIndex:0]objectForKey:@"thumbnail_image_url"];
    product.PRICE=self.productData[@"price"];
    product.OLD_PRICE=self.productData[@"old_price"];
    product.PRODUCT_TAG=self.productData[@"tag"];
    product.marchantID=self.productData[@"user_id"];
    product.ITEM_CODE=self.productData[@"sku"];
    product.totalFvt=self.productData[@"total_favorites"];
    product.hasFvt=self.productData[@"has_favorited"];
    product.rating=self.productData[@"average_rating"];
    
    if([DatabaseHandeler insertRecentProduct:product]){
       
    }
}

#pragma mark -Similar product with collection view

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    
    
    return self.similarProducrsData.count;
    
    
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"productGrid" forIndexPath:indexPath];
    
    if(self.similarProducrsData.count==0){
        return cell;
        
    }
    
   
    
        // Configure the cell...
        cell.layer.shouldRasterize = YES;
        cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
        
        NSMutableDictionary *dic=[self.similarProducrsData objectAtIndex:indexPath.row];
        
        UILabel* productName=(UILabel *)[cell viewWithTag:304];
        UIImageView *thumbnil=(UIImageView *)[cell viewWithTag:301];
        UIImageView *toping=(UIImageView *) [cell viewWithTag:302];
        
    
        
        UILabel *oldPrice =(UILabel *)[cell viewWithTag:305];
    
    
        UILabel *newPrice=(UILabel *) [cell viewWithTag:306];
    
    
        //NSLog(@" %@  %d",[dic objectForKey:@"name"],[[dic objectForKey:@"total_favorites"] intValue]);
    
        
        
                      //
        productName.text=@"";
        thumbnil.image=nil;
        toping.image=nil;
        oldPrice.text=@"";
        newPrice.text=@"";
        NSString * imgurl = [dic objectForKey:@"thumbnail_image_url"] ;
        
        
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
    
}





-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
  
        
        NSMutableDictionary *dic = [self.similarProducrsData objectAtIndex:indexPath.row];
        
        ProductDetails *prdtails;
        
        int available =[[dic objectForKey:@"add_to_cart"]intValue];
        
        
        if(available<1){
            prdtails= [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"productDetails3"];
          //  prdtails.cartBtn.hidden=YES;
            NSLog(@"in no button");
            //productDetails3
        }else{
            prdtails= [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"productDetails3"];
            
        }
        
        
        
        
        prdtails.productData=dic;
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




#pragma mark -HorizentalSlider


-(void)initLoading{
    CGFloat x= self.view.frame.size.width/2-65;
    CGFloat y =(self.view.frame.size.height-self.navigationController.navigationBar.frame.size.height-self.tabBarController.tabBar.frame.size.height)/2-25;
    
    loading=[[LoadingView alloc]initWithFrame:CGRectMake(x, y, 130, 50)];
    loading.hidden=YES;
    [self.view addSubview:loading];
}


- (void)loadSimilarProduct:(NSInteger)page {
    if (page < 0 || page >= self.similarProducrsData.count) {
        // If it's outside the range of what you have to display, then do nothing
        return;
    }
    
    // 1
    UIView *pageView = [self.similarProductPage objectAtIndex:page];
    if ((NSNull*)pageView == [NSNull null]) {
        // 2
        CGRect frame =CGRectMake(120*page, 0.0, 120, 140);
       
        
        // 3
        UIImageView *newPageView = [[UIImageView alloc] init];
        [newPageView setFrame:CGRectMake(4, 4, 110,90)];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:newPageView animated:YES];
        hud.labelText = @"Loading";
        
        NSString *string=[[self.similarProducrsData objectAtIndex:page]objectForKey:@"thumbnail_image_url"];
        

        [newPageView sd_setImageWithURL:[NSURL URLWithString:string]
                       placeholderImage:[UIImage imageNamed:@"placeholder.png"]
                              completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType,NSURL *imageURL) {
                                  
                                  [hud hide:YES];
                                  
            }];
       
        
        //newPageView.contentMode = UIViewContentModeScaleAspectFit;
        
        if(newPageView.image==nil){
            newPageView.image=[UIImage imageNamed:@"no_photo.png"];
        }
        UILabel *lable=[[UILabel alloc]initWithFrame:CGRectMake(4, 95, 110, 40)];
        lable.text=[[self.similarProducrsData objectAtIndex:page]objectForKey:@"name"];
        lable.numberOfLines=2;
        [lable setFont:[UIFont systemFontOfSize:12]];
        lable.textAlignment=NSTextAlignmentCenter;
       // lable.textColor=[UIColor whiteColor];
        lable.backgroundColor=[UIColor whiteColor];
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(frame.origin.x+5, frame.origin.y+5, frame.size.width-10, frame.size.height-10)];
      //  UIColor *color= [UIColor colorWithRed:(78.0/255.0)  green:(46.0/255.0) blue:(40.0/255.0) alpha:1.0f];
        
        
        
        //[view setBackgroundColor:[TextStyling appColor]];
        
        [view addSubview:newPageView];
        [view addSubview:lable];
    
        view.tag=page;
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(similarProductTap:)];
        singleTap.numberOfTapsRequired = 1;
        
        [view addGestureRecognizer:singleTap];
        [self.horizontalScroller addSubview:view];
        // 4
        [self.similarProductPage replaceObjectAtIndex:page withObject:view];
    }
}


-(void)similarProductTap:(id)sender{
    
    UITapGestureRecognizer *tap=(UITapGestureRecognizer *)sender;
    
    UIView *view=tap.view;
    NSMutableDictionary *dic = [self.similarProducrsData objectAtIndex:view.tag];
    
    ProductDetails *prdtails;
            prdtails= [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"productDetails3"];
        
    
    
    prdtails.productData=dic;
    prdtails.similarProducrsData=self.similarProducrsData;
    [self.navigationController pushViewController:prdtails animated:YES];
    

}

- (void)purgeSimilarProduct:(NSInteger)page {
    if (page < 0 || page >= self.similarProducrsData.count) {
        // If it's outside the range of what you have to display, then do nothing
        return;
    }
    
    // Remove a page from the scroll view and reset the container array
    UIView *pageView = [self.similarProductPage objectAtIndex:page];
    if ((NSNull*)pageView != [NSNull null]) {
        [pageView removeFromSuperview];
        [self.similarProductPage replaceObjectAtIndex:page withObject:[NSNull null]];
    }
}

- (void)loadVisibleSimilarProduct {
    // First, determine which page is currently visible
    CGFloat pageWidth = self.horizontalScroller.frame.size.width;
    NSInteger page = (NSInteger)floor((self.horizontalScroller.contentOffset.x * 2.0f + pageWidth) / (pageWidth * 2.0f));
    
    // Update the page control
    
    // Work out which pages you want to load
    NSInteger firstPage = page - 1;
    NSInteger lastPage = page + 1;
    
    // Purge anything before the first page
    for (NSInteger i=0; i<firstPage; i++) {
        //[self purgeSimilarProduct:i];
    }
    
	// Load pages in our range
    for (NSInteger i=0; i<=self.similarProducrsData.count; i++) {
        [self loadSimilarProduct:i];
    }
    
	// Purge anything after the last page
    for (NSInteger i=lastPage+1; i<self.pageImages.count; i++) {
        //[self purgeSimilarProduct:i];
    }
}



@end
