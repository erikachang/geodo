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

short _characterLimit = 40;

#pragma mark Properties
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

#pragma mark Custom methods
- (NSIndexPath *)getFirstNonPriorityIndex
{
    int row = 0;
    for (TDToDo *toDo in self.toDosDataSource) {
        if (toDo.priority) {
            row++;
        }
    }
    return [NSIndexPath indexPathForRow:row inSection:0];
}

- (NSAttributedString *)strikeThroughText:(NSString *)text
{
    NSDictionary* attributes = @{
                                 NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle]
                                 };
    
    NSAttributedString* attrText = [[NSAttributedString alloc] initWithString:text attributes:attributes];
    return attrText;
}

#pragma mark Actions
- (IBAction)onTheFlySearch:(UITextField *)sender {
    
    if (sender.text.length >= _characterLimit) {
        sender.text = [sender.text substringToIndex:_characterLimit];
    }
    
    self.isFiltering = YES;
    [self.filteredToDosDataSource removeAllObjects];
    [self.toDosTableView reloadData];
    
    if ([sender.text isEqualToString:@":Completas"]) {
     
        for (TDToDo *todo in self.toDosDataSource) {
            if (!todo.active) {

                    [self.filteredToDosDataSource addObject:todo];
                    [self.toDosTableView reloadData];
            }
        }
    } else {
    
        for (TDToDo *todo in self.toDosDataSource) {
            if (sender.text.length <= todo.description.length) {

                NSString *initials = [todo.description substringToIndex:sender.text.length];
                if ([initials isEqualToString:sender.text]) {
                    [self.filteredToDosDataSource addObject:todo];
                    [self.toDosTableView reloadData];
                }
            }
        }
    }
}

- (IBAction)addNewToDo:(UITextField *)sender {
    if ([sender.text isEqualToString:@""] || [sender.text isEqualToString:@":Completas"])
        return;
    
    self.isFiltering = NO;
    [self.toDosTableView reloadData];
    [self.toDosTableView beginUpdates];
    {
    
        NSMutableArray *newList = [[NSMutableArray alloc] init];
        TDToDo *newTodo = [[TDToDo alloc] initWithDescription:sender.text];

        [newList addObject:newTodo];
        
        for (TDToDo *todo in self.toDosDataSource) {
            [newList addObject:todo];
        }
        
        self.toDosDataSource = newList;
        
        NSArray *paths = @[[NSIndexPath indexPathForRow:0 inSection:0]];
        [self.toDosTableView insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationTop];
    }
    [self.toDosTableView endUpdates];

    [sender setText:@""];
}

#pragma mark Gestures

