//
//  MapKitDragAndDropViewController.m
//  MapKitDragAndDrop
//
//  Created by digdog on 11/1/10.
//  Copyright 2010 Ching-Lan 'digdog' HUANG. All rights reserved.
//

#import "MapKitDragAndDropViewController.h"
#import "TDGlobalConfiguration.h"


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
- (IBAction)txtEnderecoReturnKeyPressed:(UITextField *)sender {
    [self btEndereco_click:sender];
}

@synthesize mapView;
@synthesize superController;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Onde?";
    
	CLLocationCoordinate2D theCoordinate;
	theCoordinate.latitude = -30.060351;
    theCoordinate.longitude = -51.171228;
    currLatitude = theCoordinate.latitude;
    currLongitude = theCoordinate.longitude;
    [self drawCircle];
    
    MKCoordinateSpan span = {.latitudeDelta =  0.05, .longitudeDelta =  0.05};
    MKCoordinateRegion region = {theCoordinate, span};
    [self.mapView setRegion:region];
    
	
	DDAnnotation *annotation = [[DDAnnotation alloc] initWithCoordinate:theCoordinate addressDictionary:nil] ;
	annotation.title = @"Drag to Move Pin";
	
	[self.mapView addAnnotation:annotation];
    
    //CLLocation* locationEndereco = [[CLLocation alloc]initWithLatitude:theCoordinate.latitude longitude:theCoordinate.longitude];
    //[self geoCodeUsingCoordinateToTextField:locationEndereco]; //já bota no text field pois foi o jeito encontrado.
    
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
    
    initialY=mapView.bounds.origin.y;
    
    [self.view setBackgroundColor:[TDGlobalConfiguration backgroundColor]];
    
    [self.txtEndereco setFont:[UIFont fontWithName:[TDGlobalConfiguration fontName] size:[TDGlobalConfiguration fontSize]]];
    [self.txtEndereco setTextColor:[TDGlobalConfiguration fontColor]];
    [self.txtEndereco setBackgroundColor:[TDGlobalConfiguration backgroundColor]];
    [self.txtEndereco setPlaceholder:@"Digite um endereço..."];
    
    [self.txtRaio setFont:[UIFont fontWithName:[TDGlobalConfiguration fontName] size:[TDGlobalConfiguration fontSize]]];
    [self.txtRaio setTextColor:[TDGlobalConfiguration fontColor]];
    [self.txtRaio setBackgroundColor:[TDGlobalConfiguration backgroundColor]];

    [self.btnMyLocation setTintColor:[TDGlobalConfiguration buttonColor]];
    [self.btnOk setTintColor:[TDGlobalConfiguration buttonColor]];
    [self.btnSearch setTintColor:[TDGlobalConfiguration buttonColor]];
    [self.lblOptions setFont:[UIFont fontWithName:[TDGlobalConfiguration fontName] size:[TDGlobalConfiguration fontSize]]];
    [self.lblOptions setTextColor:[TDGlobalConfiguration fontColor]];
    [self.lblMap setFont:[UIFont fontWithName:[TDGlobalConfiguration fontName] size:[TDGlobalConfiguration fontSize]]];
    [self.lblMap setTextColor:[TDGlobalConfiguration fontColor]];
    [self.lblRadius setFont:[UIFont fontWithName:[TDGlobalConfiguration fontName] size:[TDGlobalConfiguration fontSize]]];
    [self.lblRadius setTextColor:[TDGlobalConfiguration fontColor]];
    
    [self.sgmMapStyle setTintColor:[TDGlobalConfiguration fontColor]];
    [self.sgmMapStyle setBackgroundColor:[TDGlobalConfiguration backgroundColor]];
    
    //[self.menuView setBackgroundColor:[TDGlobalConfiguration backgroundColor]];
    
}

- (void)viewWillAppear:(BOOL)animated {
	
	[super viewWillAppear:animated];
	
    [self.navigationController setNavigationBarHidden:NO];
	// NOTE: This is optional, DDAnnotationCoordinateDidChangeNotification only fired in iPhone OS 3, not in iOS 4.
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(coordinateChanged_:) name:@"DDAnnotationCoordinateDidChangeNotification" object:nil];
    
    //parte da animação
    UIDynamicAnimator *animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    self.animator = animator;
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

