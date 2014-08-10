//
//  MapView.h
//  OnlineKenakata-Demo
//
//  Created by Rabby Alam on 7/12/14.
//  Copyright (c) 2014 rabbi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMPickerViewController.h"
#import <MapKit/MapKit.h>


@interface MapView : UIViewController<RMPickerViewControllerDelegate,MKMapViewDelegate,UIActionSheetDelegate>{
    UIActionSheet *sheet;
    NSMutableArray *branches;
    
    NSMutableDictionary *selectedBranch;
    UIButton *cart;
}

@property (strong,nonatomic) IBOutlet UIPickerView *pickerView;
@property (strong,nonatomic) IBOutlet MKMapView *mapView;
@end