TDToDo *_selectedToDo;
NSIndexPath *_previousIndexPath;
- (void)longPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    CGPoint touchLocation = [gestureRecognizer locationInView:self.toDosTableView];
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        
        if ([self.searchAndAddTextField isFirstResponder]) {
            [self.searchAndAddTextField resignFirstResponder];
        }
        
        _previousIndexPath = [self.toDosTableView indexPathForRowAtPoint:touchLocation];
        _selectedToDo = [self.toDosDataSource objectAtIndex:_previousIndexPath.row];
    } else if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        NSIndexPath *indexPathAtTouchLocation =  [self.toDosTableView indexPathForRowAtPoint:touchLocation];
        
        if (indexPathAtTouchLocation && indexPathAtTouchLocation.row != _previousIndexPath.row) {
            
            [self.toDosTableView beginUpdates];
            {
                [self.toDosTableView deleteRowsAtIndexPaths:@[_previousIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
                
                // Depending on the relative position of the cell, its re-insertion in the table must consider its new position after its removal.
                if (indexPathAtTouchLocation.row > _previousIndexPath.row) {
                    
                    [self.toDosDataSource insertObject:_selectedToDo atIndex:indexPathAtTouchLocation.row+1];
                    [self.toDosDataSource removeObjectAtIndex:_previousIndexPath.row];
                } else {
                    
                    [self.toDosDataSource removeObjectAtIndex:_previousIndexPath.row];
                    [self.toDosDataSource insertObject:_selectedToDo atIndex:indexPathAtTouchLocation.row];
                }
                
                [self.toDosTableView insertRowsAtIndexPaths:@[indexPathAtTouchLocation] withRowAnimation:UITableViewRowAnimationLeft];
            };
            [self.toDosTableView endUpdates];
            _previousIndexPath =  [self.toDosTableView indexPathForRowAtPoint:touchLocation];
        }
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    CGPoint translation = [gestureRecognizer translationInView:[self.toDosTableView superview]];
    // Handle horizontal pan only
    return fabsf(translation.x) > fabsf(translation.y);
}

CGPoint _originalCenter, _cellLocation;
BOOL _markComplete, _detailToDo;
UITableViewCell *_firstCell;
- (void)panLeft:(UIPanGestureRecognizer *)recognizer {
    // When the pan begins, take note of what cell the gesture started at and its location.
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        
        _cellLocation = [recognizer locationInView:self.toDosTableView];
        NSIndexPath *indexPath = [self.toDosTableView indexPathForRowAtPoint:_cellLocation];
        _firstCell = [self.toDosTableView cellForRowAtIndexPath:indexPath];
        _originalCenter = _firstCell.center;
    }
    
    // Translates the cell, following the user's gesture.
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        
        CGPoint translation = [recognizer translationInView:_firstCell];
        _firstCell.center = CGPointMake(_originalCenter.x + translation.x, _originalCenter.y);
        
        // Checks whether the cell has been moved to the far left or the far right
        // and flags an action as a consequence.
        _detailToDo = _firstCell.frame.origin.x < -_firstCell.frame.size.width / 3; // Panning to the left brings up the detailed ToDo View.
        _markComplete = _firstCell.frame.origin.x > _firstCell.frame.size.width/ 3; // Panning to the right marks the task as complete.
    }
    
    // When the user let go of the touch screen, decides whether an action needs to be taken and performs it.
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        CGRect originalFrame = CGRectMake(0, _firstCell.frame.origin.y,
                                          _firstCell.bounds.size.width, _firstCell.bounds.size.height);
        
        if (!_detailToDo && !_markComplete) {
            // if the item is not being deleted, snap back to the original location
            [UIView animateWithDuration:0.2
                             animations:^{
                                 _firstCell.frame = originalFrame;
                             }
             ];
        } else if (_detailToDo) {
            
            NSIndexPath *indexPath = [self.toDosTableView indexPathForRowAtPoint:_cellLocation];
            
            if (indexPath) {
                [self performSegueWithIdentifier:@"DetailToDo" sender:recognizer];
            }
        } else if (_markComplete) {
            
            NSIndexPath *indexPath = [self.toDosTableView indexPathForRowAtPoint:_cellLocation];
            TDToDo *toDo = [self.toDosDataSource objectAtIndex:indexPath.row];
            [toDo toggleActive];
            
            if (toDo.active) {
                
                NSIndexPath *newIndexPath = [self getFirstNonPriorityIndex];
                
                [UIView animateWithDuration:.6 animations:^{
                    [self.toDosTableView beginUpdates];
                    
                    [self.toDosDataSource removeObjectAtIndex:indexPath.row];
                    [self.toDosDataSource insertObject:toDo atIndex:newIndexPath.row];
                    
                    [self.toDosTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
                    [self.toDosTableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationRight];
                    [self.toDosTableView endUpdates];
                }];
            } else {
                
                [UIView animateWithDuration:.6 animations:^{
                    
                    [self.toDosTableView beginUpdates];
                    
                    int newIndex = self.toDosDataSource.count-1;
                    
                    [self.toDosDataSource removeObjectAtIndex:indexPath.row];
                    [self.toDosDataSource insertObject:toDo atIndex:newIndex];
                    
                    [self.toDosTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
                    [self.toDosTableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:newIndex inSection:0]] withRowAnimation:UITableViewRowAnimationRight];
                    [self.toDosTableView endUpdates];
                    
                }];
            }
            
        }
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
    if (motion == UIEventSubtypeMotionShake) {
        
        NSMutableArray *toDosToBeDeleted = [[NSMutableArray alloc] init];
        NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
        int row = 0;
        
        for (TDToDo *todo in self.toDosDataSource) {
            if (!todo.active) {
                [toDosToBeDeleted addObject:todo];
                [indexPaths addObject:[NSIndexPath indexPathForRow:row inSection:0]];
                
            }
            row++;
        }
        
        [self.toDosDataSource removeObjectsInArray:toDosToBeDeleted];
        
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
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
    
    cell.textLabel.textColor = [UIColor blackColor];
    
    if (todo.active) {
        if (todo.priority) {
            cell.textLabel.textColor = [UIColor redColor];
        }
        [cell.textLabel setText:todo.description];
    } else {
        
        cell.textLabel.attributedText = [self strikeThroughText:todo.description];
    }
    
    cell.textLabel.tag = indexPath.row;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TDToDo *toDo = [self.toDosDataSource objectAtIndex:indexPath.row];
    
    if (toDo.active) {
        [toDo togglePriority];
        
        if (toDo.priority) {
            
            [UIView animateWithDuration:.6 animations:^{
                [self.toDosTableView beginUpdates];
                
                [self.toDosDataSource removeObjectAtIndex:indexPath.row];
                [self.toDosDataSource insertObject:toDo atIndex:0];
                
                [self.toDosTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                [self.toDosTableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
                [self.toDosTableView endUpdates];
            }];
        } else {
            
            NSIndexPath *newIndexPath = [self getFirstNonPriorityIndex];
            
            [UIView animateWithDuration:.6 animations:^{
                [self.toDosTableView beginUpdates];
                
                [self.toDosDataSource removeObjectAtIndex:indexPath.row];
                [self.toDosDataSource insertObject:toDo atIndex:newIndexPath.row];
                
                [self.toDosTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                [self.toDosTableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                [self.toDosTableView endUpdates];
            }];
        }
    }
}

#pragma mark View delegates

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Adding swipe gesture: right direction
//    [self.toDosDataSource addObject:[[TDToDo alloc] initWithDescription:@"Arrumar malas"]];
//    [self.toDosDataSource addObject:[[TDToDo alloc] initWithDescription:@"Levar TV no conserto"]];
//    [self.toDosDataSource addObject:[[TDToDo alloc] initWithDescription:@"Levar carro na revisão"]];
//    [self.toDosDataSource addObject:[[TDToDo alloc] initWithDescription:@"Aprender guitarra"]];
//    [self.toDosDataSource addObject:[[TDToDo alloc] initWithDescription:@"Terminar Bioshock pela 2a vez"]];
//    [self.toDosDataSource addObject:[[TDToDo alloc] initWithDescription:@"Deixar esse App do caralho"]];
//    [self.toDosDataSource addObject:[[TDToDo alloc] initWithDescription:@"Terminar de ler artigos de IA"]];
//    [self.toDosDataSource addObject:[[TDToDo alloc] initWithDescription:@"Terminar de ler capítulo do livro de IA"]];
//    [self.toDosDataSource addObject:[[TDToDo alloc] initWithDescription:@"Comprar CDs novos"]];
//    [self.toDosDataSource addObject:[[TDToDo alloc] initWithDescription:@"Comprar livros novos"]];
//    [self.toDosDataSource addObject:[[TDToDo alloc] initWithDescription:@"Comprar filmes novos"]];
//    [self.toDosDataSource addObject:[[TDToDo alloc] initWithDescription:@"Terminar \"NHK ni Youkoso!\""]];
//    [self.toDosDataSource addObject:[[TDToDo alloc] initWithDescription:@"Virar mestre do mundo"]];
//    
//    for (int i = 0; i < 1000; i++) {
//        [self.toDosDataSource addObject:[[TDToDo alloc] initWithDescription:[NSString stringWithFormat:@"Placeholder Todo %d", i]]];
//    }
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panLeft:)];
    panRecognizer.delegate = self;
    [self.toDosTableView addGestureRecognizer:panRecognizer];
    
    UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [longPressRecognizer setNumberOfTouchesRequired:1];
    [self.toDosTableView addGestureRecognizer:longPressRecognizer];
    
    [self.toDosTableView setBackgroundColor:[UIColor clearColor]];
    [self.searchAndAddTextField setFont:[UIFont fontWithName:@"Didot" size:17.0]];
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
    
    NSIndexPath *indexPath = [self.toDosTableView indexPathForRowAtPoint:_cellLocation];

    if (self.isFiltering) {
        editView.toDo = [self.filteredToDosDataSource objectAtIndex:indexPath.row];
    } else {
        editView.toDo = [self.toDosDataSource objectAtIndex:indexPath.row];
    }
}

@end
