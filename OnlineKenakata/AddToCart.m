//
//  AddToCart.m
//  OnlineKenakata
//
//  Created by Rabby Alam on 7/17/14.
//  Copyright (c) 2014 OnlineKenakata. All rights reserved.
//

#import "AddToCart.h"
#import "UIImageView+WebCache.h"


@interface AddToCart ()

@end

@implementation AddToCart

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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    NSMutableDictionary *dic = [ud objectForKey:@"get_user_data"];
    
    currency=[[[dic objectForKey:@"success"]objectForKey:@"user"]objectForKey:@"currency"];
    
    


    [self setValueOnUI];

}

- (void)setValueOnUI
{
    self.name.text=[self.productData objectForKey:@"name"];
    
    
    NSString * imgurl = [[[self.productData objectForKey:@"images"] objectAtIndex:0]objectForKey:@"thumbnail_image_url"];

    [self.thumbnil setImageWithURL:[NSURL URLWithString:imgurl]
             placeholderImage:[UIImage imageNamed:@"placeholder.gif"]];
    
    int tag = (int)[[self.productData objectForKey:@"tag"] integerValue];
    
    NSString *spclqus=[self.productData objectForKey:@"special_question"];
    if([spclqus isEqualToString:@""]){
        self.specialQuestionView.hidden=YES;
        
       // pickerData=[[NSMutableArray alloc]initWithCapacity:[[self.productData objectForKey:@"general_available_quantity"]integerValue]];
        flag=true;
        quantity=[[self.productData objectForKey:@"general_available_quantity"]intValue];

    }else{
        
        self.quantitybtn.enabled=NO;
        self.specialQuestionLable.text=spclqus;
        
        pickerData=[self.productData objectForKey:@"special_answers"];
        flag=false;
    }
    if(tag==1){
        self.oldPrice.text=[NSString stringWithFormat:@"%@ %@",currency,[self.productData objectForKey:@"price"]];
        self.tooping.image=[UIImage imageNamed:@"tag_new.png"];

    }else if (tag==2){
        self.tooping.image=[UIImage imageNamed:@"tag_sale.png"];

        NSMutableAttributedString *attString=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ %@",currency,[self.productData objectForKey:@"old_price"]]];
        
        [attString addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInt:1] range:NSMakeRange(0,[attString length])];
        self.oldPrice.attributedText = attString;
        
        
        self.priceNew.text=[NSString stringWithFormat:@"%@ %@",currency,[self.productData objectForKey:@"price"]];
        
    }else{
        self.oldPrice.text=[NSString stringWithFormat:@"%@ %@",currency,[self.productData objectForKey:@"price"]];
        
    }
    
        
    int available =[[self.productData objectForKey:@"general_available_quantity"]intValue];
    if(available>0){
        self.itemCode.text=[self.productData objectForKey:@"sku"];
        
    }else{
        self.itemCode.hidden=YES;
        //self.itemCodeLable.hidden=YES;
    }
}



-(IBAction)quantity:(id)sender{
    if(!flag){
        return;
    }
    RMPickerViewController *pickerVC = [RMPickerViewController pickerController];
    pickerVC.delegate = self;
    
    [pickerVC show];
    
}

-(IBAction)spclQus:(id)sender{
    RMPickerViewController *pickerVC = [RMPickerViewController pickerController];
    pickerVC.delegate = self;
    
    [pickerVC show];

}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if(flag){
        return quantity;
    }else{
     return pickerData.count;
    }
    
}

- (void)pickerViewController:(RMPickerViewController *)vc didSelectRows:(NSArray *)selectedRows{
    
    if(flag){

        NSString *str=[NSString stringWithFormat:@"%d",[[selectedRows objectAtIndex:selectedRows.count-1]intValue]+1];
        
        [self.quantitybtn setTitle:str forState:UIControlStateNormal];
        
    }else{
     
       int i=[[selectedRows objectAtIndex:selectedRows.count-1]intValue];
        NSString *str=[[pickerData objectAtIndex:i]objectForKey:@"answer"];
        
        [self.specialQuestion setTitle:str forState:UIControlStateNormal];
        
        flag=true;
        quantity=[[[pickerData objectAtIndex:i]objectForKey:@"available_quantity"]intValue];
        
        self.quantitybtn.enabled=YES;
    }
    
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if(flag){
        return [NSString stringWithFormat:@"%d",row+1];
    }else{
        NSString *str =[[pickerData objectAtIndex:row]objectForKey:@"answer"];
        return str;
    }
}

- (void)pickerViewControllerDidCancel:(RMPickerViewController *)vc{
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
