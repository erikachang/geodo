//
//  TDDateAndTimeViewController.h
//  ProjectToDos
//
//  Created by Eduardo Thiesen on 2/2/14.
//  Copyright (c) 2014 The ToDo Party. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TDDateAndTimeViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *diasSemana;
@property (weak, nonatomic) IBOutlet UISwitch *switcher;
@property (weak, nonatomic) IBOutlet UILabel *label2;

@end
