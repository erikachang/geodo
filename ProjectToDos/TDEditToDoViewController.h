//
//  TDEditToDoViewController.h
//  ProjectToDos
//
//  Created by Stephan Chang on 1/28/14.
//  Copyright (c) 2014 The ToDo Party. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TDToDo.h"

@interface TDEditToDoViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) TDToDo *toDo;

@end
