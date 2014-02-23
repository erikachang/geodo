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

- (IBAction)dateChanged:(UIDatePicker *)sender {
    [self.hourPicker setDate:[self.datePicker date]];
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

- (void)viewDidAppear:(BOOL)animated
{
    self.datePicker = [[UIDatePicker alloc] init];
    [self.datePicker setDatePickerMode:UIDatePickerModeDate];
    [self.datePicker addTarget:self  action:@selector(dateChanged:)
         forControlEvents:UIControlEventValueChanged];
    
    self.hourPicker = [[UIDatePicker alloc] init];
    [self.hourPicker setDatePickerMode:UIDatePickerModeTime];
    
    NSDate *date = [NSDate date];
    self.datePicker.minimumDate = date;
    self.hourPicker.minimumDate = date;
    
    [((UITableViewCell *)self.cells[1]).contentView addSubview:self.hourPicker];
    [((UITableViewCell *)self.cells[4]).contentView addSubview:self.datePicker];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 13;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 25)];
    [view setBackgroundColor:[TDGlobalConfiguration fontColor]];
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, self.tableView.frame.size.width, view.frame.size.height)];
    
    [textField setFont:[UIFont fontWithName:[TDGlobalConfiguration fontName] size:[TDGlobalConfiguration fontSizeSmall]]];
    //    [textField setBackgroundColor:[TDGlobalConfiguration fontColor]];
    [textField setText:@"Selecione uma ocasião:"];
    
    [view addSubview:textField];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 25)];
    [view setBackgroundColor:[TDGlobalConfiguration fontColor]];
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, view.frame.size.height)];
    
    [textField setFont:[UIFont fontWithName:[TDGlobalConfiguration fontName] size:[TDGlobalConfiguration fontSizeSmall]]];
    //    [textField setBackgroundColor:[TDGlobalConfiguration fontColor]];
    [textField setTextAlignment:NSTextAlignmentCenter];
    [textField setText:@"Configure sua notificação"];
    
    [view addSubview:textField];
    return view;
}

