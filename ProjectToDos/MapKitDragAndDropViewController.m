//
//  MapKitDragAndDropViewController.m
//  MapKitDragAndDrop
//
//  Created by digdog on 11/1/10.
//  Copyright 2010 Ching-Lan 'digdog' HUANG. All rights reserved.
//

#import "MapKitDragAndDropViewController.h"


@interface MapKitDragAndDropViewController ()
- (void)coordinateChanged_:(NSNotification *)notification;

@end

@implementation MapKitDragAndDropViewController{
    float currLatitude;
    float currLongitude;
    id currCircle;
    UITextField *nomeLocal;
    
    int initialY;
}

@synthesize mapView;
@synthesize superController;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	CLLocationCoordinate2D theCoordinate;
	theCoordinate.latitude = 37.810000;
    theCoordinate.longitude = -122.477989;
    currLatitude = theCoordinate.latitude;
    currLongitude = theCoordinate.longitude;
    [self drawCircle];
	
	DDAnnotation *annotation = [[DDAnnotation alloc] initWithCoordinate:theCoordinate addressDictionary:nil] ;
	annotation.title = @"Drag to Move Pin";
	annotation.subtitle = [NSString	stringWithFormat:@"%f %f", annotation.coordinate.latitude, annotation.coordinate.longitude];
	
	[self.mapView addAnnotation:annotation];
    
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    [_locationManager startUpdatingLocation];
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeLeft:)];
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:swipeLeft];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeRight:)];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:swipeRight];
    
    initialY=60;
}

- (void)viewWillAppear:(BOOL)animated {
	
	[super viewWillAppear:animated];
	
	// NOTE: This is optional, DDAnnotationCoordinateDidChangeNotification only fired in iPhone OS 3, not in iOS 4.
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(coordinateChanged_:) name:@"DDAnnotationCoordinateDidChangeNotification" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
	
	[super viewWillDisappear:animated];
	
	// NOTE: This is optional, DDAnnotationCoordinateDidChangeNotification only fired in iPhone OS 3, not in iOS 4.
	[[NSNotificationCenter defaultCenter] removeObserver:self name:@"DDAnnotationCoordinateDidChangeNotification" object:nil];
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	
	self.mapView.delegate = nil;
	self.mapView = nil;
}


#pragma mark -
#pragma mark DDAnnotationCoordinateDidChangeNotification

// NOTE: DDAnnotationCoordinateDidChangeNotification won't fire in iOS 4, use -mapView:annotationView:didChangeDragState:fromOldState: instead.
- (void)coordinateChanged_:(NSNotification *)notification {
	
	DDAnnotation *annotation = notification.object;
	annotation.subtitle = [NSString	stringWithFormat:@"%f %f", annotation.coordinate.latitude, annotation.coordinate.longitude];
}

#pragma mark -
#pragma mark MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)annotationView didChangeDragState:(MKAnnotationViewDragState)newState fromOldState:(MKAnnotationViewDragState)oldState {
    
	if (oldState == MKAnnotationViewDragStateDragging) {
		DDAnnotation *annotation = (DDAnnotation *)annotationView.annotation;
		annotation.subtitle = [NSString	stringWithFormat:@"%f %f", annotation.coordinate.latitude, annotation.coordinate.longitude];
        currLatitude = annotation.coordinate.latitude;
        currLongitude = annotation.coordinate.longitude;
        
        
        [self.txtRaio resignFirstResponder];
        [self drawCircle ];
        
	}
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
	
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
	}
	
	static NSString * const kPinAnnotationIdentifier = @"PinIdentifier";
	MKAnnotationView *draggablePinView = [self.mapView dequeueReusableAnnotationViewWithIdentifier:kPinAnnotationIdentifier];
	
	if (draggablePinView) {
		draggablePinView.annotation = annotation;
	} else {
		// Use class method to create DDAnnotationView (on iOS 3) or built-in draggble MKPinAnnotationView (on iOS 4).
		draggablePinView = [DDAnnotationView annotationViewWithAnnotation:annotation reuseIdentifier:kPinAnnotationIdentifier mapView:self.mapView];
        
		if ([draggablePinView isKindOfClass:[DDAnnotationView class]]) {
			// draggablePinView is DDAnnotationView on iOS 3.
		} else {
			// draggablePinView instance will be built-in draggable MKPinAnnotationView when running on iOS 4.
		}
	}
	
	return draggablePinView;
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay
{
    MKCircleView *circleView = [[MKCircleView alloc] initWithOverlay:overlay];
    [circleView setFillColor:[UIColor brownColor]];
    [circleView setStrokeColor:[UIColor blackColor]];
    [circleView setAlpha:0.5f];
    return circleView;
}

