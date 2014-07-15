//
//  WebBrowser.h
//  OnlineKenakata-Demo
//
//  Created by Rabby Alam on 7/13/14.
//  Copyright (c) 2014 rabbi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingView.h"

@interface WebBrowser : UIViewController<UIWebViewDelegate>{
    LoadingView *loading;
    
}
@property (strong,nonatomic) NSString *url;
@property (strong,nonatomic) IBOutlet UIWebView *webView;
@end
