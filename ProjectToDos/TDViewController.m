//
//  TDViewController.m
//  ProjectToDos
//
//  Created by Stephan Chang on 1/27/14.
//  Copyright (c) 2014 The ToDo Party. All rights reserved.
//

#import "TDViewController.h"
#import "TDEditToDoViewController.h"
#import "TDToDo.h"

@interface TDViewController ()
@property (weak, nonatomic) IBOutlet UITextField *searchAndAddTextField;
@property (weak, nonatomic) IBOutlet UITableView *toDosTableView;
@property (strong, nonatomic) NSMutableArray *toDosDataSource;
@property (strong, nonatomic) NSMutableArray *filteredToDosDataSource;
@property (nonatomic) BOOL isFiltering;

@end

@implementation TDViewController
- (NSMutableArray *)toDosDataSource {
    if (_toDosDataSource == nil)
        _toDosDataSource = [[NSMutableArray alloc] init];
    return _toDosDataSource;
}

- (NSMutableArray *)filteredToDosDataSource {
    if (_filteredToDosDataSource == nil)
        _filteredToDosDataSource = [[NSMutableArray alloc] init];
    return _filteredToDosDataSource;
}

- (IBAction)onTheFlySearch:(UITextField *)sender {
    NSLog(@"Search attempt for string: %@", sender.text);
    self.isFiltering = YES;
    [self.filteredToDosDataSource removeAllObjects];
    [self.toDosTableView reloadData];
    
    for (TDToDo *todo in self.toDosDataSource) {
        if (sender.text.length <= todo.description.length){
            NSString *initials = [todo.description substringToIndex:sender.text.length];
            if ([initials isEqualToString:sender.text])
            {
                [self.filteredToDosDataSource addObject:todo];
                [self.toDosTableView reloadData];
            }
        }
    }
}

- (IBAction)addNewToDo:(UITextField *)sender {
    if ([sender.text isEqualToString:@""])
        return;
    
    int toDoLength = sender.text.length;
    int repeat = 1;
    
    NSString *multiplier = [sender.text substringFromIndex:toDoLength-2];
    
    if ([multiplier characterAtIndex:0] == 'x')
        repeat = [[sender.text substringFromIndex:toDoLength-1] intValue];
    
    self.isFiltering = NO;
    
    [self.toDosTableView reloadData];
    
    for (int k = 0; k < repeat; k++)
    {
        [self.toDosTableView beginUpdates];
        
        NSMutableArray *newList = [[NSMutableArray alloc] init];
        TDToDo *newTodo = [[TDToDo alloc] initWithDescription:sender.text];
        
        [newList addObject:newTodo];
        
        for (TDToDo *todo in self.toDosDataSource) {
            [newList addObject:todo];
        }
        
        self.toDosDataSource = newList;
        
        NSArray *paths = @[[NSIndexPath indexPathForRow:0 inSection:0]];
        [self.toDosTableView insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationFade];
        
        [self.toDosTableView endUpdates];
    }
    NSLog(@"Added New ToDo Entry: %@", [self.toDosDataSource firstObject]);
    [sender setText:@""];
}

#pragma mark - Shake Motion Detection

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [self becomeFirstResponder];
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake)
    {
        // User was shaking the device. Post a notification named "shake."
        NSLog(@"Shake detected. Disposing of completed tasks.");
        NSMutableArray *toDosToBeDeleted = [[NSMutableArray alloc] init];
        NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
        int pos = 0;
        
        for (TDToDo *todo in self.toDosDataSource) {
            if (!todo.active) {
                [toDosToBeDeleted addObject:todo];
                [indexPaths addObject:[NSIndexPath indexPathForRow:pos inSection:0]];
                
            }
            pos++;
        }
        
        [self.toDosDataSource removeObjectsInArray:toDosToBeDeleted];
        //[self.toDosTableView reloadData];
        
        [self.toDosTableView beginUpdates];
        {
        [self.toDosTableView deleteRowsAtIndexPaths:indexPaths
                                       withRowAnimation:UITableViewRowAnimationLeft];
        }
        [self.toDosTableView endUpdates];
    }
}

#pragma mark Table View Delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isFiltering)
    {
        return self.filteredToDosDataSource.count;
    }
    else
    {
        return self.toDosDataSource.count;
    }
}

- (NSAttributedString *)strikeThroughText:(NSString *)text
{
    NSDictionary* attributes = @{
                                 NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle]
                                 };
    
    NSAttributedString* attrText = [[NSAttributedString alloc] initWithString:text attributes:attributes];
    return attrText;
}

- (void)swipeRight:(UISwipeGestureRecognizer *)gesture
{
    NSLog(@"Swiped right");
    CGPoint location = [gesture locationInView:self.toDosTableView];
    NSIndexPath *indexPath = [self.toDosTableView indexPathForRowAtPoint:location];
    UITableViewCell *cell = [self.toDosTableView cellForRowAtIndexPath:indexPath];
    
    cell.textLabel.attributedText = [self strikeThroughText:cell.textLabel.text];
    [[self.toDosDataSource objectAtIndex:indexPath.row] setActive:NO];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    TDToDo *todo;
    
    if (self.isFiltering) {
        todo = [self.filteredToDosDataSource objectAtIndex:indexPath.row];
    }
    else {
        todo = [self.toDosDataSource objectAtIndex:indexPath.row];
    }
    
    if (todo.active) {
        [cell.textLabel setText:todo.description];
    }
    else {
        cell.textLabel.attributedText = [self strikeThroughText:todo.description];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"DetailToDo" sender:tableView];
}

#pragma mark View Delegates

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    UISwipeGestureRecognizer *swipeRec = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)];
    [swipeRec setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.toDosTableView addGestureRecognizer:swipeRec];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [[self navigationController] setNavigationBarHidden:YES];
    [self.toDosTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    TDEditToDoViewController *editView = [segue destinationViewController];
    
    editView.toDo = [self.toDosDataSource objectAtIndex:[sender indexPathForSelectedRow].row];
}

@end
