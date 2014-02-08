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

short characterLimit = 40;

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

    if (self.searchAndAddTextField.text.length >= characterLimit) {
        self.searchAndAddTextField.text = [self.searchAndAddTextField.text substringToIndex:characterLimit];
    }
    
    self.isFiltering = YES;
    [self.filteredToDosDataSource removeAllObjects];
    [self.toDosTableView reloadData];
    
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

- (IBAction)addNewToDo:(UITextField *)sender {
    if ([sender.text isEqualToString:@""])
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

TDToDo *_longPressSelectedToDo;
NSIndexPath *_longPressSelectedIndexPath, *_originalIndexPath;
CGPoint _previousCenter, _originalLocation;
UITableViewCell *_movingCell;
- (void)longPress:(UILongPressGestureRecognizer *)gesture
{
    CGPoint cellLocation = [gesture locationInView:self.toDosTableView];
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        
        if ([self.searchAndAddTextField isFirstResponder]) {
            [self.searchAndAddTextField resignFirstResponder];
        }
        
        _longPressSelectedIndexPath =  [self.toDosTableView indexPathForRowAtPoint:cellLocation];
        _originalIndexPath = _longPressSelectedIndexPath;
        _longPressSelectedToDo = [self.toDosDataSource objectAtIndex:_longPressSelectedIndexPath.row];
        _previousCenter = [self.toDosTableView cellForRowAtIndexPath:_longPressSelectedIndexPath].center;
        _originalLocation = _previousCenter;
        _movingCell = [self.toDosTableView cellForRowAtIndexPath:_longPressSelectedIndexPath];
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        
        NSIndexPath *newIndexPath =  [self.toDosTableView indexPathForRowAtPoint:cellLocation];
//        UITableViewCell *cell = [self.toDosTableView cellForRowAtIndexPath:_longPressSelectedIndexPath];
        if (_longPressSelectedIndexPath.row != newIndexPath.row) {
            if (newIndexPath.row > _longPressSelectedIndexPath.row) {
                [UIView animateWithDuration:.3 animations:^{
                    for (int k = _longPressSelectedIndexPath.row; k < newIndexPath.row; k++) {
                        
                        if (_originalIndexPath.row != k) {
                        NSLog(@"Empurrando. k: %d; Original: %d", k, _originalIndexPath.row);
                            
                        NSIndexPath *cellIndex = [NSIndexPath indexPathForRow:k inSection:0];
                        UITableViewCell *cell = [self.toDosTableView cellForRowAtIndexPath:cellIndex];
                        CGPoint cellCenter = cell.center;
                        
                        cellCenter.y = cell.bounds.size.height/2 + (cell.bounds.size.height * (k-1));
                        cellCenter.x = _originalLocation.x;
                        cell.center = cellCenter;
                        }
                    }
                }];

            } else {
                [UIView animateWithDuration:.3 animations:^{
                    for (int k = self.toDosDataSource.count-1; k > newIndexPath.row; k--) {
                        
                            NSIndexPath *cellIndex = [NSIndexPath indexPathForRow:k inSection:0];
                            UITableViewCell *cell = [self.toDosTableView cellForRowAtIndexPath:cellIndex];
                            CGPoint cellCenter = cell.center;
                            
                            cellCenter.y = cell.bounds.size.height/2 + (cell.bounds.size.height * k);
                            cellCenter.x = _originalLocation.x;
                            cell.center = cellCenter;
                    }
                }];

            }
        }
        NSLog(@"Row: %d; Previous: %d; Original: %d", newIndexPath.row, _longPressSelectedIndexPath.row, _originalIndexPath.row);
        _longPressSelectedIndexPath =  [self.toDosTableView indexPathForRowAtPoint:cellLocation];
        CGPoint center = _movingCell.center;
        
//        center.x += cellLocation.x - _previousCenter.x;
        center.y += cellLocation.y - _previousCenter.y;
        
        _movingCell.center = center;
        _previousCenter = cellLocation;
    } else if (gesture.state == UIGestureRecognizerStateEnded) {
        
        NSIndexPath *newIndexPath =  [self.toDosTableView indexPathForRowAtPoint:cellLocation];
        
        if (newIndexPath) {
            
//            [self.toDosTableView beginUpdates];
            {
//                [self.toDosTableView deleteRowsAtIndexPaths:@[_longPressSelectedIndexPath] withRowAnimation:UITableViewRowAnimationNone];
                
                // Depending on the relative position of the cell, its re-insertion in the table must consider its new position after its removal.
                if (newIndexPath.row >= _longPressSelectedIndexPath.row) {
                    
                    [self.toDosDataSource insertObject:_longPressSelectedToDo atIndex:newIndexPath.row+1];
                    [self.toDosDataSource removeObjectAtIndex:_longPressSelectedIndexPath.row];
                } else {
                    
                    [self.toDosDataSource removeObjectAtIndex:_longPressSelectedIndexPath.row];
                    [self.toDosDataSource insertObject:_longPressSelectedToDo atIndex:newIndexPath.row];
                }
                
//                [self.toDosTableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            };
//            [self.toDosTableView endUpdates];
            [self.toDosTableView reloadData];
            //_longPressSelectedIndexPath =  [self.toDosTableView indexPathForRowAtPoint:cellLocation];
        } else {
            UITableViewCell *cell = [self.toDosTableView cellForRowAtIndexPath:_longPressSelectedIndexPath];
            [UIView animateWithDuration:.3 animations:^{
                cell.center = _originalLocation;
            }];
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
    [self.toDosDataSource addObject:[[TDToDo alloc] initWithDescription:@"Arrumar malas"]];
    [self.toDosDataSource addObject:[[TDToDo alloc] initWithDescription:@"Levar TV no conserto"]];
    [self.toDosDataSource addObject:[[TDToDo alloc] initWithDescription:@"Levar carro na revisão"]];
    [self.toDosDataSource addObject:[[TDToDo alloc] initWithDescription:@"Aprender guitarra"]];
    [self.toDosDataSource addObject:[[TDToDo alloc] initWithDescription:@"Terminar Bioshock pela 2a vez"]];
    [self.toDosDataSource addObject:[[TDToDo alloc] initWithDescription:@"Deixar esse App do caralho"]];
    [self.toDosDataSource addObject:[[TDToDo alloc] initWithDescription:@"Terminar de ler artigos de IA"]];
    [self.toDosDataSource addObject:[[TDToDo alloc] initWithDescription:@"Terminar de ler capítulo do livro de IA"]];
    [self.toDosDataSource addObject:[[TDToDo alloc] initWithDescription:@"Comprar CDs novos"]];
    [self.toDosDataSource addObject:[[TDToDo alloc] initWithDescription:@"Comprar livros novos"]];
    [self.toDosDataSource addObject:[[TDToDo alloc] initWithDescription:@"Comprar filmes novos"]];
    [self.toDosDataSource addObject:[[TDToDo alloc] initWithDescription:@"Terminar \"NHK ni Youkoso!\""]];
    [self.toDosDataSource addObject:[[TDToDo alloc] initWithDescription:@"Virar mestre do mundo"]];
    
    for (int i = 0; i < 1000; i++) {
        [self.toDosDataSource addObject:[[TDToDo alloc] initWithDescription:@"Virar mestre do mundo"]];
    }
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panLeft:)];
    panRecognizer.delegate = self;
    [self.toDosTableView addGestureRecognizer:panRecognizer];
    
    UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [longPressRecognizer setNumberOfTouchesRequired:1];
    [self.toDosTableView addGestureRecognizer:longPressRecognizer];
    
    [self.toDosTableView setBackgroundColor:[UIColor clearColor]];
    [self.searchAndAddTextField setFont:[UIFont fontWithName:@"Papyrus" size:17.0]];
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
