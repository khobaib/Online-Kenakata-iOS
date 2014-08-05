//
//  DeleveryMethod.h
//  OnlineKenakata
//
//  Created by Apple on 8/5/14.
//  Copyright (c) 2014 OnlineKenakata. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeleveryMethod : NSObject

@property int _id;
@property NSString *name;
@property NSString *email;
@property NSString *phone;
@property NSString *branchName;
@property NSString *address;
@property NSString *comment;

@property int paymentMethod;
@property int type;

-(void)initDeleveryMethod:(int)_id name:(NSString *)name email:(NSString *)email phone:(NSString *)phone branchName:(NSString *)branchName address:(NSString *)address comment:(NSString *)comment payment:(int)method type:(int)type;
@end