CAGradientLayer *grad;
- (void)viewDidLoad
{
    [super viewDidLoad];

    [[self navigationController] setNavigationBarHidden:NO];
    grad = [TDGlobalConfiguration gradientLayer];
    grad.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    [self.view.layer insertSublayer:grad atIndex:0];
    
    [self.switcher setOnTintColor:[TDGlobalConfiguration fontColor]];
    [self.tableView setBackgroundColor:[TDGlobalConfiguration backgroundColor]];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    for (UILabel *label in self.labels) {
        [label setTextColor:[TDGlobalConfiguration fontColor]];
        [label setFont:[UIFont fontWithName:[TDGlobalConfiguration fontName] size:[TDGlobalConfiguration fontSize]]];
    }
    
    for (UITableViewCell *cell in self.cells) {
        [cell setBackgroundColor:[TDGlobalConfiguration backgroundColor]];
        [cell setTintColor:[TDGlobalConfiguration fontColor]];
        [[cell textLabel] setTextColor:[TDGlobalConfiguration fontColor]];
        [[cell textLabel] setFont:[UIFont fontWithName:[TDGlobalConfiguration fontName] size:[TDGlobalConfiguration fontSize]]];
    }

    days = [[NSMutableArray alloc] init];
    
    data = YES;
    hours = YES;
    weekDays = YES;
    
    self.hourDetail.alpha = 0;
    self.dateDetails.alpha = 0;
    self.occurrenceDetails.alpha = 0;
    self.tableView.alwaysBounceVertical = NO;
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
        
    } else if ([days containsObject:[NSNumber numberWithInt:0]] && [days containsObject:[NSNumber numberWithInt:6]] && [days count] == 2)
    {
        self.occurrenceDetails.alpha = 0;
        [self fadeOut:self.dateDetails withDuration:.5 andWait:.1];
        [self fadeIn:self.occurrenceDetails withDuration:0.5 andWait:0.2];
        [self.occurrenceDetails setText:@"Fins de semana"];
        
    } else if ([days count] == 5 && [days containsObject:[NSNumber numberWithInt:1]] && [days containsObject:[NSNumber numberWithInt:2]] && [days containsObject:[NSNumber numberWithInt:3]] && [days containsObject:[NSNumber numberWithInt:4]] && [days containsObject:[NSNumber numberWithInt:5]])
    {
        self.occurrenceDetails.alpha = 0;
        [self fadeOut:self.dateDetails withDuration:.5 andWait:.1];
        [self fadeIn:self.occurrenceDetails withDuration:0.5 andWait:0.2];
        [self.occurrenceDetails setText:@"Dias úteis"];
        
    } else if ([days count] == 7)
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
    short dayOfWeek;
    switch (indexPath.row) {
        case 0:
            hours = !hours;
            if (!hours) {
                [self fadeOut:self.hourDetail withDuration:.5 andWait:.1];
            } else {
                NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
                [outputFormatter setDateFormat:@"HH:mm"]; //24hr time format
                NSString *dateString = [outputFormatter stringFromDate:self.hourPicker.date];
                
                [self fadeOut:self.hourDetail withDuration:.5 andWait:.1];
                [self fadeIn:self.hourDetail withDuration:.5 andWait:.1];
                [self.hourDetail setText:dateString];
            }
            break;
        case 3:
            data = !data;
            if (!data) {
                [self fadeOut:self.dateDetails withDuration:.5 andWait:.1];
            } else {
                NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
                [outputFormatter setDateFormat:@"dd/MM/yyyy"];
                NSString *dateString = [outputFormatter stringFromDate:self.hourPicker.date];
                
                [self fadeOut:self.dateDetails withDuration:.5 andWait:.1];
                [self fadeIn:self.dateDetails withDuration:.5 andWait:.1];
                [self.dateDetails setText:dateString];

            }
            break;
        case 5:
            weekDays = !weekDays;
            break;
        case 6:
        case 7:
        case 8:
        case 9:
        case 10:
        case 11:
        case 12:
            dayOfWeek = indexPath.row - 6;
            if (!([days containsObject:[NSNumber numberWithInt:dayOfWeek]])) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                [days addObject:[NSNumber numberWithInt:dayOfWeek]];
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
                [days removeObject:[NSNumber numberWithInt:dayOfWeek]];
            }
            [self returnWeekDays];
        default:
            break;
    }
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    
    cell.selected = NO;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 1:
            return hours ? 0 : 180;
            break;
        case 3:
            return self.switcher.on ? 0 : 44;
            break;
        case 4:
            return (!self.switcher.on && !data) ? 180 : 0;
            break;
        case 5:
            return self.switcher.on ? 44 : 0;
        case 6:
        case 7:
        case 8:
        case 9:
        case 10:
        case 11:
        case 12:
            return (!self.switcher.on || weekDays) ? 0 : 44;
            break;
        default:
            return 44;
            break;
    }
}

- (IBAction)switched:(UISwitch *)sender {
    data = YES;
    weekDays = YES;
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    
    if (self.switcher.on) {
        NSDate *date = [NSDate distantPast];
        [self.hourPicker setMinimumDate:date];
    }
}

-(void)fadeOut:(UIView*)viewToDissolve withDuration:(NSTimeInterval)duration
       andWait:(NSTimeInterval)wait
{
    [UIView beginAnimations: @"Fade Out" context:nil];
    // wait for time before begin
    [UIView setAnimationDelay:wait];
    // druation of animation
    [UIView setAnimationDuration:duration];
    viewToDissolve.alpha = 0.0;
    [UIView commitAnimations];
}
-(void)fadeIn:(UIView*)viewToFadeIn withDuration:(NSTimeInterval)duration
      andWait:(NSTimeInterval)wait
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
