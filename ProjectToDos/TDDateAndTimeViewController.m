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
    NSMutableArray *weekDays;
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
    
    NSDate *date = [NSDate date];
    self.datePicker.minimumDate = date;
    
    if ([weekDays isEqual:Nil]) {
        [self.diasSemana setText:@"Nenhum"];
    } else if ([weekDays containsObject:@"Domingo"] && [weekDays containsObject:@"Sábado"] && !([weekDays containsObject:@"Segunda"] && [weekDays containsObject:@"Terça"] && [weekDays containsObject:@"Quarta"] && [weekDays containsObject:@"Quinta"] && [weekDays containsObject:@"Sexta"]))
    {
        [self.diasSemana setText:@"Fins de semana"];
    } else if (!([weekDays containsObject:@"Domingo"] && [weekDays containsObject:@"Sábado"]) && [weekDays containsObject:@"Segunda"] && [weekDays containsObject:@"Terça"] && [weekDays containsObject:@"Quarta"] && [weekDays containsObject:@"Quinta"] && [weekDays containsObject:@"Sexta"]) {
        [self.diasSemana setText:@"Dias úteis"];
    } else {
        
    }
    
    // Adding Swip Gesture Recognizers
    UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)];
    [swipeRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:swipeRecognizer];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"AddWeeklyInfo"])
    {
        TDTesteViewController *child = (TDTesteViewController *)segue.destinationViewController;
        [child setSuperController:self];
    }
}

- (void) returnWeekDays:(NSMutableArray *)wd
{
    weekDays = wd;
}

@end
