//
//  TDDateAndTimeViewController.h
//  ProjectToDos
//
//  Created by Eduardo Thiesen on 2/2/14.
//  Copyright (c) 2014 The ToDo Party. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDToDo.h"
#import "TDEditToDoViewController.h"

@interface TDDateAndTimeViewController : UITableViewController
@property (strong, nonatomic) IBOutletCollection(UITableViewCell) NSArray *cells;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *labels;

@property (strong, nonatomic) UIDatePicker *datePicker;
@property (strong, nonatomic) UIDatePicker *hourPicker;
@property (weak, nonatomic) IBOutlet UILabel *dateDetails;
@property (weak, nonatomic) IBOutlet UISwitch *switcher;
@property (weak, nonatomic) IBOutlet UILabel *hourDetail;
@property (weak, nonatomic) IBOutlet UILabel *occurrenceDetails;

@property (strong, nonatomic) TDToDo *todo;
@property (nonatomic, retain) TDEditToDoViewController *superController;

@end
