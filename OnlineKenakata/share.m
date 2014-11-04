//
//  share.m
//  OnlineKenakata
//
//  Created by Rabby Alam on 7/15/14.
//  Copyright (c) 2014 OnlineKenakata. All rights reserved.
//

#import "share.h"
#import <FacebookSDK/FacebookSDK.h>
#import <Social/Social.h>


@implementation share

- (id)initWithFrame:(CGRect)frame actionSheet:(UIActionSheet *)sheet
{
    self = [super initWithFrame:frame];
    if (self) {
        int x=105;
        action=sheet;
        UIButton *facebook=[[UIButton alloc]initWithFrame:CGRectMake(30, 30, 60, 60)];
        [facebook setBackgroundImage:[UIImage imageNamed:@"facebook.png"] forState:UIControlStateNormal];
        [facebook addTarget:self action:@selector(facebook:) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIButton *twitter=[[UIButton alloc]initWithFrame:CGRectMake(x, 30, 60, 60)];
        [twitter setBackgroundImage:[UIImage imageNamed:@"twitter.png"] forState:UIControlStateNormal];
        [twitter addTarget:self action:@selector(twitter:) forControlEvents:UIControlEventTouchUpInside];
        
        x+=75;
        
        UIButton *mail=[[UIButton alloc]initWithFrame:CGRectMake(x, 30, 60, 60)];
        [mail setBackgroundImage:[UIImage imageNamed:@"mail.png"] forState:UIControlStateNormal];
        [mail addTarget:self action:@selector(mail:) forControlEvents:UIControlEventTouchUpInside];
        
        x+=75;

        UIButton *messanger=[[UIButton alloc]initWithFrame:CGRectMake(x, 30, 60, 60)];
        [messanger setBackgroundImage:[UIImage imageNamed:@"imessege.png"] forState:UIControlStateNormal];
        [messanger addTarget:self action:@selector(messanger:) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIButton *cancle=[[UIButton alloc]initWithFrame:CGRectMake(130, 120, 60, 20)];
        [cancle setTitle:@"Cancle" forState:UIControlStateNormal];
        [cancle setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cancle addTarget:self action:@selector(cancle:) forControlEvents:UIControlEventTouchUpInside];
        

        [self addSubview:facebook];
        [self addSubview:twitter];
        [self addSubview:mail];
        [self addSubview:messanger];
        [self addSubview:cancle];
        
        [self setBackgroundColor:[UIColor whiteColor]];
        


    }
    return self;
}

-(void)cancle:(id)sender{
    [action dismissWithClickedButtonIndex:-1 animated:YES];
    action=nil;

}
-(void)facebook:(id)sender{
    [action dismissWithClickedButtonIndex:-1 animated:YES];
    action=nil;
    
    
    FBLinkShareParams *params = [[FBLinkShareParams alloc] init];
    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc]init];
    
    if(![self.url isEqualToString:@""]){
        
        [paramsDic setObject:self.url forKey:@"link"];
        params.link = [NSURL URLWithString:self.url];


    }
    if(![self.description isEqualToString:@""]){
      
        params.linkDescription=self.description;
        [paramsDic setObject:self.description forKey:@"description"];


    }
    if(![self.titleName isEqualToString:@""]){
        params.name=self.titleName;
        [paramsDic setObject:self.titleName forKey:@"name"];


    }
    if(![self.caption isEqualToString:@""]){
        params.caption=self.caption;
        [paramsDic setObject:self.caption forKey:@"caption"];


    }
    
    if(![self.imageUrl isEqualToString:@""]){
        params.picture=[NSURL URLWithString:self.imageUrl];
        [paramsDic setObject:self.imageUrl forKey:@"picture"];


    }
    
   // NSLog(@"%@ %@",params.linkDescription,self.url);

    
    
    
    // If the Facebook app is installed and we can present the share dialog
    if ([FBDialogs canPresentShareDialogWithParams:params]) {
        // Present the share dialog
      //  NSLog(@"App present");
        [FBDialogs presentShareDialogWithParams:params clientState:nil
         
                                        handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                          if(error) {
                                              // An error occurred, we need to handle the error
                                              // See: https://developers.facebook.com/docs/ios/errors
                                              NSLog(@"Error publishing story: %@", error.description);
                                          } else {
                                              // Success
                                              NSLog(@"result %@", results);
                                          }
                                      }];
        
    } else {
        // Present the feed dialog
        
        //NSLog(@"App not present");
        
        
      //  NSLog(@"%@",paramsDic);
        // Show the feed dialog
        [FBWebDialogs presentFeedDialogModallyWithSession:nil
                                               parameters:paramsDic
                                                  handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                      if (error) {
                                                          // An error occurred, we need to handle the error
                                                          // See: https://developers.facebook.com/docs/ios/errors
                                                          NSLog(@"Error publishing story: %@", error.description);
                                                      } else {
                                                          if (result == FBWebDialogResultDialogNotCompleted) {
                                                              // User cancelled.
                                                              NSLog(@"User cancelled.");
                                                          } else {
                                                              // Handle the publish feed callback
                                                              NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                                                              
                                                              if (![urlParams valueForKey:@"post_id"]) {
                                                                  // User cancelled.
                                                                  NSLog(@"User cancelled.");
                                                                  
                                                              } else {
                                                                  // User clicked the Share button
                                                                  NSString *result = [NSString stringWithFormat: @"Posted story, id: %@", [urlParams valueForKey:@"post_id"]];
                                                                  NSLog(@"result %@", result);
                                                              }
                                                          }
                                                      }
                                                  }];
        
        
    }

}


- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}
-(void)twitter:(id)sender{
    [action dismissWithClickedButtonIndex:-1 animated:YES];
    action=nil;
    
    
    SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    [tweetSheet addURL:[NSURL URLWithString:self.url]];

    if(self.titleName.length>117){
        NSRange stringRange = {0, MIN([self.titleName length], 114)};
        
        // adjust the range to include dependent chars
        
        // Now you can create the short string
        NSString *shortString = [self.titleName substringWithRange:stringRange];

        [tweetSheet setInitialText:[NSString stringWithFormat:@"%@...",shortString]];
        
    }else{
        [tweetSheet setInitialText:self.titleName];
        
    }
    
    
    [tweetSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
        
        switch (result) {
            case SLComposeViewControllerResultCancelled:
                NSLog(@"Post Canceled");
                break;
            case SLComposeViewControllerResultDone:
                NSLog(@"Post Sucessful");
                break;
                
            default:
                break;
        }
    }];
    
    
    
    [self.viewController presentViewController:tweetSheet animated:YES completion:nil];

    
}

-(void)mail:(id)sender{
    [action dismissWithClickedButtonIndex:-1 animated:YES];
    action=nil;
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"mailto:?to=&subject=%@&body=%@",
                                                [self.emailSub stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],
                                                [self.emailBody stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]]];
    
    /* load the URL */
    [[UIApplication sharedApplication] openURL:url];

    
    
}
-(void)messanger:(id)sender{
    
    
    [action dismissWithClickedButtonIndex:-1 animated:YES];
    action=nil;
    NSLog(@"in messanger");
    [self.delegate setMessanger];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
