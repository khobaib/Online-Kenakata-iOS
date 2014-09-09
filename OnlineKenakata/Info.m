//
//  Info.m
//  OnlineKenakata-Demo
//
//  Created by Rabby Alam on 7/13/14.
//  Copyright (c) 2014 rabbi. All rights reserved.
//

#import "Info.h"
#import "WebBrowser.h"
#import "UIImageView+WebCache.h"
#import <AddressBook/AddressBook.h>
#import <QuartzCore/QuartzCore.h>
#import "Libraries/MBProgressHUD/MBProgressHUD.h"
#import "TextStyling.h"
@interface Info ()

@end

@implementation Info

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
        


        [newPageView setImageWithURL:[NSURL URLWithString:[self.pageImages objectAtIndex:page]]
                       placeholderImage:[UIImage imageNamed:@"placeholder.png"]
                              completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                              
                                  [hud hide:YES];

                              
                              }];
        
        //newPageView.contentMode = UIViewContentModeScaleAspectFit;
        
        
        
        
        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(frame.origin.x+5, frame.origin.y+5, frame.size.width-10, frame.size.height-10)];
        UIColor *color= [UIColor whiteColor];//[UIColor colorWithRed:0.75f  green:0.75f blue:0.75f alpha:1.0f];


        
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
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.tabBarController.navigationItem setTitleView:nil];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    NSUserDefaults *ud =[NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dic1=[NSKeyedUnarchiver unarchiveObjectWithData:[ud objectForKey:@"get_user_data"]];
    dic=[[dic1 objectForKey:@"success"]objectForKey:@"user"];
    
    [self initImageSlider];
    [self initOntap];
    // Do any additional setup after loading the view.
}


- (void)initImageSlider
{
    self.pageImages=[[NSMutableArray alloc]init];
    
    NSMutableArray *images=[dic objectForKey:@"images"];
    
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
    
    self.pageControl.layer.cornerRadius=7;
    
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
    
    NSMutableArray *images=[dic objectForKey:@"images"];
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


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"infoCell"];
    UILabel *title=(UILabel *)[cell viewWithTag:601];
    UILabel *description=(UILabel *)[cell viewWithTag:602];
    
    switch (indexPath.row) {
        case 0:
            title.text=@"Name";
            description.text=[dic objectForKey:@"user_name"];
            break;
        case 1:
            title.text=@"Phone";
            description.text=[dic objectForKey:@"user_phone"];
            break;
        case 2:{
            title.text=@"Hours";
            
            
            NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init] ;
            [dateFormatter setDateFormat:@"HH:mm"];
            NSDate *from = [dateFormatter dateFromString:[dic objectForKey:@"opening_time"]];

            NSDate *to =[dateFormatter dateFromString:[dic objectForKey:@"closing_time"]];

            [dateFormatter setDateFormat:@"hh:mm a"];
            
            description.text=[NSString stringWithFormat:@"%@   to   %@",[dateFormatter stringFromDate:from],[dateFormatter stringFromDate:to]];
            break;
        }
        case 3:
            title.text=@"Email";
            description.text=[dic objectForKey:@"email_address"];
            break;
        case 4:
            title.text=@"Website";
            description.text=[dic objectForKey:@"user_website"];
            break;
            
        default:
            break;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
 
  
    switch (indexPath.row) {
        case 0:
            
            
            [self askpermission];
            
            
            break;
        case 1:
            [self makeCall];
            break;
        case 2:
            
            break;
        case 3:
            [self emailClient];
            
            break;
        case 4:
           
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:
                                                        [NSString stringWithFormat:@"%@",[dic objectForKey:@"user_website"]]]];

            break;
            
        default:
            break;
    }

}


-(void)makeCall{
    
    NSString *phoneNumber = [@"telprompt://" stringByAppendingString:[dic objectForKey:@"user_phone"]];
    NSString *deviceType = [UIDevice currentDevice].model;
    //  NSLog(@"%@",deviceType);
    

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
-(void)emailClient{
    NSString *subject = [NSString stringWithFormat:@""];
    
    /* define email address */
    NSString *mail =[dic objectForKey:@"email_address"]; //[NSString stringWithFormat:@"test@test.com"];
    
    /* create the URL */
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"mailto:?to=%@&subject=%@",
                                                [mail stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],
                                                [subject stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]]];
    
    /* load the URL */
    [[UIApplication sharedApplication] openURL:url];
}



