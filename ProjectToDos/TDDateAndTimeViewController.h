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
@property (weak, nonatomic) IBOutlet UITableViewCell *cllHorario;
@property (strong, nonatomic) IBOutlet UITableView *tblDateTime;

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIDatePicker *hourPicker;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *dateDetails;
@property (weak, nonatomic) IBOutlet UISwitch *switcher;
@property (weak, nonatomic) IBOutlet UILabel *recurrent;
@property (weak, nonatomic) IBOutlet UILabel *hour;
@property (weak, nonatomic) IBOutlet UILabel *hourDetail;
@property (weak, nonatomic) IBOutlet UILabel *occurrence;
@property (weak, nonatomic) IBOutlet UILabel *occurrenceDetails;

@property (strong, nonatomic) TDToDo *todo;
@property (nonatomic, retain) TDEditToDoViewController *superController;

@end
