//
//  Product.h
//  TestDB
//
//  Created by Rabby Alam on 7/17/14.
//  Copyright (c) 2014 rabbi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Product : NSObject




@property NSString *name;
@property NSString *ID;
@property int TABLE_PRIMARY_KEY;
@property NSString *QUANTITY;
@property NSString *WEIGHT;
@property NSString *ITEM_CODE;
@property NSString *attributs;
@property NSString *varientID;
@property NSString *IMAGE_URL;
@property NSString *THUMBNAIL_IMAGE_URL;
@property NSString *PRICE;
@property NSString *OLD_PRICE;
@property int AVAILABILITY;
@property NSString *PRODUCT_TAG;
@property NSString *marchantID;
@property NSString *rating;
@property NSString *totalFvt;
@property NSString *hasFvt;

-(id)initProduct:(NSString *)name productId:(NSString *)ID Quantity:(NSString *)quantity Weight:(NSString *)weight code:(NSString*)item_code attributs:(NSString *)attributs varient:(NSString*)varientID imageURL:(NSString *)imageUrl thumbImage:(NSString *)thumbImage price:(NSString *)price oldPrice:(NSString *)oldPrice availabl:(int )availablity tag:(NSString *)product_tag marchantID:(NSString *)marchant;

@end
