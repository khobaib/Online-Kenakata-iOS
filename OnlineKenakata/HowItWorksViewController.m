//
//  HowItWorksViewController.m
//  kenakata
//
//  Created by MC MINI on 11/9/14.
//  Copyright (c) 2014 OnlineKenakata. All rights reserved.
//

#import "HowItWorksViewController.h"

@interface HowItWorksViewController ()

@end

@implementation HowItWorksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title=@"How It Works";
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationItem setRightBarButtonItems:nil];
    
    
    [self initImageSlider];
    
    
    [self loadVisiblePages];
    
    [[NSUserDefaults standardUserDefaults]setObject:@"NO" forKey:@"isFirst"];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}


-(void)viewWillAppear:(BOOL)animated{
   self.screenName=@"How It Works";
    self.navigationItem.leftBarButtonItem=nil;
}
-(void)viewWillDisappear:(BOOL)animated{
    
    
    
}

- (void)initImageSlider
{

    self.pageControl.layer.cornerRadius=7;
    self.pageImages=[[NSMutableArray alloc]init];
    
    NSArray *images=@[@"s1.png",@"s2.png",@"s3.png",@"s4.png",@"s5.png"] ;
    
    for(int i=0;i<images.count;i++){
        NSString *url=[images objectAtIndex:i];
        [self.pageImages addObject:url];
    }
    
    self.pageControl.currentPage=0;
    self.pageControl.numberOfPages=self.pageImages.count;
    
    self.pageViews = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < self.pageImages.count; ++i) {
        [self.pageViews addObject:[NSNull null]];
    }
    
    
    
    [self.pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    
    int hight=self.scrollView.frame.size.height;
    
    NSLog(@"%d",hight);
    int width=self.scrollView.frame.size.width*self.pageImages.count;
    [self.scrollView setContentSize:CGSizeMake(width, 400)];

}

- (IBAction)changePage:(id)sender {
    CGFloat x = self.pageControl.currentPage * self.scrollView.frame.size.width;
    [self.scrollView setContentOffset:CGPointMake(x, 0) animated:YES];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // Load the pages that are now on screen
   
  [self loadVisiblePages];
   
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
        [newPageView setFrame:frame];
        newPageView.image=[UIImage imageNamed:[self.pageImages objectAtIndex:page]];
        
        newPageView.contentMode = UIViewContentModeScaleAspectFit;
        
        
        
        
       
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

-(IBAction)skip:(id)sender{
    [self.navigationController popToRootViewControllerAnimated:YES];
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
