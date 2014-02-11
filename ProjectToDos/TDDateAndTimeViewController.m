//
//  TDDateAndTimeViewController.m
//  ProjectToDos
//
//  Created by Eduardo Thiesen on 2/2/14.
//  Copyright (c) 2014 The ToDo Party. All rights reserved.
//

#import "TDDateAndTimeViewController.h"
#import "TDGlobalConfiguration.h"

@interface TDDateAndTimeViewController ()

@end


@implementation TDDateAndTimeViewController
{
    NSMutableArray *days;
    BOOL data;
    BOOL hours;
    BOOL weekDays;
}

@synthesize superController;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)apply:(UIBarButtonItem *)sender {
    if (self.switcher.on == NO) {
        [self.superController addDate:self.datePicker.date andTime:self.hourPicker.date orWeekDays:Nil];
    } else {
        [self.superController addDate:Nil andTime:self.hourPicker.date orWeekDays:days];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[self navigationController] setNavigationBarHidden:NO];
    
    [self.view setBackgroundColor:[TDGlobalConfiguration backgroundColor]];
    [self.switcher setOnTintColor:[TDGlobalConfiguration controlBackgroundColor]];
    
    NSDate *date = [NSDate date];
    self.datePicker.minimumDate = date;
    self.hourPicker.minimumDate = date;

    days = [[NSMutableArray alloc] init];
    
    data = YES;
    hours = NO;
    weekDays = YES;
    
    self.hourDetail.alpha = 0;
    self.dateDetails.alpha = 0;
    self.occurrenceDetails.alpha = 0;
    self.tableView.alwaysBounceVertical = NO;
    
    self.todo = self.superController.toDo;
    
    NSLog(@"%@", self.todo.reminders.lastObject);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void) returnWeekDays
{
    if ([days count] == 0) {
        self.occurrenceDetails.alpha = 0;
        [self fadeOut:self.dateDetails withDuration:.5 andWait:.1];
        [self fadeIn:self.occurrenceDetails withDuration:0.5 andWait:0.2];
        [self.occurrenceDetails setText:@"Nenhuma"];
    } else if ([days containsObject:[NSNumber numberWithInt:0]] && [days containsObject:[NSNumber numberWithInt:6]] && !([days containsObject:[NSNumber numberWithInt:1]] || [days containsObject:[NSNumber numberWithInt:2]] || [days containsObject:[NSNumber numberWithInt:3]] || [days containsObject:[NSNumber numberWithInt:4]] || [days containsObject:[NSNumber numberWithInt:5]]))
    {
        self.occurrenceDetails.alpha = 0;
        [self fadeOut:self.dateDetails withDuration:.5 andWait:.1];
        [self fadeIn:self.occurrenceDetails withDuration:0.5 andWait:0.2];
        [self.occurrenceDetails setText:@"Fins de semana"];
    } else if (!([days containsObject:[NSNumber numberWithInt:0]] || [days containsObject:[NSNumber numberWithInt:6]]) && [days containsObject:[NSNumber numberWithInt:1]] && [days containsObject:[NSNumber numberWithInt:2]] && [days containsObject:[NSNumber numberWithInt:3]] && [days containsObject:[NSNumber numberWithInt:4]] && [days containsObject:[NSNumber numberWithInt:5]])
    {
        self.occurrenceDetails.alpha = 0;
        [self fadeOut:self.dateDetails withDuration:.5 andWait:.1];
        [self fadeIn:self.occurrenceDetails withDuration:0.5 andWait:0.2];
        [self.occurrenceDetails setText:@"Dias úteis"];
    } else if ([days containsObject:[NSNumber numberWithInt:0]] && [days containsObject:[NSNumber numberWithInt:6]] && [days containsObject:[NSNumber numberWithInt:1]] && [days containsObject:[NSNumber numberWithInt:2]] && [days containsObject:[NSNumber numberWithInt:3]] && [days containsObject:[NSNumber numberWithInt:4]] && [days containsObject:[NSNumber numberWithInt:5]])
    {
        self.occurrenceDetails.alpha = 0;
        [self fadeOut:self.dateDetails withDuration:.5 andWait:.1];
        [self fadeIn:self.occurrenceDetails withDuration:0.5 andWait:0.2];
        [self.occurrenceDetails setText:@"Todos os dias"];
    } else {
        NSMutableString *temp = [[NSMutableString alloc] init];
        if ([days containsObject:[NSNumber numberWithInt:0]]) {
            [temp appendString:@"Dom "];
        }
        if ([days containsObject:[NSNumber numberWithInt:1]]) {
            [temp appendString:@"Seg "];
        }
        if ([days containsObject:[NSNumber numberWithInt:2]]) {
            [temp appendString:@"Ter "];
        }
        if ([days containsObject:[NSNumber numberWithInt:3]]) {
            [temp appendString:@"Qua "];
        }
        if ([days containsObject:[NSNumber numberWithInt:4]]) {
            [temp appendString:@"Qui "];
        }
        if ([days containsObject:[NSNumber numberWithInt:5]]) {
            [temp appendString:@"Sex"];
        }
        if ([days containsObject:[NSNumber numberWithInt:6]]) {
            [temp appendString:@"Sab "];
        }
        
        self.occurrenceDetails.alpha = 0;
        [self fadeOut:self.dateDetails withDuration:.5 andWait:.1];
        [self fadeIn:self.occurrenceDetails withDuration:0.5 andWait:0.2];
        [self.occurrenceDetails setText:temp];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.row == 0 && hours == NO) {
        hours = YES;
    } else if (indexPath.row == 0 && hours == YES) {
        [self fadeOut:self.hourDetail withDuration:.5 andWait:.1];
        hours = NO;
    } else if (indexPath.row == 3 && data == NO) {
        data = YES;
    } else if (indexPath.row == 3 && data == YES) {
        [self fadeOut:self.dateDetails withDuration:.5 andWait:.1];
        data = NO;
    } else if (indexPath.row == 5 && weekDays == NO) {
        weekDays = YES;
    } else if (indexPath.row == 5 && data == YES) {
        weekDays = NO;
    } else if (indexPath.row == 6) {
        if (!([days containsObject:[NSNumber numberWithInt:0]])) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            [days addObject:[NSNumber numberWithInt:0]];
            [self returnWeekDays];
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryNone;
            [days removeObject:[NSNumber numberWithInt:0]];
            [self returnWeekDays];
        }
    } else if (indexPath.row == 7) {
        if (!([days containsObject:[NSNumber numberWithInt:1]])) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            [days addObject:[NSNumber numberWithInt:1]];
            [self returnWeekDays];
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryNone;
            [days removeObject:[NSNumber numberWithInt:1]];
            [self returnWeekDays];
        }
    } else if (indexPath.row == 8) {
        if (!([days containsObject:[NSNumber numberWithInt:2]])) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            [days addObject:[NSNumber numberWithInt:2]];
            [self returnWeekDays];
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryNone;
            [days removeObject:[NSNumber numberWithInt:2]];
            [self returnWeekDays];
        }
    } else if (indexPath.row == 9) {
        if (!([days containsObject:[NSNumber numberWithInt:3]])) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            [days addObject:[NSNumber numberWithInt:3]];
            [self returnWeekDays];
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryNone;
            [days removeObject:[NSNumber numberWithInt:3]];
            [self returnWeekDays];
        }
    } else if (indexPath.row == 10) {
        if (!([days containsObject:[NSNumber numberWithInt:4]])) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            [days addObject:[NSNumber numberWithInt:4]];
            [self returnWeekDays];
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryNone;
            [days removeObject:[NSNumber numberWithInt:4]];
            [self returnWeekDays];
        }
    } else if (indexPath.row == 11) {
        if (!([days containsObject:[NSNumber numberWithInt:5]])) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            [days addObject:[NSNumber numberWithInt:5]];
            [self returnWeekDays];
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryNone;
            [days removeObject:[NSNumber numberWithInt:5]];
            [self returnWeekDays];
        }
    } else if (indexPath.row == 12) {
        if (!([days containsObject:[NSNumber numberWithInt:6]])) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            [days addObject:[NSNumber numberWithInt:6]];
            [self returnWeekDays];
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryNone;
            [days removeObject:[NSNumber numberWithInt:6]];
            [self returnWeekDays];
        }
    }
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    
    if (hours == YES && indexPath.row == 0) {
        NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
        [outputFormatter setDateFormat:@"HH:mm"]; //24hr time format
        NSString *dateString = [outputFormatter stringFromDate:self.hourPicker.date];
        
        [self fadeOut:self.hourDetail withDuration:.5 andWait:.1];
        [self fadeIn:self.hourDetail withDuration:.5 andWait:.1];
        [self.hourDetail setText:dateString];
    } else if (data == YES && indexPath.row == 3) {
        NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
        [outputFormatter setDateFormat:@"dd/MM/yyyy"];
        NSString *dateString = [outputFormatter stringFromDate:self.hourPicker.date];
        
        [self fadeOut:self.dateDetails withDuration:.5 andWait:.1];
        [self fadeIn:self.dateDetails withDuration:.5 andWait:.1];
        [self.dateDetails setText:dateString];
    }
    
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
        } else if (indexPath.section == 0 && indexPath.row == 7) {
            return 0;
        } else if (indexPath.section == 0 && indexPath.row == 8) {
            return 0;
        } else if (indexPath.section == 0 && indexPath.row == 9) {
            return 0;
        } else if (indexPath.section == 0 && indexPath.row == 10) {
            return 0;
        } else if (indexPath.section == 0 && indexPath.row == 11) {
            return 0;
        } else if (indexPath.section == 0 && indexPath.row == 12) {
            return 0;
        }
    } else {
        if (indexPath.section == 0 && indexPath.row == 5) {
            return 44;
        } else if (indexPath.section == 0 && indexPath.row == 6) {
            if (weekDays == YES) {
                return 0;
            } else {
                return 44;
            }
        } else if (indexPath.section == 0 && indexPath.row == 7) {
            if (weekDays == YES) {
                return 0;
            } else {
                return 44;
            }
        } else if (indexPath.section == 0 && indexPath.row == 8) {
            if (weekDays == YES) {
                return 0;
            } else {
                return 44;
            }
        } else if (indexPath.section == 0 && indexPath.row == 9) {
            if (weekDays == YES) {
                return 0;
            } else {
                return 44;
            }
        } else if (indexPath.section == 0 && indexPath.row == 10) {
            if (weekDays == YES) {
                return 0;
            } else {
                return 44;
            }
        } else if (indexPath.section == 0 && indexPath.row == 11) {
            if (weekDays == YES) {
                return 0;
            } else {
                return 44;
            }
        } else if (indexPath.section == 0 && indexPath.row == 12) {
            if (weekDays == YES) {
                return 0;
            } else {
                return 44;
            }
        } else if (indexPath.section == 0 && indexPath.row == 3) {
            return 0;
        } else if (indexPath.section == 0 && indexPath.row == 4) {
            return 0;
        }
    }
    
    return 44;
}

- (IBAction)switched:(UISwitch *)sender {
    data = YES;
    weekDays = YES;
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

-(void)fadeOut:(UIView*)viewToDissolve withDuration:(NSTimeInterval)duration   andWait:(NSTimeInterval)wait
{
    [UIView beginAnimations: @"Fade Out" context:nil];
    // wait for time before begin
    [UIView setAnimationDelay:wait];
    // druation of animation
    [UIView setAnimationDuration:duration];
    viewToDissolve.alpha = 0.0;
    [UIView commitAnimations];
}
-(void)fadeIn:(UIView*)viewToFadeIn withDuration:(NSTimeInterval)duration         andWait:(NSTimeInterval)wait
{
    [UIView beginAnimations: @"Fade In" context:nil];
    // wait for time before begin
    [UIView setAnimationDelay:wait];
    // druation of animation
    [UIView setAnimationDuration:duration];
    viewToFadeIn.alpha = 1;
    [UIView commitAnimations];
}

@end