-(void)askpermission{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Permission"
                                                        message:@"Do you wish to add 'Oops' in contacts?"
                                                       delegate:self
                                              cancelButtonTitle:@"No"
                                              otherButtonTitles:@"Yes",nil];
    [alertView show];
}


//Alert View Delegat method


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if(buttonIndex==1){
        [self checkAddressBookPermission];
    }

}




-(void)checkAddressBookPermission{
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
            // First time access has been granted, add the contact
            [self addContact];
        });
    }
    else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        // The user has previously given access, add the contact
        [self addContact];
    }
    else {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Please give permission for adding contact."
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
        // The user has previously denied access
        // Send an alert telling user to change privacy setting in settings app
    }

}



-(void)addContact{
    
    
    CFErrorRef error = NULL;
   // NSLog(@"%@", [self description]);
    ABAddressBookRef iPhoneAddressBook = ABAddressBookCreateWithOptions(NULL, nil);
    
    ABRecordRef newPerson = ABPersonCreate();
    NSString *name=[dic objectForKey:@"user_name"];
    NSString *phone=[dic objectForKey:@"user_phone"];
    NSString *email=[dic objectForKey:@"email_address"];
    NSString *webAddress=[dic objectForKey:@"user_website"];
    
    
    ABRecordSetValue(newPerson, kABPersonFirstNameProperty, (__bridge CFTypeRef)(name), &error);
  //  ABRecordSetValue(newPerson, kABPersonLastNameProperty, people.lastname, &error);
    
    ABMutableMultiValueRef multiPhone =     ABMultiValueCreateMutable(kABMultiStringPropertyType);
    ABMultiValueAddValueAndLabel(multiPhone, (__bridge CFTypeRef)(phone), kABPersonPhoneMainLabel, NULL);
    
    
    ABRecordSetValue(newPerson, kABPersonPhoneProperty, multiPhone,nil);
    CFRelease(multiPhone);
    
    ABMutableMultiValueRef multiEmail =     ABMultiValueCreateMutable(kABMultiStringPropertyType);
    ABMultiValueAddValueAndLabel(multiPhone, (__bridge CFTypeRef)(email), kABWorkLabel, NULL);
    ABRecordSetValue(newPerson, kABPersonEmailProperty, multiEmail,nil);
    CFRelease(multiEmail);


    ABMutableMultiValueRef homePage =     ABMultiValueCreateMutable(kABMultiStringPropertyType);
    ABMultiValueAddValueAndLabel(homePage, (__bridge CFTypeRef)(webAddress), kABPersonHomePageLabel, NULL);
    ABRecordSetValue(newPerson, kABPersonURLProperty, homePage,nil);
    CFRelease(homePage);
    
    
    


    // ...
    // Set other properties
    // ...
    
    NSArray *allContacts = (__bridge NSArray *)ABAddressBookCopyArrayOfAllPeople(iPhoneAddressBook);

    for (id record in allContacts){
        ABRecordRef thisContact = (__bridge ABRecordRef)record;
        if (CFStringCompare(ABRecordCopyCompositeName(thisContact),
                            ABRecordCopyCompositeName(newPerson), 0) == kCFCompareEqualTo)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:@"The Contact Already Exist."
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
            [alertView show];
            
            return;
        }
    }
    
    
    ABAddressBookAddRecord(iPhoneAddressBook, newPerson, &error);
    
    ABAddressBookSave(iPhoneAddressBook, &error);
    CFRelease(newPerson);
    CFRelease(iPhoneAddressBook);
    if (error != NULL)
    {
        CFStringRef errorDesc = CFErrorCopyDescription(error);
        NSLog(@"Contact not saved: %@", errorDesc);
        CFRelease(errorDesc);        
    }else{
        UIAlertView *contactAddedAlert = [[UIAlertView alloc]initWithTitle:@"Contact Added" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [contactAddedAlert show];

    }
    
    
}
-(void)addShareButton{
    UIButton *sharebtn=[TextStyling sharebutton];
    [sharebtn addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    sharebtn.hidden=NO;
    // [self.navigationController.navigationBar addSubview:sharebtn];
    self.tabBarController.navigationItem.titleView=sharebtn;
    
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
    NSMutableDictionary *dic2=[NSKeyedUnarchiver unarchiveObjectWithData:[ud objectForKey:@"get_user_data"]];
    
    NSMutableDictionary *dic1=[[dic2 objectForKey:@"success"]objectForKey:@"user"];
    
    
    //fb twitter
    background.caption=[NSString stringWithFormat:@"Recommended - %@ , by %@ , Call %@ . Download Online Kenakata (Android/iOS)",[dic1 objectForKey:@"user_name"],[dic1 objectForKey:@"user_name"],[dic1 objectForKey:@"user_phone"]];
    
    background.description=[NSString stringWithFormat:@"Check out %@. Call %@ or email %@. Opening hours - %@",[dic1 objectForKey:@"user_name"],[dic1 objectForKey:@"user_phone"],[dic1 objectForKey:@"email_address"],[dic1 objectForKey:@"hours"]];
    
    NSString *url=[dic1 objectForKey:@"user_website"];
    background.url=url;
    background.viewController=self;
    background.titleName=background.caption;
    background.imageUrl=@"";
    background.delegate=self;
    
    //email
    background.emailBody=[NSString stringWithFormat:@"Name: %@ \nPhone: %@\nOpening hours: %@\nEmail: %@\nWebsite: %@\nDownload  Online Kenakata  (Android/iOS)",[dic1 objectForKey:@"user_name"],[dic1 objectForKey:@"user_phone"],[dic1 objectForKey:@"hours"],[dic1 objectForKey:@"email_address"],[dic1 objectForKey:@"user_website"]];
    
    
    background.emailSub=[NSString stringWithFormat:@"Recommended - %@ , by %@ , Call %@ ",[dic objectForKey:@"user_name"],[dic objectForKey:@"user_name"],[dic objectForKey:@"user_phone"]];
    
    // background.image=
    //NSLog(@"%@",background.caption);
    
    // background.backgroundColor = [UIColor whiteColor];
    
    
    [action addSubview:background];
    
    [action showInView:self.view];
    
    
    
}

-(void)setMessanger{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dic2=[NSKeyedUnarchiver unarchiveObjectWithData:[ud objectForKey:@"get_user_data"]];
    NSMutableDictionary *dic1=[[dic2 objectForKey:@"success"]objectForKey:@"user"];
    
    NSLog(@"protocall");
    if(![MFMessageComposeViewController canSendText]) {
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warningAlert show];
        return;
    }
    
    //  NSArray *recipents = @[@"12345678", @"72345524"];
    NSString *message = [NSString stringWithFormat:@"Recommended - %@ , %@ , %@ .Download Online Kenakata (Android/iOS)",[dic1 objectForKey:@"user_name"],[dic1 objectForKey:@"user_phone"],[dic1 objectForKey:@"user_website"]];
    
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

-(IBAction)openYoutube:(id)sender{
    
    NSString *url=[dic objectForKey:@"video_url"];
    
    if([url isEqualToString:@""]){
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"No video found" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        
        return;
    }
    
    NSURL *linkToAppURL = [NSURL URLWithString:[NSString stringWithFormat:@"youtube://%@",[self extractString:url toLookFor:@"watch"]]];
    NSURL *linkToWebURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"video_url"]]];
    
    if ([[UIApplication sharedApplication] canOpenURL:linkToAppURL]) {
        // Can open the youtube app URL so launch the youTube app with this URL
        [[UIApplication sharedApplication] openURL:linkToAppURL];
        
    }
    else{
        // Can't open the youtube app URL so launch Safari instead
        
        [[UIApplication sharedApplication] openURL:linkToWebURL];
    }
}
- (NSString *)extractString:(NSString *)fullString toLookFor:(NSString *)lookFor
{
    
    NSRange firstRange = [fullString rangeOfString:lookFor];
    
    NSRange finalRange = NSMakeRange(firstRange.location , [fullString length]-firstRange.location);
    
    
    return [fullString substringWithRange:finalRange];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    UIButton *button =(UIButton *)sender;
    
    WebBrowser *wb= (WebBrowser *)[segue destinationViewController];
    wb.url=[dic objectForKey:button.restorationIdentifier];
    
}


@end
