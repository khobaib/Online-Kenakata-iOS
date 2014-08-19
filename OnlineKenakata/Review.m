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

#define rowHeight 150;
#define descriptionWidth 283;
#define descriptionHeight 60;

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
    
    NSString *string = [NSString stringWithFormat:@"%@/rest.php?method=get_products_by_productids&product_ids=%@&application_code=%@",[Data getBaseUrl],self.productID,[Data getAppCode]];

    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    // NSLog(@"%@",string);
    // 2
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
    
    // 5
    //  [self.indecator startAnimating];
    loading.hidden=NO;
    [loading StartAnimating];
    [operation start];

    
    
}

-(void)parsReview:(id)respons{
    [loading StopAnimating];
    loading.hidden=YES;
    NSMutableDictionary *dic1=(NSMutableDictionary *)respons;
    NSMutableDictionary *dic=[[[dic1 objectForKey:@"success"]objectForKey:@"products"]objectAtIndex:0];
    reviews=[[dic objectForKey:@"review_detail"]objectForKey:@"reviews"];
    averageRating=[[dic objectForKey:@"review_detail"]objectForKey:@"average_rating"];
    distribution=[[dic objectForKey:@"review_detail"]objectForKey:@"distribution"];
    
    
    [self StarSetter:self.TotalRating number:[averageRating floatValue]];
    

    [self starBar];   // NSLog(@"%@",dic);
    float height=30+192+reviews.count*rowHeight;
    
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
    return reviews.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSMutableDictionary *dic=[reviews objectAtIndex:indexPath.row];
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"reviewCell" forIndexPath:indexPath];
    
    UILabel *titile=(UILabel *)[cell viewWithTag:901];
    titile.text=[dic objectForKey:@"title"];//@"This product is very good , i am in love with this product";
    UITextView *description=(UITextView *)[cell viewWithTag:904];

   

    
    NSString *string =[dic objectForKey:@"detail"];//description.text;//[self.productData objectForKey:@"description"];
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12]};
   
    CGRect rect = [string boundingRectWithSize:CGSizeMake(283, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
  
      /* if(isdataloaded){
        if ([[isSelected objectAtIndex:indexPath.row]boolValue]) {
            NSLog(@"now true");
            
            
            UIButton *btn=(UIButton *)[cell viewWithTag:indexPath.row];
            [btn removeFromSuperview];
            [description setScrollEnabled:YES];
            [description setText:string];
            
            [description sizeToFit];
            
            
            [description setScrollEnabled:NO];
            [isSelected replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:NO]];
        }else{
            [description setText:string];
        }
        
    }
    */
    description.text=string;
    if(rect.size.height>63){
        //float y=description.frame.origin.y+description.frame.size.height+5;
       UIButton *btn=[[UIButton alloc]initWithFrame:CGRectMake(0, cell.frame.size.height-20, 290, 20)];
        [btn setTitle:@"Read More" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        btn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
        
        [btn setBackgroundColor:[UIColor colorWithRed:(205.0f/255.0f) green:(201.0f/255.0f) blue:(201.0f/255.0f) alpha:1]];
        [btn addTarget:self action:@selector(readmoreButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag=indexPath.row;
        [cell addSubview:btn];
        
    }
    

    

 
    EDStarRating *star=(EDStarRating *)[cell viewWithTag:902];
    [self StarSetter:star number:[[dic objectForKey:@"rating"] floatValue]];
    
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableDictionary *dic=[reviews objectAtIndex:indexPath.row];
    NSString *string =[dic objectForKey:@"detail"];//description.text;//[self.productData objectForKey:@"description"];
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12]};
    
    CGRect rect = [string boundingRectWithSize:CGSizeMake(283, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    
    if(rect.size.height>63 && [[isSelected objectAtIndex:indexPath.row]boolValue]){
     
        NSLog(@"update hight FOR index %d",indexPath.row);
        float result=rect.size.height+rowHeight;
       // NSLog(@"%f",result);
        [self updateHeight:self.heightConstraint.constant+result];
        
        return result;
    }else if (rect.size.height>63 ){
        return 25+rowHeight;
    }

    return rowHeight;
}

-(IBAction)readmoreButtonClicked:(id)sender{
    UIButton *readMoreButton = (UIButton *)sender;
    indexOfReadMoreButton=[readMoreButton tag];
    [isSelected replaceObjectAtIndex:indexOfReadMoreButton withObject:[NSNumber numberWithBool:YES]];
    [[self tableview] reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForItem: indexOfReadMoreButton inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    //[self.tableview reloadData];
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

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    WriteReviewViewController *wrvc=(WriteReviewViewController *)[segue destinationViewController];
    wrvc.productID=self.productID;
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
