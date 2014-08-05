//
//  DatabaseHandeler.h
//  TestDB
//
//  Created by Rabby Alam on 7/17/14.
//  Copyright (c) 2014 rabbi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Product.h"
#import "DeleveryMethod.h"


@interface DatabaseHandeler : NSObject


+(NSMutableArray *)getProduct;
+(BOOL)myCartDataSave:(Product *)product;
+(BOOL)deletItem:(int)_id;

+(BOOL)updateQuantity:(int)quantity productID:(NSString *)row;

+(BOOL)deletAll;
+(BOOL)isExist:(Product*) product;
+(int)totalProduct;

+(BOOL)setUserData:(NSString *)str;
+(NSString *)getUserData;


//customer data;

+(BOOL)insertDeleveryMethodData:(DeleveryMethod *)deleveryMethod;
+(NSMutableArray *)getDeleveryMethods:(int) type;
@end
