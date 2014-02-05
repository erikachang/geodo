//
//  TDDateAndTimeViewController.m
//  ProjectToDos
//
//  Created by Eduardo Thiesen on 2/2/14.
//  Copyright (c) 2014 The ToDo Party. All rights reserved.
//

#import "TDDateAndTimeViewController.h"
#import "TDTesteViewController.h"

@interface TDDateAndTimeViewController ()

@end

@implementation TDDateAndTimeViewController
{
    NSMutableArray *days;
    BOOL data;
    BOOL hours;
    BOOL weekDays;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)swipeRight:(UISwipeGestureRecognizer *)gesture
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[self navigationController] setNavigationBarHidden:NO];
    
    NSDate *date = [NSDate date];
    self.datePicker.minimumDate = date;
    self.hourPicker.minimumDate = date;
    
    // Adding Swip Gesture Recognizers
    UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)];
    [swipeRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:swipeRecognizer];
    
    
    data = YES;
    hours = NO;
    weekDays = YES;
    
    self.tableView.alwaysBounceVertical = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if (self.switcher.on == YES) {
        if([[segue identifier] isEqualToString:@"selectWeekDays"])
        {

        }
    }
}

//- (void) returnWeekDays:(NSMutableArray *)weekDays
//{
//    days = weekDays;
//
//    if ([weekDays isEqual:Nil]) {
//        [self.diasSemana setText:@"Nenhum"];
//    } else if ([weekDays containsObject:[NSNumber numberWithInt:0]] && [weekDays containsObject:[NSNumber numberWithInt:6]] && !([weekDays containsObject:[NSNumber numberWithInt:1]] || [weekDays containsObject:[NSNumber numberWithInt:2]] || [weekDays containsObject:[NSNumber numberWithInt:3]] || [weekDays containsObject:[NSNumber numberWithInt:4]] || [weekDays containsObject:[NSNumber numberWithInt:5]]))
//    {
//        [self.diasSemana setText:@"Fins de semana"];
//    } else if (!([weekDays containsObject:[NSNumber numberWithInt:0]] || [weekDays containsObject:[NSNumber numberWithInt:6]]) && [weekDays containsObject:[NSNumber numberWithInt:1]] && [weekDays containsObject:[NSNumber numberWithInt:2]] && [weekDays containsObject:[NSNumber numberWithInt:3]] && [weekDays containsObject:[NSNumber numberWithInt:4]] && [weekDays containsObject:[NSNumber numberWithInt:5]])
//    {
//        [self.diasSemana setText:@"Dias úteis"];
//    } else if ([weekDays containsObject:[NSNumber numberWithInt:0]] && [weekDays containsObject:[NSNumber numberWithInt:6]] && [weekDays containsObject:[NSNumber numberWithInt:1]] && [weekDays containsObject:[NSNumber numberWithInt:2]] && [weekDays containsObject:[NSNumber numberWithInt:3]] && [weekDays containsObject:[NSNumber numberWithInt:4]] && [weekDays containsObject:[NSNumber numberWithInt:5]])
//    {
//        [self.diasSemana setText:@"Todos os dias"];
//    } else {
//        NSMutableString *temp = [[NSMutableString alloc] init];
//        if ([weekDays containsObject:[NSNumber numberWithInt:0]]) {
//            [temp appendString:@"Dom "];
//        }
//        if ([weekDays containsObject:[NSNumber numberWithInt:1]]) {
//            [temp appendString:@"Seg "];
//        }
//        if ([weekDays containsObject:[NSNumber numberWithInt:2]]) {
//            [temp appendString:@"Ter "];
//        }
//        if ([weekDays containsObject:[NSNumber numberWithInt:3]]) {
//            [temp appendString:@"Qua "];
//        }
//        if ([weekDays containsObject:[NSNumber numberWithInt:4]]) {
//            [temp appendString:@"Qui "];
//        }
//        if ([weekDays containsObject:[NSNumber numberWithInt:5]]) {
//            [temp appendString:@"Sex"];
//        }
//        if ([weekDays containsObject:[NSNumber numberWithInt:6]]) {
//            [temp appendString:@"Sab "];
//        }
//
//        [self.diasSemana setText:temp];
//    }
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.row == 0 && hours == NO) {
        hours = YES;
    } else if (indexPath.row == 0 && hours == YES) {
        hours = NO;
    }
    if (indexPath.row == 3 && data == NO) {
        data = YES;
    } else if (indexPath.row == 3 && data == YES) {
        data = NO;
    }
    if (indexPath.row == 5 && weekDays == NO) {
        weekDays = YES;
    } else if (indexPath.row == 5 && data == YES) {
        weekDays = NO;
    }
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    
    cell.selected = NO;
}


- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 44;
    } else if (indexPath.section == 0 && indexPath.row == 1) {
        if (hours == YES) {
            return 0;
        } else {
            return 180;
        }
    } else if (indexPath.section == 0 && indexPath.row == 2) {
        return 44;
    }
    
    if (self.switcher.on == NO) {
        if (indexPath.section == 0 && indexPath.row == 3) {
            return 44;
        } else if (indexPath.section == 0 && indexPath.row == 4) {
            if (data == YES) {
                return 0;
            } else {
                return 180;
            }
        } if (indexPath.section == 0 && indexPath.row == 5) {
            return 0;
        } else if (indexPath.section == 0 && indexPath.row == 6) {
            return 0;
        }
    } else {
        if (indexPath.section == 0 && indexPath.row == 5) {
            return 44;
        } else if (indexPath.section == 0 && indexPath.row == 6) {
            if (weekDays == YES) {
                return 0;
            } else {
                return 180;
            }
        }
        if (indexPath.section == 0 && indexPath.row == 3) {
            return 0;
        } else if (indexPath.section == 0 && indexPath.row == 4) {
            return 0;
        }
    }
    
    return 44;
}

- (IBAction)switched:(UISwitch *)sender {
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

@end
