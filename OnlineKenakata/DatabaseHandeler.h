//
//  DatabaseHandeler.h
//  TestDB
//
//  Created by Rabby Alam on 7/17/14.
//  Copyright (c) 2014 rabbi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Product.h"


@interface DatabaseHandeler : NSObject


+(NSMutableArray *)getProduct;
+(void)myCartDataSave:(Product *)product;
+(void)deletItem:(int)_id;

+(BOOL)updateQuantity:(int)quantity productID:(NSString *)row;

@end
