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

NSString *const databaseFilename=@"databaseV1.sqlite3";


@implementation DatabaseHandeler

-(void)openDB{
    
}
-(void)closeDB{
    
}

+(BOOL)myCartDataSave:(Product *)product {


   // NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);

    NSString* homeDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *databasePath = [homeDir stringByAppendingPathComponent:databaseFilename];


    FMDatabase *database = [FMDatabase databaseWithPath:databasePath];
    
    if (![database open]) {
        
        NSLog(@"cant open");

        return NO;
    }
    NSLog(@"can open");
    
    if([self isExist:product]){
        NSLog(@" exist kore ");
        if([product.SPECIAL_QUESTION_TEXT isEqualToString:@""]){
            NSString *qurrey=[NSString stringWithFormat:@"UPDATE 'cart_product_table' SET quantity=%@ where id=%@",product.QUANTITY,product.ID];
            bool ret=[database executeUpdate:qurrey];
            
            [database close];
            return ret;

        }else{
            NSString *qurrey=[NSString stringWithFormat:@"UPDATE 'cart_product_table' SET quantity=%@ where id=%@ AND special_question_text='%@'",product.QUANTITY,product.ID,product.SPECIAL_QUESTION_TEXT];
            bool ret=[database executeUpdate:qurrey];
            
            [database close];
            return ret;
        }
    }else{
    
        NSString *query = [NSString stringWithFormat:@"INSERT INTO 'cart_product_table' VALUES (NULL,'%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@',%d,'%@');",product.ID,product.name,product.QUANTITY,product.WEIGHT,product.ITEM_CODE,product.SPECIAL_QUESTION_TEXT,product.SPECIAL_ANS_ID,product.SPECIAL_ANS_TEXT,product.SPECIAL_ANS_SUB_SKU,product.IMAGE_URL,product.THUMBNAIL_IMAGE_URL,product.PRICE,product.OLD_PRICE,product.AVAILABILITY,product.PRODUCT_TAG];
    
        BOOL b=[database executeUpdate:query];
    
        [database close];
        return b;
    }
}

+(BOOL)isExist:(Product *)product{
    NSString* homeDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *databasePath = [homeDir stringByAppendingPathComponent:databaseFilename];
    
    
    FMDatabase *database = [FMDatabase databaseWithPath:databasePath];
    
    if (![database open]) {
        
        NSLog(@"cant open");
        
        //return NO;
    }
    NSLog(@"can open");
    FMResultSet *result;
    NSLog(@"%@",product.SPECIAL_QUESTION_TEXT);

    if([product.SPECIAL_QUESTION_TEXT isEqualToString:@""]){
        result=[database executeQuery:@"SELECT * FROM 'cart_product_table' where id=?",product.ID];
    }else{

        result=[database executeQuery:@"SELECT * FROM 'cart_product_table' where id = ? AND special_ans_text = ?",product.ID,product.SPECIAL_ANS_TEXT];

    }

    
    if([result next])
    {
        NSLog(@"%@",[result stringForColumnIndex:2]);
        [database close];

        return YES;

    }
    [database close];

    return NO;
}

+(BOOL)deletItem:(int)_id{
    
    
    NSString* homeDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *databasePath = [homeDir stringByAppendingPathComponent:databaseFilename];
    
    
    
    FMDatabase *database = [FMDatabase databaseWithPath:databasePath];
    
    
    if (![database open]) {
        
        return NO;
    }
    NSLog(@"can open");
    
   BOOL b= [database executeUpdate:@"DELETE FROM cart_product_table WHERE _id = ?", [NSNumber numberWithInt:_id]];

    [database close];
    return b;

}

+(BOOL)deletAll{
    NSString* homeDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *databasePath = [homeDir stringByAppendingPathComponent:databaseFilename];
    
    
    
    FMDatabase *database = [FMDatabase databaseWithPath:databasePath];
    
    
    if (![database open]) {
        
        return NO;
    }
    NSLog(@"can open");
    
    BOOL b= [database executeUpdate:@"DELETE FROM cart_product_table "];
    
    [database close];
    return b;

}

+(NSMutableArray *)getProduct{
    
   // NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
   // NSString *docsPath = [paths objectAtIndex:0];
   // NSString *path = [docsPath stringByAppendingPathComponent:@"database"];
    
    NSMutableArray *array=[[NSMutableArray alloc]init];

    NSString* homeDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *databasePath = [homeDir stringByAppendingPathComponent:databaseFilename];
    

    
    FMDatabase *database = [FMDatabase databaseWithPath:databasePath];

    
    
    if (![database open]) {
        
        return nil;
    }
    NSLog(@"can open");
    
    
    FMResultSet *s = [database executeQuery:@"SELECT * FROM 'cart_product_table' ORDER BY id"];
    while ([s next]) {

        Product *var=[[Product alloc]init];
    
        
        var=[var initProduct:[s stringForColumn:name] productId:[s stringForColumn:ID] Quantity:[s stringForColumn:QUANTITY] Weight:[s stringForColumn:WEIGHT] code:[s stringForColumn:ITEM_CODE] spclQusTxt:[s stringForColumn:SPECIAL_QUESTION_TEXT] spclAnsID:[s stringForColumn:SPECIAL_ANS_ID] spclAnsText:[s stringForColumn:SPECIAL_ANS_TEXT] spclAnsSubSku:[s stringForColumn:SPECIAL_ANS_SUB_SKU] imageURL:[s stringForColumn:IMAGE_URL] thumbImage:[s stringForColumn:THUMBNAIL_IMAGE_URL] price:[s stringForColumn:PRICE] oldPrice:[s stringForColumn:OLD_PRICE] availabl:[s intForColumn:AVAILABILITY] tag:[s stringForColumn:PRODUCT_TAG]];

        var.TABLE_PRIMARY_KEY=[s intForColumn:TABLE_PRIMARY_KEY];
        
        [array addObject:var];
    }
    
    [database close];
    
    return array;
}

+(BOOL)updateQuantity:(int)quantity productID:(NSString *)row{
    NSString* homeDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *databasePath = [homeDir stringByAppendingPathComponent:databaseFilename];
    
    
    
    FMDatabase *database = [FMDatabase databaseWithPath:databasePath];
    
    
    
    if (![database open]) {
        
        return NO;
    }
    NSLog(@"can open");
    
    NSString *qurrey=[NSString stringWithFormat:@"UPDATE 'cart_product_table' SET quantity=%d where id=%@",quantity,row];
    bool ret=[database executeUpdate:qurrey];

    NSLog(@"%d",ret);
    [database close];
    return ret;
}

+(int)totalProduct{
    
    NSMutableArray *arr=[self getProduct];
    int total=0;
    
    for(int i=0;i<arr.count;i++){
        Product *p=[arr objectAtIndex:i];
        total+=[p.QUANTITY intValue];
    }
    return total;
}



+(BOOL)setUserData:(NSString *)str{
    NSString *docPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/File"];
    [str writeToFile:docPath
               atomically:YES
                 encoding:NSUTF8StringEncoding
                    error:NULL];
    
    NSLog(@"%@",str);
    return YES;
}

+(NSString *)getUserData{
    NSString *docPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/File"];
    NSString *dataFile = [NSString stringWithContentsOfFile:docPath encoding:NSUTF8StringEncoding error:nil];
    
    NSError *er;
    NSData *data = [dataFile dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&er];
    
   // NSLog(@"%@",dataFile);
    NSLog(@"%@ err %@",json,er );
    return dataFile;
}


@end
