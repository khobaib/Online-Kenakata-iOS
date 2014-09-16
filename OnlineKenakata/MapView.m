//
//  MapView.m
//  OnlineKenakata-Demo
//
//  Created by Rabby Alam on 7/12/14.
//  Copyright (c) 2014 rabbi. All rights reserved.
//

#import "MapView.h"
#import "PushPin.h"
#import <AddressBook/AddressBook.h>
#import "TextStyling.h"
#import "tabbarController.h"

@interface MapView ()

@end

#define METERS_PER_MILE 1609.344

@implementation MapView

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

    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
   // NSDictionary *retrievedDictionary = [NSKeyedUnarchiver unarchiveObjectWithData:data];

    NSDictionary *dic = [NSKeyedUnarchiver unarchiveObjectWithData:[ud objectForKey:@"get_user_data"]];

    

    branches=[[[dic objectForKey:@"success"]objectForKey:@"user"]objectForKey:@"branches"];
    //selectedBranch=[branches objectAtIndex:0];
    NSLog(@"branches %@",branches);
    if(branches.count==0){
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Shop has no branch" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        
        [alertView show];
        
    }else{
        [self plotPushPin];
        
        [self branches];
    }
    
}

- (void)initBarbutton {
    
    UIBarButtonItem *btnBranch = [[UIBarButtonItem alloc] initWithTitle:@"Branches" style:UIBarButtonItemStylePlain target:self action:@selector(branches)];
    
    [btnBranch setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:[TextStyling barbuttonColor], NSForegroundColorAttributeName,nil]
                             forState:UIControlStateNormal];
    
    UIBarButtonItem *btnDirection = [[UIBarButtonItem alloc] initWithTitle:@"Direction" style:UIBarButtonItemStylePlain target:self action:@selector(direction)];
    
    [btnDirection setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[TextStyling barbuttonColor], NSForegroundColorAttributeName,nil]
                                forState:UIControlStateNormal];
   
    
    for(UIView* view in self.tabBarController.navigationController.navigationBar.subviews)
    {
        if(view.tag ==1)
        {
            view.hidden=YES;
        }
    }

    [self.tabBarController.navigationItem setRightBarButtonItem:btnDirection];
    [self.tabBarController.navigationItem setLeftBarButtonItem:btnBranch];
    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(!branches.count==0){
        
        [self initBarbutton];
        [self goTolocation:0];
    }
    
    self.tabBarController.navigationItem.title=@"Location";

    
   
}
-(void)viewWillDisappear:(BOOL)animated{
    
    
    [super viewWillDisappear:animated];

    for(UIView* view in self.tabBarController.navigationController.navigationBar.subviews)
    {
        if(view.tag ==1)
        {
            view.hidden=NO;
        }
    }

    [self.tabBarController.navigationItem setLeftBarButtonItem:nil];
    [self.tabBarController.navigationItem setRightBarButtonItem:nil];

}


-(void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
    
    
    
}

-(void)plotPushPin{
    
    for (id<MKAnnotation> annotation in _mapView.annotations) {
        [self.mapView removeAnnotation:annotation];
    }
    
    for(int i=0;i<branches.count;i++){
        float lat=[[[branches objectAtIndex:i]objectForKey:@"branch_latitude"]floatValue];
        float ln=[[[branches objectAtIndex:i]objectForKey:@"branch_longitude"]floatValue];
        CLLocationCoordinate2D zoomLocation;
        zoomLocation.latitude = lat;
        zoomLocation.longitude= ln;
        NSString *name=[[branches objectAtIndex:i]objectForKey:@"branch_address"];
        PushPin *annotation = [[PushPin alloc] initWithName:name address:@"" coordinate:zoomLocation] ;
        [self.mapView addAnnotation:annotation];
    }
}


-(void)goTolocation:(int) index{
    float lat=[[[branches objectAtIndex:index]objectForKey:@"branch_latitude"]floatValue];
    float ln=[[[branches objectAtIndex:index]objectForKey:@"branch_longitude"]floatValue];
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = lat;
    zoomLocation.longitude= ln;

    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.75*METERS_PER_MILE, 0.75*METERS_PER_MILE);
    
    [self.mapView setRegion:viewRegion animated:YES];
}


- (void)pickerViewController:(RMPickerViewController *)vc didSelectRows:(NSArray  *)selectedRows {
    //Do something
    int index=[[selectedRows objectAtIndex:selectedRows.count-1]intValue];
    selectedBranch=[branches objectAtIndex:index];
    [self goTolocation:index];

}

- (void)pickerViewControllerDidCancel:(RMPickerViewController *)vc {
    //Do something else
}


-(void)branches{

    
    RMPickerViewController *pickerVC = [RMPickerViewController pickerController];
    pickerVC.delegate = self;
    
    [pickerVC show];
}


