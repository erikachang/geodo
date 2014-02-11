//
//  MapKitDragAndDropViewController.h
//  TesteSilencioso
//
//  Created by Matheus Cavalca on 27/01/14.
//  Copyright (c) 2014 Matheus Cavalca. All rights reserved.
//

#import "TDEditToDoViewController.h"
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

#import "MapKitDragAndDropViewController.h"
#import "DDAnnotation.h"
#import "DDAnnotationView.h"
#import "SL_Localidades.h"
#import "SL_armazenaDados.h"

@interface MapKitDragAndDropViewController : UIViewController{
	MKMapView *mapView;
}
@property (weak, nonatomic) IBOutlet UILabel *lblRadius;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sgmMapStyle;
@property (weak, nonatomic) IBOutlet UILabel *lblMap;
@property (weak, nonatomic) IBOutlet UIButton *btnMyLocation;
@property (weak, nonatomic) IBOutlet UIButton *btnSearch;
@property (weak, nonatomic) IBOutlet UIButton *btnOk;

@property (strong, nonatomic) IBOutlet UIButton *btMenu;

@property (weak, nonatomic) IBOutlet UITextField *txtEndereco;
@property (retain, nonatomic) IBOutlet UITextField *txtRaio;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@property (nonatomic , strong) CLLocationManager* locationManager;

@property(nonatomic, retain)TDEditToDoViewController *superController;

-(IBAction)findMyLocation:(id)sender;
-(IBAction)setMapType:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *menuView;
@property (strong, nonatomic) IBOutlet UIView *content;

@end
