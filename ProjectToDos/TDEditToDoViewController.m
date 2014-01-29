//
//  TDEditToDoViewController.m
//  ProjectToDos
//
//  Created by Stephan Chang on 1/28/14.
//  Copyright (c) 2014 The ToDo Party. All rights reserved.
//

#import "TDEditToDoViewController.h"

@interface TDEditToDoViewController ()
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITableView *remindersTableView;
@property (weak, nonatomic) IBOutlet UIButton *applyButton;

@property (strong, nonatomic) NSMutableDictionary *sectionsDic;

@end

@implementation TDEditToDoViewController

- (NSMutableDictionary *)sectionsDic
{
    if (_sectionsDic == nil)
        _sectionsDic = [[NSMutableDictionary alloc] init];
    return _sectionsDic;
}

- (IBAction)editingFinished:(UITextField *)sender {
    [self resignFirstResponder];
}

- (IBAction)applyChanges:(UIButton *)sender {
    self.toDo.description = self.titleTextField.text;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    return cell;
}

@end
