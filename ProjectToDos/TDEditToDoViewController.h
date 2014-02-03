//
//  TDEditToDoViewController.h
//  ProjectToDos
//
//  Created by Stephan Chang on 1/28/14.
//  Copyright (c) 2014 The ToDo Party. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDToDo.h"

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "SL_armazenaDados.h"
#import "SL_Localidades.h"


@interface TDEditToDoViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate>
@property (strong, nonatomic) TDToDo *toDo;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *location;

-(void) freshLatitudeLongitude : (SL_Localidades*)local with: (BOOL)estaNaRegiao;
@end
