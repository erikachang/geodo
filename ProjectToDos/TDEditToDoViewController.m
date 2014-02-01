//
//  TDEditToDoViewController.m
//  ProjectToDos
//
//  Created by Stephan Chang on 1/28/14.
//  Copyright (c) 2014 The ToDo Party. All rights reserved.
//

#import "TDEditToDoViewController.h"

@interface TDEditToDoViewController ()
@property (weak, nonatomic) IBOutlet UIButton *addDateTimeNotificationButton;
@property (weak, nonatomic) IBOutlet UIButton *addLocationNotificationButton;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITableView *remindersTableView;

@property (strong, nonatomic) NSMutableDictionary *sectionsDic;

@end

@implementation TDEditToDoViewController

- (IBAction)changeToDoNameAndViewTitle:(UITextField *)sender {
    [self resignFirstResponder];
    
    if ([self.titleTextField.text isEqualToString:@""]) {
        self.titleTextField.text = self.toDo.description;
    }
    else {
        self.toDo.description = self.titleTextField.text;
        self.title = self.titleTextField.text;
    }
}

- (NSMutableDictionary *)sectionsDic
{
    if (_sectionsDic == nil)
        _sectionsDic = [[NSMutableDictionary alloc] init];
    return _sectionsDic;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)gotoDateAndTime
{
    [self performSegueWithIdentifier:@"AddDateTimeNotification" sender:Nil];
}

- (void)gotoLocation
{
    [self performSegueWithIdentifier:@"AddLocationNotification" sender:Nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [[self navigationController] setNavigationBarHidden:NO];
    [self.titleTextField setBorderStyle:UITextBorderStyleNone];
    [self.titleTextField setText:self.toDo.description];
    NSDictionary *sections = @{@"Lembre-me:":@"Lembre-me:"};
    [self.sectionsDic addEntriesFromDictionary:sections];
    
    // Date and Time Notification button customization
    {
        [self.addDateTimeNotificationButton setTitle:@"+ Data/Hora" forState:UIControlStateNormal];
        [self.addDateTimeNotificationButton addTarget:self action:@selector(gotoDateAndTime) forControlEvents:UIControlEventTouchDown];
    }
    
    // Location Notification button customization
    {
        [self.addLocationNotificationButton setTitle:@"+ Local" forState:UIControlStateNormal];
        [self.addLocationNotificationButton addTarget:self action:@selector(gotoLocation) forControlEvents:UIControlEventTouchDown];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return self.sectionsDic.allKeys.count;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{

    return [self.sectionsDic.allKeys objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.toDo.reminders.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSArray *reminders = self.toDo.reminders;
    
    cell.textLabel.text = [[reminders objectAtIndex:indexPath.row] notificationDescription];
    
    return cell;
}

@end
