//
//  TDRemindersCell.m
//  ProjectToDos
//
//  Created by Matheus Cavalca on 07/02/14.
//  Copyright (c) 2014 The ToDo Party. All rights reserved.
//

#import "TDRemindersCell.h"
#import "APLPositionToBoundsMapping.h"

@implementation TDRemindersCell

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
    
    self.btRemove.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
    self.btRemove.contentVerticalAlignment = UIControlContentHorizontalAlignmentFill;
    
}

@end

