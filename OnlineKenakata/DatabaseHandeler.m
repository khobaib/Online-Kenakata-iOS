//
//  DatabaseHandeler.m
//  TestDB
//
//  Created by Rabby Alam on 7/17/14.
//  Copyright (c) 2014 rabbi. All rights reserved.
//

#import "DatabaseHandeler.h"
#import "FMDatabase.h"

NSString *const name = @"name";

NSString *const tableNAme=@"cart_product_table";
NSString *const TABLE_PRIMARY_KEY =@"_id";
NSString *const ID =@"id";
NSString *const QUANTITY =@"quantity";
NSString *const WEIGHT =@"weight";
NSString *const ITEM_CODE =@"item_code";
NSString *const SPECIAL_QUESTION_TEXT =@"special_question_text";
NSString *const SPECIAL_ANS_ID =@"special_ans_id";
NSString *const SPECIAL_ANS_TEXT =@"special_ans_text";
NSString *const SPECIAL_ANS_SUB_SKU =@"special_ans_sub_sku";
NSString *const IMAGE_URL =@"image_url";
NSString *const THUMBNAIL_IMAGE_URL =@"thumbnail_image_url";
NSString *const PRICE =@"price";
NSString *const OLD_PRICE =@"old_price";
NSString *const AVAILABILITY =@"availability";
NSString *const PRODUCT_TAG = @"tag";


@implementation DatabaseHandeler

-(void)openDB{
    
}
-(void)closeDB{
    
}

+(void)myCartDataSave:(Product *)product {


   // NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);

    NSString* homeDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *databasePath = [homeDir stringByAppendingPathComponent:@"database.sqlite3"];


    FMDatabase *database = [FMDatabase databaseWithPath:databasePath];
    
    if (![database open]) {
        
        NSLog(@"cant open");

        return;
    }
    NSLog(@"can open");
    
    NSString *query = [NSString stringWithFormat:@"INSERT INTO 'cart_product_table' VALUES (NULL,'%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@',%d,'%@');",product.ID,product.name,product.QUANTITY,product.WEIGHT,product.ITEM_CODE,product.SPECIAL_QUESTION_TEXT,product.SPECIAL_ANS_ID,product.SPECIAL_ANS_TEXT,product.SPECIAL_ANS_SUB_SKU,product.IMAGE_URL,product.THUMBNAIL_IMAGE_URL,product.PRICE,product.OLD_PRICE,product.AVAILABILITY,product.PRODUCT_TAG];
    
    [database executeUpdate:query];
    
    [database close];
    
}

+(Product *)getProduct{

    Product *product;

    
   // NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
   // NSString *docsPath = [paths objectAtIndex:0];
   // NSString *path = [docsPath stringByAppendingPathComponent:@"database"];

    NSString* homeDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *databasePath = [homeDir stringByAppendingPathComponent:@"database.sqlite3"];
    

    
    FMDatabase *database = [FMDatabase databaseWithPath:databasePath];

    
    
    if (![database open]) {
        
        return product;
    }
    NSLog(@"can open");
    
    
    FMResultSet *s = [database executeQuery:@"SELECT * FROM 'cart_product_table'"];
    while ([s next]) {

    
        NSLog(@" value is %@",[s stringForColumn:name]);
    }
    
    [database close];
    
    return product;
}

@end
