//
//  Product.m
//  TestDB
//
//  Created by Rabby Alam on 7/17/14.
//  Copyright (c) 2014 rabbi. All rights reserved.
//

#import "Product.h"

@implementation Product

-(id)initProduct:(NSString *)name productId:(NSString *)ID Quantity:(NSString *)quantity Weight:(NSString *)weight code:(NSString *)item_code spclQusTxt:(NSString *)specialQusTxt spclAnsID:(NSString *)spclAnsID spclAnsText:(NSString *)spclAnsText spclAnsSubSku:(NSString *)spclAnsSubSku imageURL:(NSString *)imageUrl thumbImage:(NSString *)thumbImage price:(NSString *)price oldPrice:(NSString *)oldPrice availabl:(int )availablity tag:(NSString *)product_tag

{
    
    self.name=name;
    self.ID=ID;
    self.QUANTITY=quantity;
    self.WEIGHT=weight;
    self.ITEM_CODE=item_code;
    self.SPECIAL_QUESTION_TEXT=specialQusTxt;
    self.SPECIAL_ANS_ID=spclAnsID;
    self.SPECIAL_ANS_TEXT=spclAnsText;
    self.SPECIAL_ANS_SUB_SKU=spclAnsSubSku;
    self.IMAGE_URL=imageUrl;
    self.THUMBNAIL_IMAGE_URL=thumbImage;
    self.PRICE=price;
    self.OLD_PRICE=oldPrice;
    self.AVAILABILITY=availablity;
    self.PRODUCT_TAG=product_tag;
    
    
    
    return self;
}

@end
