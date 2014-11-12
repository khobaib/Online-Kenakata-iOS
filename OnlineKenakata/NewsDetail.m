//
//  NewsDetail.m
//  OnlineKenakata-Demo
//
//  Created by Rabby Alam on 7/12/14.
//  Copyright (c) 2014 rabbi. All rights reserved.
//

#import "NewsDetail.h"
#import "TextStyling.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"



@interface NewsDetail ()

@end

@implementation NewsDetail

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.name.attributedText=[TextStyling AttributForDescription:[self.dic objectForKey:@"news_title"]];
    
    NSString *imageurl= [[[self.dic objectForKey:@"images"]objectAtIndex:0]objectForKey:@"image_url"];
    
    if(imageurl!=nil){
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.imageView animated:YES];
        hud.labelText = @"Loading";
        
        
        
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageurl]
                       placeholderImage:[UIImage imageNamed:@"placeholder.png"]
                              completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType,NSURL *imageURL) {
                                  
                                  [hud hide:YES];
                                  
                                  
                              }];
    }

    self.descriptionText.attributedText=[TextStyling AttributForDescription:[self.dic objectForKey:@"news_contents"]];

    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self addShareButton];
}

-(void)addShareButton{
    UIButton *sharebtn=[TextStyling sharebutton];
    
    [sharebtn addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    sharebtn.hidden=NO;
    // [self.navigationController.navigationBar addSubview:sharebtn];
    self.navigationItem.titleView=sharebtn;
    
    //[self.navigationItem.titleView addSubview:sharebtn];
}

- (void)shareConfig:(share *)background {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dic1=[NSKeyedUnarchiver unarchiveObjectWithData:[ud objectForKey:@"get_user_data"]];
    
    
    NSMutableDictionary *dic=[[dic1 objectForKey:@"success"]objectForKey:@"user"];
    
    
    //fb twitter
    background.titleName=[NSString stringWithFormat:@"Recommended - %@ , by %@ , Call %@ . Download কেনাকাটা (Android/iOS)",self.name.text,[dic objectForKey:@"user_name"],[dic objectForKey:@"user_phone"]];
    background.descriptionText=[self.dic objectForKey:@"news_contents"];
    NSString *imageURL=[[[self.dic objectForKey:@"images"]objectAtIndex:0]objectForKey:@"image_url"];
    background.url=imageURL;
    background.viewController=self;
    background.caption=@"";
    background.imageUrl=@"";
    background.delegate=self;
    
    //email
    background.emailBody=[NSString stringWithFormat:@"%@ \n%@ .\nDownload কেনাকাটা (Android/iOS)",[self.dic objectForKey:@"news_title"],imageURL];
    background.emailSub=[NSString stringWithFormat:@"Recommended - %@ , by %@ , Call %@ ",self.name.text,[dic objectForKey:@"user_name"],[dic objectForKey:@"user_phone"]];
}

-(void)shareInIOS8{
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"Share" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    share *background=[[share alloc]init];
    
    [self shareConfig:background];
    
    
    
    UIAlertAction *facebook=[UIAlertAction actionWithTitle:@"facebook" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [background facebookShare];
    }];
    
    UIAlertAction *twiter=[UIAlertAction actionWithTitle:@"twiter" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [background twiterShare];
    }];
    
    UIAlertAction *email=[UIAlertAction actionWithTitle:@"email" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [background mailShare];
    }];
    
    UIAlertAction *message=[UIAlertAction actionWithTitle:@"message" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        
        [self setMessanger];
    }];
    
    UIAlertAction *cancle=[UIAlertAction actionWithTitle:@"cancle" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        
    }];
    
    
    
    
    [alert addAction:facebook];
    [alert addAction:twiter];
    [alert addAction:email];
    [alert addAction:message];
    [alert addAction:cancle];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

-(void)shareButtonClick:(id)sender{
    UIActionSheet * action = [[UIActionSheet alloc]
                              initWithTitle:@"Share"
                              delegate:nil
                              cancelButtonTitle:@"Cancel"
                              destructiveButtonTitle:nil
                              otherButtonTitles:@"",nil];
    
    
    
    share *background;// = [[share alloc]initWithFrame:CGRectMake(0, 0, 320, 150) actionSheet:action];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [self shareInIOS8];
        return;
    }else{
        background = [[share alloc]initWithFrame:CGRectMake(0, 0, 320, 150) actionSheet:action];
    }
    
    [self shareConfig:background];
    
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
    NSString *message = [NSString stringWithFormat:@"Recommended - %@ , %@ , %@ .Download কেনাকাটা (Android/iOS)",self.name.text,[dic objectForKey:@"user_name"],[dic objectForKey:@"user_phone"]];
    
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
