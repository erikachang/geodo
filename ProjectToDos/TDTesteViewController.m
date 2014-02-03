//
//  TDTesteViewController.m
//  ProjectToDos
//
//  Created by Eduardo Thiesen on 2/2/14.
//  Copyright (c) 2014 The ToDo Party. All rights reserved.
//

#import "TDTesteViewController.h"

@interface TDTesteViewController ()

@end

@implementation TDTesteViewController {
    NSMutableArray *wd;
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
    [self.superController returnWeekDays:wd];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    wd = [[NSMutableArray alloc] init];
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"%@", cell.textLabel.text);
    
    if (cell.accessoryType == UITableViewCellAccessoryNone)
    {
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [wd addObject:cell.textLabel.text];
    }
	else
    {
		cell.accessoryType = UITableViewCellAccessoryNone;
        [wd removeObject:cell];
    }
    cell.selected = NO;
}

@end
