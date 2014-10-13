//
//  Review.m
//  OnlineKenakata
//
//  Created by Apple on 8/12/14.
//  Copyright (c) 2014 OnlineKenakata. All rights reserved.
//

#import "Review.h"
#import "TextStyling.h"
#import "AFNetworking/AFNetworking.h"
#import "Data.h"
#import "WriteReviewViewController.h"
#import "LoginViewController.h"

#define rowHeight 135;
#define rowHeight2 157;
#define descriptionWidth 283;
#define descriptionHeight 60;
#define textHeight 66;

@interface Review ()



@end

@implementation Review
int indexOfReadMoreButton;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)viewWillAppear:(BOOL)animated{

    [self initLoading];
    [self loadData];
    
    isdataloaded=NO;
    
    [super viewWillAppear:animated];
   

}
- (void)viewDidLoad
{
    [super viewDidLoad];
   // [self setValueOntop];
   // [self statBar];
    
   
}

-(void)loadData{
    
    NSString *string = [NSString stringWithFormat:@"%@/rest_kenakata.php?method=get_reviews&product_id=%@&application_code=%@",[Data getBaseUrl],self.productID,[Data getAppCode]];

    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    NSString *token=(NSString *)[ud objectForKey:@"token"];
    if(token!=nil){
        
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        NSMutableDictionary *params=[[NSMutableDictionary alloc]init];
        [params setObject:token forKey:@"token"];
        
        [manager POST:string parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            [self parsReview:responseObject];
            
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            // 4
            loading.hidden=YES;
            [loading StopAnimating];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error catagory List"
                                                                message:[error localizedDescription]
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
            [alertView show];
        }];
        
        
        
        
    }else{
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        
        operation.responseSerializer = [AFJSONResponseSerializer serializer];
        
        
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            [self parsReview:responseObject];
            
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            // 4
            loading.hidden=YES;
            [loading StopAnimating];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error catagory List"
                                                                message:[error localizedDescription]
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
            [alertView show];
        }];
        
        
        [operation start];
        
    }
    
    
    
    
    // 5
    //  [self.indecator startAnimating];
    loading.hidden=NO;
    [loading StartAnimating];

    
}

