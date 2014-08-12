//
//  Review.m
//  OnlineKenakata
//
//  Created by Apple on 8/12/14.
//  Copyright (c) 2014 OnlineKenakata. All rights reserved.
//

#import "Review.h"

@interface Review ()

@end

@implementation Review

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
    [self setValueOntop];
    // Do any additional setup after loading the view.
}
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
    
    EDStarRating *star=(EDStarRating *)[cell viewWithTag:902];
    [self StarSetter:star number:(float)indexPath.row];
    
    return cell;
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