-(void)direction{

    if(selectedBranch==nil){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Please select a Branch."
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
        
        return;
    }
    
    
    [self showMapChooser];
    
    //NSString *address=[selectedBranch objectForKey:@"branch_address"];
    //CLLocationCoordinate2D location = [[[self.mapView userLocation] location] coordinate];
 /*
    MKMapItem *item = [self mapItemCoord:coord address:address];

    MKMapItem *source=[self mapItemCoord:location address:@"Current Location"];
    
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    [request setSource:source];
   // NSLog(@"%f ",[MKMapItem mapItemForCurrentLocation].placemark.coordinate.latitude);
    
    [request setDestination:item];
    [request setTransportType:MKDirectionsTransportTypeAny]; // This can be limited to automobile and walking directions.
    [request setRequestsAlternateRoutes:YES]; // Gives you several route options.
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        NSLog(@"code block %@",error);
        if (!error) {
            for (MKRoute *route in [response routes]) {
                [self.mapView addOverlay:[route polyline] level:MKOverlayLevelAboveRoads]; // Draws the route above roads, but below labels.
                // You can also get turn-by-turn steps, distance, advisory notices, ETA, etc by accessing various route properties.
            }
            

        }
    }];
    */
    
}
-(void)showMapChooser{
    
    
    if(([[UIApplication sharedApplication]canOpenURL:
         [NSURL URLWithString:@"comgooglemaps://"]]) && ([[UIApplication sharedApplication]
                                                          canOpenURL:[NSURL URLWithString:@"waze://"]]) )
    
    {
        
        UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"Select App for Direction:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                                @"Google Map",
                                @"Waze",
                                
                                nil];
        popup.tag = 1;
        [popup showInView:[UIApplication sharedApplication].keyWindow];

        
    }else if ([[UIApplication sharedApplication]canOpenURL:
               [NSURL URLWithString:@"comgooglemaps://"]]){
        
        UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"Select App for Direction:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                                @"Google Map",
                                
                                nil];
        popup.tag = 2;
        [popup showInView:[UIApplication sharedApplication].keyWindow];
        

        
    }else if ([[UIApplication sharedApplication]
               canOpenURL:[NSURL URLWithString:@"waze://"]]){
        UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"Select App for Direction:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                                @"Waze",
                               
                                nil];
        popup.tag = 3;
        [popup showInView:[UIApplication sharedApplication].keyWindow];
        
     
    }else{
        
        CLLocationCoordinate2D coord;
        coord.latitude=[[selectedBranch objectForKey:@"branch_latitude"]floatValue];
        coord.longitude=[[selectedBranch objectForKey:@"branch_longitude"]floatValue];
        [self navigateToLatitude:coord.latitude longitude:coord.longitude option:2];

        
   
    }
    
    
}


- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    CLLocationCoordinate2D coord;
    coord.latitude=[[selectedBranch objectForKey:@"branch_latitude"]floatValue];
    coord.longitude=[[selectedBranch objectForKey:@"branch_longitude"]floatValue];
    


    switch (popup.tag) {
        case 1:
            [self navigateToLatitude:coord.latitude longitude:coord.longitude option:(int)buttonIndex];
            
        case 2:
            switch (buttonIndex) {
                case 0:
                    [self navigateToLatitude:coord.latitude longitude:coord.longitude option:0];

                    break;
                case 1:
                    [self navigateToLatitude:coord.latitude longitude:coord.longitude option:2];

                    break;
                    
                default:
                    break;
            }
            
        case 3:
            switch (buttonIndex) {
                case 0:
                    [self navigateToLatitude:coord.latitude longitude:coord.longitude option:1];

                    break;
                case 1:
                    [self navigateToLatitude:coord.latitude longitude:coord.longitude option:2];

                    break;
                    
                default:
                    break;
            }
        default:
            break;
    }

}



- (void) navigateToLatitude:(double)latitude longitude:(double)longitude option:(int) index
{
    NSString *url;
    
    switch (index) {
        case 0:
             url=[NSString stringWithFormat:@"comgooglemaps://?daddr=%f,%f",latitude,longitude];

            break;
        case 1:
            
            url=[NSString stringWithFormat:@"waze://?ll=%f,%f&navigate=yes",latitude, longitude];
            break;
        case 2:{
           
            CLLocationCoordinate2D location = [[[self.mapView userLocation] location] coordinate];

            url=[NSString stringWithFormat:@"http://www.google.com/maps/dir/%f,%f/%f,%f",location.latitude,location.longitude,latitude,longitude];
            
            break;
        }
            
        default:
            break;
    }
    
   // NSLog(@"%@",url);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];

}



- (MKMapItem*)mapItemCoord:(CLLocationCoordinate2D )coordinate address:(NSString *)address{
    NSDictionary *addressDict = @{(NSString*)kABPersonAddressStreetKey : address};
    
    MKPlacemark *placemark = [[MKPlacemark alloc]
                              initWithCoordinate:coordinate
                              addressDictionary:addressDict];
    
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    mapItem.name = self.title;
    
    return mapItem;
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
        [renderer setStrokeColor:[UIColor blueColor]];
        [renderer setLineWidth:5.0];
        return renderer;
    }
    return nil;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
 
    return branches.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *name=[[branches objectAtIndex:row] objectForKey:@"branch_address"];
    return name;
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
  //  NSLog(@"%@",[branches objectAtIndex:row]);
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
