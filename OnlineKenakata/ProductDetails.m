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
        [newPageView setImageWithURL:[NSURL URLWithString:[self.pageImages objectAtIndex:page]]
                 placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        
        newPageView.contentMode = UIViewContentModeScaleAspectFit;
        newPageView.frame = frame;
        
        [self.scrollView addSubview:newPageView];
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
    CGSize pagesScrollViewSize = self.scrollView.frame.size;
    self.scrollView.contentSize = CGSizeMake(pagesScrollViewSize.width * self.pageImages.count, pagesScrollViewSize.height);
    
    // 5
    [self loadVisiblePages];
    [self addShareButton];
    
    
}

- (void)setValueOnUI
{
    self.name.text=[self.productData objectForKey:@"name"];
    
    int tag = (int)[[self.productData objectForKey:@"tag"] integerValue];
    if(tag==1){
        self.oldPrice.text=[NSString stringWithFormat:@"%@ %@",currency,[self.productData objectForKey:@"price"]];
    }else if (tag==2){
        
        NSMutableAttributedString *attString=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ %@",currency,[self.productData objectForKey:@"old_price"]]];
        
        [attString addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInt:1] range:NSMakeRange(0,[attString length])];
        self.oldPrice.attributedText = attString;
        
        
        self.priceNew.text=[NSString stringWithFormat:@"%@ %@",currency,[self.productData objectForKey:@"price"]];
        
    }else{
        self.oldPrice.text=[NSString stringWithFormat:@"%@ %@",currency,[self.productData objectForKey:@"price"]];
        
    }
    
    
    NSString *string =[self.productData objectForKey:@"description"];
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
    
    CGRect rect = [string boundingRectWithSize:CGSizeMake(self.productDetails.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    
    [self.productDetails setFrame:rect];
    self.productDetails.text=string;
    int available =[[self.productData objectForKey:@"general_available_quantity"]intValue];
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
        }
    }

    
    
}

- (void)initImageSlider
{
    [self.scrl setContentSize:CGSizeMake(320, 600)];
    [self.scrl setScrollEnabled:YES];
    
    self.pageImages=[[NSMutableArray alloc]init];
    
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
    
    
    
    [self.pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
}

-(void)initOntap{
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
    
    NSMutableDictionary *dic = [ud objectForKey:@"get_user_data"];
    
    currency=[[[dic objectForKey:@"success"]objectForKey:@"user"]objectForKey:@"currency"];
    

   
    [self setValueOnUI];
    
    [self initImageSlider];
    
    [self initOntap];

    // NSLog(@"%@",self.pageImages);
    // Do any additional setup after loading the view.
}

- (IBAction)changePage:(id)sender {
    CGFloat x = self.pageControl.currentPage * self.scrollView.frame.size.width;
    [self.scrollView setContentOffset:CGPointMake(x, 0) animated:YES];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // Load the pages that are now on screen
    [self loadVisiblePages];
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
    browser.displayActionButton = YES; // Show action button to allow sharing, copying, etc (defaults to YES)
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
    UIButton *sharebtn=[[UIButton alloc]initWithFrame:CGRectMake(110, 10, 100, 30)];
    sharebtn.titleLabel.textColor=[UIColor whiteColor];
    [sharebtn setTitle:@"Share" forState:UIControlStateNormal];
    [sharebtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
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

    
       
    share *background = [[share alloc]initWithFrame:CGRectMake(0, 0, 320, 150) actionSheet:action];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dic=[[[ud objectForKey:@"get_user_data"]objectForKey:@"success"]objectForKey:@"user"];
    
    
    //fb twitter
    background.titleName=[NSString stringWithFormat:@"Recommended - %@ , by %@ , Call %@ . Download Online Kenakata (Android/iOS)",self.name.text,[dic objectForKey:@"user_name"],[dic objectForKey:@"user_phone"]];
    background.description=self.productDetails.text;
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
    
   // background.backgroundColor = [UIColor whiteColor];
    
    
    [action addSubview:background];
    
    [action showInView:self.view];
    


}

-(void)setMessanger{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dic=[[[ud objectForKey:@"get_user_data"]objectForKey:@"success"]objectForKey:@"user"];
    
    NSLog(@"protocall");
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    AddToCart *cart=[segue destinationViewController];
    cart.productData=self.productData;
}


@end
