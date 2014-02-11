//
//  TDToDoCell.m
//  ProjectToDos
//
//  Created by Stephan Chang on 2/11/14.
//  Copyright (c) 2014 The ToDo Party. All rights reserved.
//

#import "TDToDoCell.h"

@implementation TDToDoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code

    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.priorityIcon.image = [UIImage imageNamed:@"priority_16x16.png"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