-(void)parsReview:(id)respons{
    [loading StopAnimating];
    loading.hidden=YES;
    NSMutableDictionary *dic1=(NSMutableDictionary *)respons;
    NSMutableDictionary *dic=[[dic1 objectForKey:@"success"]objectForKey:@"review_detail"];
    

    reviews=[dic objectForKey:@"reviews"];
    averageRating=[dic objectForKey:@"average_rating"];
    distribution=[dic objectForKey:@"distribution"];
    userReview=[dic objectForKey:@"user_review"];
    if(userReview!=nil){
        self.writeReviewButton.hidden=YES;
    }
    
    if([averageRating isEqualToString:@""]){
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Rating unavailable" message:@"No review is available" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    [self StarSetter:self.TotalRating number:[averageRating floatValue]];
    

    [self starBar];   // NSLog(@"%@",dic);
    
    
    float height=30+192+reviews.count*rowHeight2;
    
    [self updateHeight:height];
    [self.tableview reloadData];
    isSelected=[[NSMutableArray alloc]init];
    
    for (int i=0; i<reviews.count;i++) {
        [isSelected addObject:[NSNumber numberWithBool:NO]];
    }
    isdataloaded=YES;
}
-(void)initLoading{
    CGFloat x= self.view.frame.size.width/2-65;
    CGFloat y =(self.view.frame.size.height-self.navigationController.navigationBar.frame.size.height-self.tabBarController.tabBar.frame.size.height)/2-25;
    
    loading=[[LoadingView alloc]initWithFrame:CGRectMake(x, y, 130, 50)];
    loading.hidden=YES;
    [self.view addSubview:loading];
}


-(void)updateHeight:(int)height{
    self.heightConstraint.constant =height; //self.description.contentSize.height;
    
    
    [self.scrollview setContentSize:CGSizeMake(320, height)];
}
    // Do any additional setup after loading the view.

-(void)setValueOntop{
    [self StarSetter:self.TotalRating number:3.7];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if(userReview==nil){
        return reviews.count;

    }else{
        return reviews.count+1;

    }
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dic;
    if((userReview!=nil && indexPath.row==0)){
        
        dic=userReview;
    }else{
        if(userReview!=nil){
            dic=[reviews objectAtIndex:indexPath.row-1];
            
        }else{
            dic=[reviews objectAtIndex:indexPath.row];
            
        }
        
    }

    NSString *string =[dic objectForKey:@"detail"];//description.text;//[self.productData objectForKey:@"description"];
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12]};
   
    CGRect rect = [string boundingRectWithSize:CGSizeMake(283, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
  
  
    if(rect.size.height>66){
        
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"readMoreCell" forIndexPath:indexPath];
        
        if((userReview!=nil && indexPath.row==0)){
            return [self userReview:cell];
        }
        
  
        UIButton *Btn=(UIButton *) [cell viewWithTag:905];
        Btn.hidden=YES;
        
        UILabel *titile=(UILabel *)[cell viewWithTag:901];
        titile.text=[dic objectForKey:@"title"];//@"This product is very good , i am in love with this product";
        UILabel *nameDate=(UILabel *)[cell viewWithTag:903];
        NSString *name=[dic objectForKey:@"name"];
        NSString *dateStr=[dic objectForKey:@"date"];
        
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"YYYY-MM-DD"];
        

        nameDate.text=[NSString stringWithFormat:@"By %@ %@",name,dateStr];
        
        UITextView *description=(UITextView *)[cell viewWithTag:904];
        [description setTextColor:[UIColor grayColor]];
        [description setFont:[UIFont systemFontOfSize:14]];
        description.text=[dic objectForKey:@"detail"];
        EDStarRating *star=(EDStarRating *)[cell viewWithTag:902];
        [self StarSetter:star number:[[dic objectForKey:@"rating"] floatValue]];
        
          //  NSLog(@"%f",description.frame.size.height);
            
        
        return cell;
        
       
        
    }else{
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"reviewCell" forIndexPath:indexPath];
        
        if((userReview!=nil && indexPath.row==0)){
            return [self userReview:cell];
        }
        
        UIButton *Btn=(UIButton *) [cell viewWithTag:905];
        Btn.hidden=YES;
        UILabel *titile=(UILabel *)[cell viewWithTag:901];
        titile.text=[dic objectForKey:@"title"];//@"This product is very good , i am in love with this product";
        
        UILabel *nameDate=(UILabel *)[cell viewWithTag:903];
        NSString *name=[dic objectForKey:@"name"];
        NSString *dateStr=[dic objectForKey:@"date"];
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyy-MM-dd"];
        
        NSDate *date=[df dateFromString:dateStr];
        
      //  NSLog(@"date %@",date);
        
        nameDate.text=[NSString stringWithFormat:@"By %@ %@",name,dateStr];
        
        UITextView *description=(UITextView *)[cell viewWithTag:904];
        [description setTextColor:[UIColor grayColor]];
        [description setFont:[UIFont systemFontOfSize:14]];
        description.text=[dic objectForKey:@"detail"];

        EDStarRating *star=(EDStarRating *)[cell viewWithTag:902];
        [self StarSetter:star number:[[dic objectForKey:@"rating"] floatValue]];
        return cell;

      

    }
    
 
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    NSDictionary *dic;
    if((userReview!=nil && indexPath.row==0)){
        
        dic=userReview;
    }else{
        if(userReview!=nil){
            dic=[reviews objectAtIndex:indexPath.row-1];

        }else{
            dic=[reviews objectAtIndex:indexPath.row];

        }
        
    }
    
    
    NSString *string =[dic objectForKey:@"detail"];//description.text;//[self.productData objectForKey:@"description"];
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12]};
    
    CGRect rect = [string boundingRectWithSize:CGSizeMake(283, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    
    if(rect.size.height>66 && [[isSelected objectAtIndex:indexPath.row]boolValue]){
     
      //  NSLog(@"update hight FOR index %ld",(long)indexPath.row);
        float result=rect.size.height+115;
        
       // NSLog(@"result %f  height%f",result,rect.size.height);
        [self updateHeight:self.heightConstraint.constant+result];
        
        return result;
    }else if(rect.size.height>66){
        return rowHeight2;
    }

    return rect.size.height+110;
}

-(IBAction)readmoreButtonClicked:(id)sender{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableview];
    NSIndexPath *indexPath = [self.tableview indexPathForRowAtPoint:buttonPosition];
    indexOfReadMoreButton=indexPath.row;
    UIButton *button=(UIButton *)sender;
    if([[isSelected objectAtIndex:indexOfReadMoreButton]boolValue]){
        
        NSMutableDictionary *dic=[reviews objectAtIndex:indexPath.row];
        
        
        NSString *string =[dic objectForKey:@"detail"];//description.text;//[self.productData objectForKey:@"description"];
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12]};
        
        CGRect rect = [string boundingRectWithSize:CGSizeMake(283, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
         float result=rect.size.height+110;
        [self updateHeight:self.heightConstraint.constant-result];

        [isSelected replaceObjectAtIndex:indexOfReadMoreButton withObject:[NSNumber numberWithBool:NO]];
        
        [self.tableview beginUpdates];
        [[self tableview] reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForItem: indexOfReadMoreButton inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableview endUpdates];
        [button setTitle:@"-View less" forState:UIControlStateNormal];

    }else{
        [isSelected replaceObjectAtIndex:indexOfReadMoreButton withObject:[NSNumber numberWithBool:YES]];
        
        [self.tableview beginUpdates];
        [[self tableview] reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForItem: indexOfReadMoreButton inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableview endUpdates];
        [button setTitle:@"+View More" forState:UIControlStateNormal];
        
    }
    
    //[self.tableview reloadData];
}