-(void)coordinateChanged_:(NSNotification *)notification{
    
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
- (IBAction)btEndereco_click:(id)sender {
    CLLocationCoordinate2D cl = [self geoCodeUsingAddress:_txtEndereco.text];
    
    currLatitude = cl.latitude;
    currLongitude = cl.longitude;
    
    MKCoordinateSpan span = {.latitudeDelta =  0.05, .longitudeDelta =  0.05};
    MKCoordinateRegion region = {cl, span};
    [self.mapView setRegion:region];
    
    [[self.mapView annotations][0] setCoordinate:cl];
    [self drawCircle];
    [self.txtEndereco resignFirstResponder];
    [self.txtRaio resignFirstResponder];
}

- (IBAction)btOk_Click:(id)sender {
    if(_txtRaio.text != nil){
        [self drawCircle];
    }
    [self.txtRaio resignFirstResponder];
    [self.txtEndereco resignFirstResponder];
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
            [self.superController freshLatitudeLongitude: sl];
            
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


-(IBAction)findMyLocation:(id)sender{
    [mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
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
    
    if(_menuView.frame.origin.y != 0) { //only show the menu if it is not already shown
        [self showMenu];
    } else {
        [self hideMenu];
    }
    
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


- (CLLocationCoordinate2D) geoCodeUsingAddress:(NSString *)address
{
    double latitude = 0, longitude = 0;
    NSString *esc_addr =  [address stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *req = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", esc_addr];
    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
    if (result) {
        NSScanner *scanner = [NSScanner scannerWithString:result];
        if ([scanner scanUpToString:@"\"lat\" :" intoString:nil] && [scanner scanString:@"\"lat\" :" intoString:nil]) {
            [scanner scanDouble:&latitude];
            if ([scanner scanUpToString:@"\"lng\" :" intoString:nil] && [scanner scanString:@"\"lng\" :" intoString:nil]) {
                [scanner scanDouble:&longitude];
            }
        }
    }
    CLLocationCoordinate2D center;
    center.latitude = latitude;
    center.longitude = longitude;
    return center;
}

#pragma mark - animations -
-(void)showMenu{
    //slide the content view to the right to reveal the menu
    //[UIView animateWithDuration:.25
    //                 animations:^{
    //                     //+70 para deixar alinhado por enquanto.
    //                     [_menuView setFrame:CGRectMake(_menuView.frame.origin.x, 0, _menuView.frame.size.width, _menuView.frame.size.height)];
    //                 }
    // ];
    [self.animator removeAllBehaviors];
    
    UIGravityBehavior *gravityBeahvior = [[UIGravityBehavior alloc] initWithItems:@[self.menuView,self.btMenu]];
    [self.animator addBehavior:gravityBeahvior];
    
    UICollisionBehavior *collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[self.menuView]];
    [collisionBehavior setTranslatesReferenceBoundsIntoBoundaryWithInsets:UIEdgeInsetsMake(-400, 0, self.view.bounds.size.height-158, 0)];

    collisionBehavior.collisionDelegate = self;
    [self.animator addBehavior:collisionBehavior];
    
    UICollisionBehavior *collisionBehavior2 = [[UICollisionBehavior alloc] initWithItems:@[self.btMenu]];
    [collisionBehavior2 setTranslatesReferenceBoundsIntoBoundaryWithInsets:UIEdgeInsetsMake(-400, 0, self.view.bounds.size.height-200, 0)];
    
    collisionBehavior2.collisionDelegate = self;
    
    [self.animator addBehavior:collisionBehavior2];
}

-(void)hideMenu{
    [UIView animateWithDuration:.25
                     animations:^{
                         [_menuView setFrame:CGRectMake(0, -158, _menuView.frame.size.width, _menuView.frame.size.height)];
                         [_btMenu setFrame:CGRectMake(_btMenu.frame.origin.x, -5, _btMenu.frame.size.width, _btMenu.frame.size.height)];
    
                     }
     ];
}

#pragma mark - Gesture handlers -
-(void)handleSwipeLeft:(UISwipeGestureRecognizer*)recognizer{
    if(_menuView.frame.origin.y == 0)
        [self hideMenu];
}

-(void)handleSwipeRight:(UISwipeGestureRecognizer*)recognizer{
    if(_menuView.frame.origin.y == -158)
        [self showMenu];
}
@end


