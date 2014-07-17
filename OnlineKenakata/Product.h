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
@property NSString *TABLE_PRIMARY_KEY;
@property NSString *QUANTITY;
@property NSString *WEIGHT;
@property NSString *ITEM_CODE;
@property NSString *SPECIAL_QUESTION_TEXT;
@property NSString *SPECIAL_ANS_ID;
@property NSString *SPECIAL_ANS_TEXT;
@property NSString *SPECIAL_ANS_SUB_SKU;
@property NSString *IMAGE_URL;
@property NSString *THUMBNAIL_IMAGE_URL;
@property NSString *PRICE;
@property NSString *OLD_PRICE;
@property int AVAILABILITY;
@property NSString *PRODUCT_TAG;



@end
