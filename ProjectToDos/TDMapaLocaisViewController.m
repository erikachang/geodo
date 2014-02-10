//
//  TDMapaLocaisViewController.m
//  ProjectToDos
//
//  Created by Matheus Cavalca on 05/02/14.
//  Copyright (c) 2014 The ToDo Party. All rights reserved.
//

#import "TDMapaLocaisViewController.h"

@interface TDMapaLocaisViewController ()

@end

@implementation TDMapaLocaisViewController

@synthesize local;

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = local.identificador;
    
    CLLocationCoordinate2D theCoordinate;
	theCoordinate.latitude = local.latitude;
    theCoordinate.longitude = local.longitude;
    
    CLLocationCoordinate2D center = {local.latitude, local.longitude};
    MKCircle *circle = [MKCircle circleWithCenterCoordinate:center radius:local.raio];
    [self.mapView addOverlay:circle];
    
    MKCoordinateSpan span = {.latitudeDelta =  0.05, .longitudeDelta =  0.05};
    MKCoordinateRegion region = {theCoordinate, span};
    [self.mapView setRegion:region];
    
	
	DDAnnotation *annotation = [[DDAnnotation alloc] initWithCoordinate:theCoordinate addressDictionary:nil] ;
	annotation.title = local.identificador;
    
	[self.mapView addAnnotation:annotation];
}


- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay
{
    MKCircleView *circleView = [[MKCircleView alloc] initWithOverlay:overlay];
    [circleView setFillColor:[UIColor brownColor]];
    [circleView setStrokeColor:[UIColor blackColor]];
    [circleView setAlpha:0.5f];
    return circleView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
