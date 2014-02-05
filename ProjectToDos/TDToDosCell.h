//
//  TDToDosCell.h
//  ProjectToDos
//
//  Created by Stephan Chang on 1/31/14.
//  Copyright (c) 2014 The ToDo Party. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDToDo.h"
#import "TDToDosTextField.h"

@interface TDToDosCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *toDosTextField;

@end
