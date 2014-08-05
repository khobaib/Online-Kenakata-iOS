//
//  UserData.m
//  OnlineKenakata
//
//  Created by Apple on 8/5/14.
//  Copyright (c) 2014 OnlineKenakata. All rights reserved.
//

#import "UserData.h"
#import "DeleveryMethod.h"
#import "SelfCollect.h"
#import "Delivery.h"

@interface UserData ()

@end

@implementation UserData

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tableData.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
 

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userDataCell" forIndexPath:indexPath];
    
    // Configure the cell...
    if(self.tableData.count==0){
        
        
        return cell;
    }
    UILabel *name=(UILabel *)[cell viewWithTag:801];
    UILabel *email=(UILabel *)[cell viewWithTag:802];
    
    DeleveryMethod *obj =[self.tableData objectAtIndex:indexPath.row];
    name.text=obj.name;
    email.text=obj.email;
    return cell;
}

-(IBAction)addNew:(id)sender{
 
    if(self.type==1){
        SelfCollect *vc=[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"selfCollect"];
        vc.productList=self.productList;
        [self.navigationController pushViewController:vc animated:YES];
    }else if(self.type==2){
        Delivery *vc=[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"delivery"];
        vc.productList=self.productList;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DeleveryMethod *method=[self.tableData objectAtIndex:indexPath.row];
    if(self.type==1){
        SelfCollect *vc=[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"selfCollect"];
        vc.productList=self.productList;
        vc.method=method;
        [self.navigationController pushViewController:vc animated:YES];
    }else if(self.type==2){
        Delivery *vc=[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"delivery"];
        vc.productList=self.productList;
        vc.method=method;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
