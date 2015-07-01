//
//  AddPinViewController.h
//  day5
//
//  Created by Student on 24.06.15.
//  Copyright (c) 2015 KBTU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "HistoricPlace.h"

@protocol AddPinViewControllerDelegate <NSObject>

-(void)didCancel;
-(void)didAdd:(HistoricPlace *)place;

@end

@interface AddPinViewController : UIViewController

@property (weak) id<AddPinViewControllerDelegate> delegate;
@property (nonatomic) HistoricPlace *place;

@end
