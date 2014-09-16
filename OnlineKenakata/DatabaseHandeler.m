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

NSString *const customerTable=@"customer_data_table";
NSString *const tableNAme=@"cart_product_table";
NSString *const TABLE_PRIMARY_KEY =@"_id";
NSString *const ID =@"id";
NSString *const QUANTITY =@"quantity";
NSString *const WEIGHT =@"weight";
NSString *const ITEM_CODE =@"item_code";
NSString *const ATTRIBUTES=@"attributs";
NSString *const VARIENTID=@"variant_id";
NSString *const IMAGE_URL =@"image_url";
NSString *const THUMBNAIL_IMAGE_URL =@"thumbnail_image_url";
NSString *const PRICE =@"price";
NSString *const OLD_PRICE =@"old_price";
NSString *const AVAILABILITY =@"availability";
NSString *const PRODUCT_TAG = @"tag";

NSString *const databaseFilename=@"databaseV4.sqlite3";


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
   // NSLog(@"can open");
    
    if([self isExist:product]){
        NSLog(@" exist kore ");
        if([product.varientID isEqualToString:@""]){
            NSString *qurrey=[NSString stringWithFormat:@"UPDATE 'cart_product_table' SET quantity=%@ where id=%@",product.QUANTITY,product.ID];
            bool ret=[database executeUpdate:qurrey];
            
            [database close];
            return ret;

        }else{
            NSString *qurrey=[NSString stringWithFormat:@"UPDATE 'cart_product_table' SET quantity=%@ where id=%@ AND variant_id='%@'",product.QUANTITY,product.ID,product.varientID];
            bool ret=[database executeUpdate:qurrey];
            
            [database close];
            return ret;
        }
    }else{
    
    
       
    
        BOOL b=[database executeUpdate:@"INSERT INTO 'cart_product_table' VALUES (NULL,?,?,?,?,?,?,?,?,?,?,?,?,?);",product.ID,product.name,product.QUANTITY,product.WEIGHT,product.ITEM_CODE,product.IMAGE_URL,product.THUMBNAIL_IMAGE_URL,product.PRICE,product.OLD_PRICE,product.attributs,product.varientID, product.AVAILABILITY,product.PRODUCT_TAG];
    
        
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
   // NSLog(@"can open");
    FMResultSet *result;
  //  NSLog(@"%@",product.SPECIAL_QUESTION_TEXT);

    if([product.varientID isEqualToString:@""]){
        result=[database executeQuery:@"SELECT * FROM 'cart_product_table' where id=?",product.ID];
    }else{

        result=[database executeQuery:@"SELECT * FROM 'cart_product_table' where id = ? AND variant_id = ?",product.ID,product.varientID];

    }

    
    if([result next])
    {
       // NSLog(@"%@",[result stringForColumnIndex:2]);
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
   // NSLog(@"can open");
    
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
   // NSLog(@"can open");
    
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
   // NSLog(@"can open");
    
    
    FMResultSet *s = [database executeQuery:@"SELECT * FROM 'cart_product_table' ORDER BY id"];
    while ([s next]) {

        Product *var=[[Product alloc]init];
    
        
        var=[var initProduct:[s stringForColumn:name] productId:[s stringForColumn:ID] Quantity:[s stringForColumn:QUANTITY] Weight:[s stringForColumn:WEIGHT] code:[s stringForColumn:ITEM_CODE]attributs:[s stringForColumn:ATTRIBUTES] varient:[s stringForColumn:VARIENTID] imageURL:[s stringForColumn:IMAGE_URL] thumbImage:[s stringForColumn:THUMBNAIL_IMAGE_URL] price:[s stringForColumn:PRICE] oldPrice:[s stringForColumn:OLD_PRICE] availabl:[s intForColumn:AVAILABILITY] tag:[s stringForColumn:PRODUCT_TAG]] ;

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
   // NSLog(@"can open");
    
    NSString *qurrey=[NSString stringWithFormat:@"UPDATE 'cart_product_table' SET quantity=%d where id=%@",quantity,row];
    bool ret=[database executeUpdate:qurrey];

 //   NSLog(@"%d",ret);
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
    
  //  NSLog(@"%@",str);
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


+(BOOL)insertDeleveryMethodData:(DeleveryMethod *)deleveryMethod{
    
    NSString* homeDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *databasePath = [homeDir stringByAppendingPathComponent:databaseFilename];
    
    
    FMDatabase *database = [FMDatabase databaseWithPath:databasePath];
    
    if (![database open]) {
        
        NSLog(@"cant open");
        
        return NO;
    }
   // NSLog(@"can open");
    
    NSString *query;
    if(deleveryMethod._id==0){
        query = [NSString stringWithFormat:@"INSERT INTO 'customer_data_table' VALUES (NULL,'%@','%@','%@','%@','%@','%@','%d' ,'%d');",deleveryMethod.name,deleveryMethod.email,deleveryMethod.phone,deleveryMethod.branchName,deleveryMethod.address,deleveryMethod.comment,deleveryMethod.paymentMethod,deleveryMethod.type];
        

    }else{
     
        query=[NSString stringWithFormat:@"UPDATE 'customer_data_table' SET name='%@' , email='%@' , phone='%@' , branch='%@' , address='%@' , comment='%@' , paymentMethod=%d , collectMethod=%d where id=%d",deleveryMethod.name,deleveryMethod.email,deleveryMethod.phone,deleveryMethod.branchName,deleveryMethod.address,deleveryMethod.comment,deleveryMethod.paymentMethod,deleveryMethod.type,deleveryMethod._id];
    }
    
    
    BOOL b=[database executeUpdate:query];
    
    
    
    [database close];
    return b;
}
+(NSMutableArray *)getDeleveryMethods:(int) type{
 
    
    NSMutableArray *array=[[NSMutableArray alloc]init];
    
    NSString* homeDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *databasePath = [homeDir stringByAppendingPathComponent:databaseFilename];
    
    
    
    FMDatabase *database = [FMDatabase databaseWithPath:databasePath];
    
    
    
    if (![database open]) {
        
        return nil;
    }
   // NSLog(@"can open %d",type);

    NSString *querry = [NSString stringWithFormat:@"SELECT * FROM 'customer_data_table' where collectMethod=%d",type];
    
    FMResultSet *s = [database executeQuery:querry];
    NSLog(@"querry done");
    while ([s next]) {
        DeleveryMethod *obj=[[DeleveryMethod alloc]init];
        [obj initDeleveryMethod:[s intForColumn:@"id"] name:[s stringForColumn:@"name"] email:[s stringForColumn:@"email"] phone:[s stringForColumn:@"phone"] branchName:[s stringForColumn:@"branch"] address:[s stringForColumn:@"address"] comment:[s stringForColumn:@"comment"]
            payment:[s intForColumn:@"paymentMethod"] type:[s intForColumn:@"collectMethod"]];
        
        [array addObject:obj];

    }
    
    [database close];
    
    return array;
}


@end
