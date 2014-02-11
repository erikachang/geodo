//
//  TDToDoCell.h
//  ProjectToDos
//
//  Created by Stephan Chang on 2/11/14.
//  Copyright (c) 2014 The ToDo Party. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TDToDoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *toDoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *priorityIcon;

@end