-(UITableViewCell *)userReview:(UITableViewCell *)cell{
    
    
    NSString *string =[userReview objectForKey:@"detail"];//description.text;//[self.productData objectForKey:@"description"];
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12]};
    
    CGRect rect = [string boundingRectWithSize:CGSizeMake(283, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
     EDStarRating *star=(EDStarRating *)[cell viewWithTag:902];
    
    
    if(rect.size.height>66){
        
       
        UILabel *titile=(UILabel *)[cell viewWithTag:901];
        titile.text=[userReview objectForKey:@"title"];//@"This product is very good , i am in love with this product";
        UILabel *nameDate=(UILabel *)[cell viewWithTag:903];
      
        
        nameDate.text=@"My Review";//[NSString stringWithFormat:@"By %@ %@",name,dateStr];
        
        UITextView *description=(UITextView *)[cell viewWithTag:904];
        [description setTextColor:[UIColor grayColor]];
        [description setFont:[UIFont systemFontOfSize:14]];
        description.text=[userReview objectForKey:@"detail"];
       
        [self StarSetter:star number:[[userReview objectForKey:@"rating"] floatValue]];
        
       
        
        
        
    }else{
        UILabel *titile=(UILabel *)[cell viewWithTag:901];
        titile.text=[userReview objectForKey:@"title"];//@"This product is very good , i am in love with this product";
        
        UILabel *nameDate=(UILabel *)[cell viewWithTag:903];
      
        
        nameDate.text=@"My Review";//[NSString stringWithFormat:@"By %@ %@",name,dateStr];
        
        UITextView *description=(UITextView *)[cell viewWithTag:904];
        [description setTextColor:[UIColor grayColor]];
        [description setFont:[UIFont systemFontOfSize:14]];
        description.text=[userReview objectForKey:@"detail"];
        

        [self StarSetter:star number:[[userReview objectForKey:@"rating"] floatValue]];
     }
    
    
   
    CGRect frame=star.frame;
    frame.origin.x=star.frame.origin.x+star.frame.size.width+10;
   // NSLog(@"%f  %f",frame.origin.x,frame.origin.y);
    UIButton *button = [[UIButton alloc]initWithFrame:frame];
    [button setTitle:@"Edit your review" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(editOwnReview:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:button];
    
    return cell;
}


-(IBAction)editOwnReview:(id)sender{
    //NSLog(@"%@",userReview);
    WriteReviewViewController *wrvc=[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"WriteReview"];
    wrvc.productID=self.productID;
    
    wrvc.userReview=userReview;
    [self.navigationController pushViewController:wrvc animated:YES];
}

-(void)starBar{
    int x =0;
    int y=5;
    int diffY=20;
    float totalWidth=self.barContainer.frame.size.width;
    //int totalVote=1854;
    float x5=[[distribution objectForKey:@"5"] floatValue];
    float x4=[[distribution objectForKey:@"4"] floatValue];
    float x3=[[distribution objectForKey:@"3"] floatValue];
    float x2=[[distribution objectForKey:@"2"] floatValue];
    float x1=[[distribution objectForKey:@"1"] floatValue];
    float totalVote=x5+x4+x3+x2+x1;
    float ratio=totalWidth/totalVote;
    

    UIView *bar11=[[UIView alloc]initWithFrame:CGRectMake(x, y, ratio*x5, 10)];
    [bar11 setBackgroundColor:[UIColor orangeColor]];
    
    UIView *bar21=[[UIView alloc]initWithFrame:CGRectMake((x+ratio*x5), y, totalWidth-ratio*x5, 10)];
    [bar21 setBackgroundColor:[UIColor grayColor]];
    
    
    y+=diffY;

    UIView *bar12=[[UIView alloc]initWithFrame:CGRectMake(x, y, ratio*x4, 10)];
    [bar12 setBackgroundColor:[UIColor orangeColor]];

    
    UIView *bar22=[[UIView alloc]initWithFrame:CGRectMake((x+ratio*x4), y, totalWidth-ratio*x4, 10)];
    [bar22 setBackgroundColor:[UIColor grayColor]];

    y+=diffY;
    UIView *bar13=[[UIView alloc]initWithFrame:CGRectMake(x, y, ratio*x3, 10)];
    [bar13 setBackgroundColor:[UIColor orangeColor]];
    
    UIView *bar23=[[UIView alloc]initWithFrame:CGRectMake((x+ratio*x3), y, totalWidth-ratio*x3, 10)];
    [bar23 setBackgroundColor:[UIColor grayColor]];

    y+=diffY;
    UIView *bar14=[[UIView alloc]initWithFrame:CGRectMake(x, y, ratio*x2, 10)];
    [bar14 setBackgroundColor:[UIColor orangeColor]];
    
    UIView *bar24=[[UIView alloc]initWithFrame:CGRectMake((x+ratio*x2), y, totalWidth-ratio*x2, 10)];
    [bar24 setBackgroundColor:[UIColor grayColor]];

    y+=diffY;
    UIView *bar15=[[UIView alloc]initWithFrame:CGRectMake(x, y, ratio*x1, 10)];
    [bar15 setBackgroundColor:[UIColor orangeColor]];

    
    UIView *bar25=[[UIView alloc]initWithFrame:CGRectMake((x+ratio*x1), y, totalWidth-ratio*x1, 10)];
    [bar25 setBackgroundColor:[UIColor grayColor]];
    
    
    [self.barContainer addSubview:bar11];
    [self.barContainer addSubview:bar12];
    [self.barContainer addSubview:bar13];
    [self.barContainer addSubview:bar14];
    [self.barContainer addSubview:bar15];


    [self.barContainer addSubview:bar21];
    [self.barContainer addSubview:bar22];
    [self.barContainer addSubview:bar23];
    [self.barContainer addSubview:bar24];
    [self.barContainer addSubview:bar25];

    

}

-(void)StarSetter:(EDStarRating *)star number:(float) number{
    star.starImage=[UIImage imageNamed:@"star.png"];
    star.starHighlightedImage=[UIImage imageNamed:@"starhighlighted.png"];
    
    star.maxRating = 5.0;
    
   star.horizontalMargin = 12;
   star.editable=NO;
   star.rating= number;
    
    
    star.displayMode=EDStarRatingDisplayAccurate;
    [star setNeedsDisplay];

}


#pragma mark - Navigation

-(IBAction)clickOnWriteReview:(id)sender{
    NSString *token=(NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    if(token!=nil){
        
        WriteReviewViewController *wrvc=[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"WriteReview"];
        wrvc.productID=self.productID;
        
        [self.navigationController pushViewController:wrvc animated:YES];
    }else{
        LoginViewController *loginVC=[[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"loginScreen"];
        
        [self.navigationController pushViewController:loginVC animated:YES];
    }

}
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    WriteReviewViewController *wrvc=(WriteReviewViewController *)[segue destinationViewController];
    wrvc.productID=self.productID;
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
