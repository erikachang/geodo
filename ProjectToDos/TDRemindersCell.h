//
//  TDRemindersCell.h
//  ProjectToDos
//
//  Created by Matheus Cavalca on 07/02/14.
//  Copyright (c) 2014 The ToDo Party. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDRemindersCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblText;
@property (strong, nonatomic) IBOutlet UIButton *btRemove;
@end