#pragma mark -
#pragma mark actions

- (IBAction)btOk_Click:(id)sender {
    if(_txtRaio.text != nil){
        [self drawCircle];
    }
    [self.txtRaio resignFirstResponder];
}

- (IBAction)btAdicionar_Click:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Adicionar Local"
                                                    message:@"Digite o nome do local: "
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"Adicionar",nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0){
    }else{
        NSString *texto = [alertView textFieldAtIndex:0].text;
        if(![texto isEqualToString:@""]){
            
            //acho que o texto fica melhor com o nome da notificacao para poder ter mais de um por regiao.
            SL_Localidades *sl = [[SL_Localidades alloc]initAll:texto with:currLatitude with:currLongitude with:[_txtRaio.text floatValue]];
            [[[SL_armazenaDados sharedArmazenaDados] listLocalidades] addObject:sl];
            
            CLLocation *centro = [[CLLocation alloc] initWithLatitude:sl.latitude longitude:sl.longitude];

            NSLog(@"%f",[_locationManager.location distanceFromLocation:centro]);
            if([_locationManager.location distanceFromLocation:centro] < [_txtRaio.text floatValue]){
                [self.superController freshLatitudeLongitude: sl with: YES];
            }else{
                [self.superController freshLatitudeLongitude: sl with: NO];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (IBAction)txtRaio_EditingEnd:(id)sender {
    if(_txtRaio.text != nil){
        [self drawCircle];
    }
}

- (IBAction)txtRaio_Touchdown:(id)sender {
    self.txtRaio.keyboardType = UIKeyboardTypeNumberPad;
    [self.txtRaio resignFirstResponder];
}

#pragma mark -
#pragma mark functions

- (void) drawCircle {
    [self.mapView removeOverlay:currCircle];
    CLLocationCoordinate2D center = {currLatitude, currLongitude};
    MKCircle *circle = [MKCircle circleWithCenterCoordinate:center radius:[_txtRaio.text intValue]];
    [self.mapView addOverlay:circle];
    currCircle = circle;
}


#pragma mark -
#pragma mark actions
-(IBAction)findMyLocation:(id)sender{
    [mapView setDelegate:self];
    [mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    
	CLLocationCoordinate2D actual;
	actual.latitude = _locationManager.location.coordinate.latitude;
    actual.longitude = _locationManager.location.coordinate.longitude;
    
    [[self.mapView annotations][0] setCoordinate:actual];
}


-(IBAction)setMapType:(id)sender{
    switch (((UISegmentedControl *)sender).selectedSegmentIndex) {
        case 0:
            mapView.mapType = MKMapTypeStandard;
            break;
        case 1:
            mapView.mapType = MKMapTypeSatellite;
            break;
        case 2:
            mapView.mapType = MKMapTypeHybrid;
            break;

        default:
            break;
    }
}

- (IBAction)showMenuDown:(id)sender {
    
    if(_content.frame.origin.y == initialY) //only show the menu if it is not already shown
        [self showMenu];
    else
        [self hideMenu];
    
}


#pragma mark - animations -
-(void)showMenu{
    
    //slide the content view to the right to reveal the menu
    [UIView animateWithDuration:.25
                     animations:^{
                         [_content setFrame:CGRectMake(_content.frame.origin.x, _menuView.frame.size.height, _content.frame.size.width, _content.frame.size.height)];
                     }
     ];
    
}
-(void)hideMenu{
    //slide the content view to the left to hide the menu
    [UIView animateWithDuration:.25
                     animations:^{
                         [_content setFrame:CGRectMake(0, initialY, _content.frame.size.width, _content.frame.size.height)];
                         
                     }
     ];
}

#pragma mark - Gesture handlers -
-(void)handleSwipeLeft:(UISwipeGestureRecognizer*)recognizer{
    
    if(_content.frame.origin.x != 0)
        [self hideMenu];
}
-(void)handleSwipeRight:(UISwipeGestureRecognizer*)recognizer{
    if(_content.frame.origin.x == 0)
        [self showMenu];
}
@end
