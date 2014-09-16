//
//  Product.m
//  TestDB
//
//  Created by Rabby Alam on 7/17/14.
//  Copyright (c) 2014 rabbi. All rights reserved.
//

#import "Product.h"

@implementation Product

-(id)initProduct:(NSString *)name productId:(NSString *)ID Quantity:(NSString *)quantity Weight:(NSString *)weight code:(NSString *)item_code attributs:(NSString *)attributs varient:(NSString*)varientID imageURL:(NSString *)imageUrl thumbImage:(NSString *)thumbImage price:(NSString *)price oldPrice:(NSString *)oldPrice availabl:(int )availablity tag:(NSString *)product_tag;{
    
    self.name=name;
    self.ID=ID;
    self.QUANTITY=quantity;
    self.WEIGHT=weight;
    self.ITEM_CODE=item_code;
    self.attributs=attributs;
    self.varientID=varientID;
    self.IMAGE_URL=imageUrl;
    self.THUMBNAIL_IMAGE_URL=thumbImage;
    self.PRICE=price;
    self.OLD_PRICE=oldPrice;
    self.AVAILABILITY=availablity;
    self.PRODUCT_TAG=product_tag;
    
    
    
    return self;
}

@end
