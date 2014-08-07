//
//  OfferDetail.m
//  OnlineKenakata-Demo
//
//  Created by Rabby Alam on 7/10/14.
//  Copyright (c) 2014 rabbi. All rights reserved.
//

#import "OfferDetail.h"
#import "UIImageView+WebCache.h"
#import "Libraries/MBProgressHUD/MBProgressHUD.h"
#import "TextStyling.h"


@interface OfferDetail ()

@end

@implementation OfferDetail

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
        CGRect frame = self.scrollView.bounds;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0.0f;
        
        // 3
        UIImageView *newPageView = [[UIImageView alloc] init];
        [newPageView setFrame:CGRectMake(10, 10, frame.size.width-30, frame.size.height-30)];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:newPageView animated:YES];
        hud.labelText = @"Loading";
        
        
        
        [newPageView setImageWithURL:[NSURL URLWithString:[self.pageImages objectAtIndex:page]]
                    placeholderImage:[UIImage imageNamed:@"placeholder.png"]
                           completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                               
                               [hud hide:YES];
                               
                               
                           }];
        
        
        //newPageView.contentMode = UIViewContentModeScaleAspectFit;
        
        
        
        
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(frame.origin.x+5, frame.origin.y+5, frame.size.width-10, frame.size.height-10)];
        UIColor *color= [UIColor colorWithRed:0.75f  green:0.75f blue:0.75f alpha:1.0f];
        
        
        
        [view setBackgroundColor:color];
        
        [view addSubview:newPageView];
        [self.scrollView addSubview:view];
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


- (void)initImageSlider
{
    
    
    self.pageImages=[[NSMutableArray alloc]init];
    
    self.pageControl.layer.cornerRadius=7;
    NSMutableArray *images=[self.offerData objectForKey:@"images"];
    
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
    

    self.name.attributedText=[TextStyling AttributForOfferNewsTitle:[self.offerData objectForKey:@"name"]];
    

    self.description.attributedText=[TextStyling AttributForOfferNewsDescription:[self.offerData objectForKey:@"description"]];
    [self initImageSlider];
    [self initOntap];

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
    
    NSMutableArray *images=[self.offerData objectForKey:@"images"];
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
    
    
    
    share *background = [[share alloc]initWithFrame:CGRectMake(0, 0, 320, 150) actionSheet:action];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    NSMutableDictionary *dic1=[NSKeyedUnarchiver unarchiveObjectWithData:[ud objectForKey:@"get_user_data"]];
    NSMutableDictionary *dic=[[dic1 objectForKey:@"success"]objectForKey:@"user"];
    
    
    //fb twitter
    background.caption=[NSString stringWithFormat:@"Recommended - %@ , by %@ , Call %@ . Download Online Kenakata (Android/iOS)",self.name.text,[dic objectForKey:@"user_name"],[dic objectForKey:@"user_phone"]];
    background.description=[self.offerData objectForKey:@"description"];
    NSString *imageURL=[[[self.offerData objectForKey:@"images"]objectAtIndex:0]objectForKey:@"image_url"];
    background.url=imageURL;
    background.viewController=self;
    background.titleName=background.caption;
    background.imageUrl=@"";
    background.delegate=self;
    
    //email
    background.emailBody=[NSString stringWithFormat:@"%@ \n%@ .\nDownload Online Kenakata (Android/iOS)",self.description.text,imageURL];
    background.emailSub=[NSString stringWithFormat:@"Recommended - %@ , by %@ , Call %@ ",self.name.text,[dic objectForKey:@"user_name"],[dic objectForKey:@"user_phone"]];
    
    // background.image=
    //NSLog(@"%@",background.caption);
    
    // background.backgroundColor = [UIColor whiteColor];
    
    
    [action addSubview:background];
    
    [action showInView:self.view];
    
    
    
}

-(void)setMessanger{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dic1=[NSKeyedUnarchiver unarchiveObjectWithData:[ud objectForKey:@"get_user_data"]];
    NSMutableDictionary *dic=[[dic1 objectForKey:@"success"]objectForKey:@"user"];
    
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
