//
//  AppDelegate.m
//  OnlineKenakata-Demo
//
//  Created by Rabby Alam on 7/8/14.
//  Copyright (c) 2014 rabbi. All rights reserved.
//

#import "AppDelegate.h"
#import "Data.h"
#import "AFNetworking.h"
#import "TextStyling.h"
#import <MapKit/MapKit.h>
#import "EDStarRating/EDStarRating.h"
#import <FacebookSDK/FacebookSDK.h>
#import "PostSplashImageScreen.h"
#import "tabbarController.h"
#import "FirstViewController.h"
#import "WebBrowser.h"
#import "ProductDetails.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [FBSettings setDefaultUrlSchemeSuffix:@"abcd"];
    //[FBSession.activeSession closeAndClearTokenInformation];
    // Override point for customization after application launch.
  
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
         [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
       
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    }

   
    
    [self checkAndCreateDatabase];
    
    [FBLoginView class];

    
    if (launchOptions != nil)
	{
		NSDictionary *dictionary = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
		if (dictionary != nil)
		{
			NSLog(@"Launched from push notification: %@", dictionary);
			[self addMessageFromRemoteNotification:dictionary updateUI:NO];
		}
	}
    UILocalNotification *notification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    
    if (notification)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"localNotification" object:nil userInfo:notification.userInfo];

        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Launch options" message:@"alerm set" delegate:nil cancelButtonTitle:@"cancle" otherButtonTitles: nil];
        
        [alert show];
        // application launched due to notification
    }
    
    [TextStyling changeAppearance];

    [EDStarRating class];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    // Call FBAppCall's handleOpenURL:sourceApplication to handle Facebook app responses
    BOOL wasHandled = [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
    
    // You can add your app-specific url handling code here if needed
    
    return wasHandled;
}



-(void) checkAndCreateDatabase{
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString* homeDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *databasePath = [homeDir stringByAppendingPathComponent:@"databaseV1.sqlite3"];
    success = [fileManager fileExistsAtPath:databasePath];
    if(success) {
         NSLog(@"working");
        return;}
    else{
        NSLog(@"notworking");
        NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"databaseV1.sqlite3"];
        
        NSError *error;
        [fileManager copyItemAtPath:databasePathFromApp toPath:databasePath error:&error];
        
        NSLog(@"%@",[error description]);
    }
}



- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark Notification




- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    
    NSString *newToken = [deviceToken description];
    newToken = [newToken stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    newToken = [newToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSLog(@"My token is: %@", newToken);
    NSString *string = [NSString stringWithFormat:@"%@/rest.php?method=adddevicetoken&dt=%@&unread=0&application_code=%@",[Data getBaseUrl],newToken,[Data getAppCode]];
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // 2
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        
        
    }];
    
    
    [operation start];
    
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"Failed to get token, error: %@", error);
}


-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"localNotification" object:nil userInfo:notification.userInfo];
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Alerm" message:@"alerm set" delegate:nil cancelButtonTitle:@"cancle" otherButtonTitles: nil];
    
    NSLog(@"log log");
    [alert show];
}
/*
 -(void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{
 [UIApplication sharedApplication].applicationIconBadgeNumber =0;
 }*/
- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo
{
    [self handleRemortNotification:userInfo];
    NSLog(@"%@",userInfo);
    [UIApplication sharedApplication].applicationIconBadgeNumber =0;
    //[self addMessageFromRemoteNotification:userInfo updateUI:YES];
}


- (void)addMessageFromRemoteNotification:(NSDictionary*)userInfo updateUI:(BOOL)updateUI
{
    
     [self handleRemortNotification:userInfo];
    
    NSLog(@"%@",userInfo);

    [UIApplication sharedApplication].applicationIconBadgeNumber =0;
}

-(void)handleRemortNotification:(NSDictionary *)userInfo{
    
    if([userInfo[@"notification_type"]isEqualToString:@"GENERAL"]){
       
            NSString *str=[[userInfo objectForKey:@"aps"]objectForKey:@"alert"];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"কেনাকাটা"
                                                            message:str
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
            [alertView show];
        
        
    }else if([userInfo[@"notification_type"]isEqualToString:@"WEB_LINK"]){
        PostSplashImageScreen *vc=(PostSplashImageScreen *)self.window.rootViewController;
        
        tabbarController *tvc=[[vc.nav viewControllers]objectAtIndex:0];
        FirstViewController *fcv=[[tvc viewControllers]objectAtIndex:0];
        
        WebBrowser *wb=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"webbrowser"];
        
        wb.url=userInfo[@"additional"];
        [tvc setSelectedIndex:0];
        [fcv.navigationController pushViewController:wb animated:YES];
        
        
    }else if([userInfo[@"notification_type"]isEqualToString:@"LIST"]){
        
        PostSplashImageScreen *vc=(PostSplashImageScreen *)self.window.rootViewController;
        
        tabbarController *tvc=[[vc.nav viewControllers]objectAtIndex:0];
       
        if([userInfo[@"additional"]isEqualToString:@"NEW"]){
             [tvc setSelectedIndex:2];
            
            
        }else if([userInfo[@"additional"]isEqualToString:@"SALE"]){
             [tvc setSelectedIndex:1];
        }
        
        
    }else if([userInfo[@"notification_type"]isEqualToString:@"SINGLE"]){
        
        NSString *productID=userInfo[@"additional"];
        NSLog(@"log %@",productID);
        
        PostSplashImageScreen *vc=(PostSplashImageScreen *)self.window.rootViewController;
        
        tabbarController *tvc=[[vc.nav viewControllers]objectAtIndex:0];
        FirstViewController *fcv=[[tvc viewControllers]objectAtIndex:0];
        
        ProductDetails *pdvc=[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"productDetails3"];
        
        NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
        dic[@"product_id"]=productID;
        pdvc.productData=dic;
        [fcv.navigationController pushViewController:pdvc animated:YES];
    }
    
}

@end
