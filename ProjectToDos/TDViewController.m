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
#import "TDToDosCell.h"

@interface TDViewController ()
@property (weak, nonatomic) IBOutlet UITextField *searchAndAddTextField;
@property (weak, nonatomic) IBOutlet UITableView *toDosTableView;
@property (strong, nonatomic) NSMutableArray *toDosDataSource;
@property (strong, nonatomic) NSMutableArray *filteredToDosDataSource;
@property (nonatomic) BOOL isFiltering;

@end

@implementation TDViewController
- (IBAction)editToDoDescription:(UITextField *)sender {
    [self resignFirstResponder];
    
    if (![sender.text isEqualToString:@""]) {
        TDToDo *toDo = [self.toDosDataSource objectAtIndex:sender.tag];
        
        toDo.description = sender.text;
    }
}
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
    
    self.isFiltering = NO;
    
    [self.toDosTableView reloadData];
    
    [self.toDosTableView beginUpdates];
    
    NSMutableArray *newList = [[NSMutableArray alloc] init];
    TDToDo *newTodo = [[TDToDo alloc] initWithDescription:sender.text];

    [newList addObject:newTodo];
    
    for (TDToDo *todo in self.toDosDataSource) {
        [newList addObject:todo];
    }
    
    self.toDosDataSource = newList;
    
    NSArray *paths = @[[NSIndexPath indexPathForRow:0 inSection:0]];
    [self.toDosTableView insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationTop];
    
    [self.toDosTableView endUpdates];

    NSLog(@"Added New ToDo Entry: %@", [self.toDosDataSource firstObject]);
    [sender setText:@""];
}

UITableViewCell *longPressSelectedCell;
TDToDo *longPressSelectedToDo;
NSIndexPath *longPressSelectedIndexPath;
CGPoint originalCenter;
- (void)longPress:(UIGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        
        NSLog(@"Long press began at: %@.", NSStringFromCGPoint([gesture locationInView:self.toDosTableView]));
        [self resignFirstResponder];
        CGPoint cellLocation = [gesture locationInView:self.toDosTableView];
        longPressSelectedIndexPath =  [self.toDosTableView indexPathForRowAtPoint:cellLocation];
        longPressSelectedToDo = [self.toDosDataSource objectAtIndex:longPressSelectedIndexPath.row];
        originalCenter = [self.toDosTableView cellForRowAtIndexPath:longPressSelectedIndexPath].center;
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        
        CGPoint cellLocation = [gesture locationInView:self.toDosTableView];
        
        if (cellLocation.y > (longPressSelectedCell.frame.size.height))
        {
            NSIndexPath *newIndexPath =  [self.toDosTableView indexPathForRowAtPoint:cellLocation];
            
            if (newIndexPath && newIndexPath.row != longPressSelectedIndexPath.row) {
            
                [self.toDosTableView beginUpdates];
                [self.toDosTableView deleteRowsAtIndexPaths:@[longPressSelectedIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
                
                if (newIndexPath.row > longPressSelectedIndexPath.row) {

                    [self.toDosDataSource insertObject:longPressSelectedToDo atIndex:newIndexPath.row+1];
                    [self.toDosDataSource removeObjectAtIndex:longPressSelectedIndexPath.row];
                } else {

                    [self.toDosDataSource removeObjectAtIndex:longPressSelectedIndexPath.row];
                    [self.toDosDataSource insertObject:longPressSelectedToDo atIndex:newIndexPath.row];
                }
                
                [self.toDosTableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationLeft];

                
                [self.toDosTableView endUpdates];
                
                longPressSelectedIndexPath =  [self.toDosTableView indexPathForRowAtPoint:cellLocation];
            }
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Adding swipe gesture: right direction
    [self.toDosDataSource addObject:[[TDToDo alloc] initWithDescription:@"Comprar pao"]];
    [self.toDosDataSource addObject:[[TDToDo alloc] initWithDescription:@"Arrumar malas"]];
    [self.toDosDataSource addObject:[[TDToDo alloc] initWithDescription:@"Levar TV no conserto"]];
    [self.toDosDataSource addObject:[[TDToDo alloc] initWithDescription:@"Aprender guitarra"]];
    [self.toDosDataSource addObject:[[TDToDo alloc] initWithDescription:@"Terminar Bioshock pela 2a vez"]];
    [self.toDosDataSource addObject:[[TDToDo alloc] initWithDescription:@"Deixar esse App do caralho"]];
    [self.toDosDataSource addObject:[[TDToDo alloc] initWithDescription:@"Terminar de ler artigos de IA"]];
    [self.toDosDataSource addObject:[[TDToDo alloc] initWithDescription:@"Terminar de ler capítulo do livro de IA"]];
    [self.toDosDataSource addObject:[[TDToDo alloc] initWithDescription:@"Comprar CDs novos"]];
    [self.toDosDataSource addObject:[[TDToDo alloc] initWithDescription:@"Comprar livros novos"]];
    [self.toDosDataSource addObject:[[TDToDo alloc] initWithDescription:@"Agendar revisão do carro"]];
    [self.toDosDataSource addObject:[[TDToDo alloc] initWithDescription:@"Virar mestre do mundo"]];
    [self.toDosDataSource addObject:[[TDToDo alloc] initWithDescription:@"Terminar de ler artigos de IA"]];
    [self.toDosDataSource addObject:[[TDToDo alloc] initWithDescription:@"Pesquisa de preço - Monitor IPS 27\""]];
    
    UISwipeGestureRecognizer *swipeRec = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)];
    [swipeRec setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.toDosTableView addGestureRecognizer:swipeRec];
    
    // Adding swipe gesture: left direction
    swipeRec = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)];
    [swipeRec setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.toDosTableView addGestureRecognizer:swipeRec];
    
    UILongPressGestureRecognizer *longPressRec = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [longPressRec setNumberOfTouchesRequired:1];
    [self.toDosTableView addGestureRecognizer:longPressRec];
    
    // Add vertical line to look line a notebook
