//
//  DeleveryMethod.m
//  OnlineKenakata
//
//  Created by Apple on 8/5/14.
//  Copyright (c) 2014 OnlineKenakata. All rights reserved.
//

#import "DeleveryMethod.h"

@implementation DeleveryMethod

-(void)initDeleveryMethod:(int)_id name:(NSString *)name email:(NSString *)email phone:(NSString *)phone branchName:(NSString *)branchName address:(NSString *)address comment:(NSString *)comment payment:(int)method type:(int)type
{

    self._id=_id;
    self.name=name;
    self.email=email;
    self.phone=phone;
    self.branchName=branchName;
    self.address=address;
    self.comment=comment;
    self.paymentMethod=method;
    self.type=type;
}
@end
