//
//  TDToDosCell.m
//  ProjectToDos
//
//  Created by Stephan Chang on 1/31/14.
//  Copyright (c) 2014 The ToDo Party. All rights reserved.
//

#import "TDToDosCell.h"

@implementation TDToDosCell

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
    [self.textLabel setFont:[UIFont fontWithName:@"Papyrus" size:17.0]];
    [self setBackgroundColor:[UIColor clearColor]];
}

@end
