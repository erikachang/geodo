//
//  TDMapaLocaisViewController.h
//  ProjectToDos
//
//  Created by Matheus Cavalca on 05/02/14.
//  Copyright (c) 2014 The ToDo Party. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "SL_Localidades.h"
#import "DDAnnotation.h"

@interface TDMapaLocaisViewController : UIViewController

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property SL_Localidades* local;

@end