//    CALayer *redLineLayer = [[CALayer alloc] init];
//    redLineLayer.frame = CGRectMake(20, (self.view.bounds.size.height-self.toDosTableView.bounds.size.height)-40, 2.0f, self.toDosTableView.bounds.size.height+40);
//    redLineLayer.backgroundColor = [[UIColor redColor] CGColor];
//    
//    [self.view.layer addSublayer:redLineLayer];
    
//    [self.searchAndAddTextField setFont:[UIFont fontWithName:@"Chalkduster" size:18.0]];
    
//    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
//    gradientLayer.frame = self.view.bounds;
//    gradientLayer.colors = @[(id)[[UIColor colorWithRed:1.0f green:1.f blue:1.0f alpha:1.0f ] CGColor],
//                             (id)[[UIColor colorWithRed:.8f green:0.8f blue:.8f alpha:.75f ] CGColor],
//                             (id)[[UIColor colorWithRed:0.7f green:0.7f blue:0.7f alpha:.25f ] CGColor],
//                             (id)[[UIColor colorWithRed:.6f green:.6f blue:.6f alpha:.5f ] CGColor]];
//    gradientLayer.locations = @[@0.05f];
//    [self.view.layer insertSublayer:gradientLayer atIndex:0];
    [self.toDosTableView setBackgroundColor:[UIColor clearColor]];
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

    NSLog(@"Swiped left");
    CGPoint location = [sender locationInView:self.toDosTableView];
    
    NSIndexPath *indexPath = [self.toDosTableView indexPathForRowAtPoint:location];


    if (self.isFiltering) {
        editView.toDo = [self.filteredToDosDataSource objectAtIndex:indexPath.row];
    } else {
        editView.toDo = [self.toDosDataSource objectAtIndex:indexPath.row];
    }
    
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
        [self.toDosTableView deleteRowsAtIndexPaths:indexPaths
                                       withRowAnimation:UITableViewRowAnimationAutomatic];
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
    if (self.isFiltering) {
        return self.filteredToDosDataSource.count;
    } else {
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
    TDToDo *toDo = [self.toDosDataSource objectAtIndex:indexPath.row];
    [toDo toggleActive];
    [self.toDosTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)swipeLeft:(UISwipeGestureRecognizer *)gesture
{
    NSLog(@"Swiped left");
    CGPoint location = [gesture locationInView:self.toDosTableView];
    
    NSIndexPath *indexPath = [self.toDosTableView indexPathForRowAtPoint:location];

    if (indexPath) {
        [self performSegueWithIdentifier:@"DetailToDo" sender:gesture];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    TDToDosCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    TDToDo *todo;
    
    if (self.isFiltering) {
        todo = [self.filteredToDosDataSource objectAtIndex:indexPath.row];
    }
    else {
        todo = [self.toDosDataSource objectAtIndex:indexPath.row];
    }
    cell.toDosTextField.textColor = [UIColor blackColor];
    if (todo.active) {
        if (todo.priority) {
            cell.toDosTextField.textColor = [UIColor redColor];
        }
        [cell.toDosTextField setText:todo.description];
    }
    else {
        cell.toDosTextField.attributedText = [self strikeThroughText:todo.description];
    }
    
    cell.toDosTextField.tag = indexPath.row;
    
    CALayer *leftSquare = [CALayer layer];
    leftSquare.frame = CGRectMake(0, 0, 10, cell.bounds.size.height);
    leftSquare.backgroundColor = [[UIColor blueColor] CGColor];
    [cell.layer addSublayer:leftSquare];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TDToDo *toDo = [self.toDosDataSource objectAtIndex:indexPath.row];
    [toDo togglePriority];
    [self.toDosTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

@end
