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
#import <AVFoundation/AVFoundation.h>
#import "TD_RegiaoToDo.h"
#import "SL_armazenaDados.h"
#import "SL_Localidades.h"
#import "TDRemindersCell.h"


@interface TDEditToDoViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate, AVAudioRecorderDelegate, AVAudioPlayerDelegate>

@property (strong, nonatomic) TDToDo *toDo;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *location;

@property (weak, nonatomic) IBOutlet UITableView *tabView;
@property (weak, nonatomic) IBOutlet UIButton *recordButton;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;

-(void) freshLatitudeLongitude : (SL_Localidades*)local;
- (void)addDate:(NSDate *)date andTime:(NSDate *)time orWeekDays:(NSMutableArray *)weekDays;
@end
