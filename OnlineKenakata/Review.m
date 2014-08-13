//
//  Review.m
//  OnlineKenakata
//
//  Created by Apple on 8/12/14.
//  Copyright (c) 2014 OnlineKenakata. All rights reserved.
//

#import "Review.h"
#import "TextStyling.h"

#define rowHeight 130;

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
    [super viewWillAppear:animated];
    float height=30+192+5*rowHeight;
    if(isReadMoreButtonTouched [0]){
        NSLog(@"true :(");
    }
    [self updateHeight:height];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setValueOntop];
    [self statBar];
    
   
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
    return 5;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"reviewCell" forIndexPath:indexPath];
    
    UILabel *titile=(UILabel *)[cell viewWithTag:901];
    titile.text=@"This product is very good , i am in love with this product";
    UITextView *description=(UITextView *)[cell viewWithTag:904];

    UIButton *btn=(UIButton *)[cell viewWithTag:905];
   

    if(indexPath.row==3){
        description.text=@"good";
    }
    
    NSString *string =description.text;//[self.productData objectForKey:@"description"];
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12]};
    NSString *str=@"kfhkjfhkf kfhkf sfkh kfshksfg skfh skfskfhskfhskfhksfhkfshksfhksfhskfhskf ksfhsfkh skfhsdkfh skf hk skfhksfhg sfkhgsdfiugs sfhsiusiruh sifh shishfvsuhviusfhgurruh ifhfurhrufh aeuhfurh rufhufurfhur irfhrif ";
    CGRect rect = [string boundingRectWithSize:CGSizeMake(description.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    
    if(isReadMoreButtonTouched[indexOfReadMoreButton] && [indexPath row]== indexOfReadMoreButton)
    {
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12]};
        
        CGRect rect = [str boundingRectWithSize:CGSizeMake(description.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
        
   
    
        [description setFrame:rect];
        description.attributedText=[TextStyling AttributForDescription:str];

    }else{
        
        if(rect.size.height<=description.frame.size.height){
            
            btn.hidden=YES;
            
        }
        
        
    }
   
  
   
    
    
    EDStarRating *star=(EDStarRating *)[cell viewWithTag:902];
    [self StarSetter:star number:(float)indexPath.row];
    
    btn.tag=indexPath.row;
    
    isReadMoreButtonTouched[indexPath.row]=NO;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(isReadMoreButtonTouched[indexOfReadMoreButton] && [indexPath row]== indexOfReadMoreButton){
        [self updateHeight: self.heightConstraint.constant+130];
        return 300.0f;
    }
    else return rowHeight;
}

-(IBAction)remoreButtonClicked:(id)sender{
    UIButton *readMoreButton = (UIButton *)sender;
    indexOfReadMoreButton=[readMoreButton tag];
    isReadMoreButtonTouched[indexOfReadMoreButton]=!isReadMoreButtonTouched[indexOfReadMoreButton];
    
    [[self tableview] beginUpdates];
    [[self tableview] reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForItem: indexOfReadMoreButton inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    [[self tableview] endUpdates];
}

-(void)statBar{
    int x =0;
    int y=5;
    int diffY=20;
    float totalWidth=self.barContainer.frame.size.width;
    int totalVote=1854;
    float x5=720.0;
    float x4=410.0;
    float x3=12;
    float x2=346.0;
    float x1=366;
    
    float ratio=totalWidth/totalVote;
    
    NSLog(@"%f   ,%f",ratio,totalWidth);

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
