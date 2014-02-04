//
//  TDToDosTextField.m
//  ProjectToDos
//
//  Created by Stephan Chang on 2/4/14.
//  Copyright (c) 2014 The ToDo Party. All rights reserved.
//

#import "TDToDosTextField.h"

@implementation TDToDosTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)doubleTap:(UITapGestureRecognizer *)gesture
{
    NSLog(@"Double tap detected.");
    [self setSelected:YES];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
