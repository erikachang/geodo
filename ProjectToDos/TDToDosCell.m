//
//  TDToDosCell.m
//  ProjectToDos
//
//  Created by Stephan Chang on 1/31/14.
//  Copyright (c) 2014 The ToDo Party. All rights reserved.
//

#import "TDToDosCell.h"

@implementation TDToDosCell

//CGPoint panStartingPoint;
//BOOL markComplete;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
//        UIGestureRecognizer *gestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
//        gestureRecognizer.delegate = self;
//        [self addGestureRecognizer:gestureRecognizer];
    }
    return self;
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated
//{
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}
//
//- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer
//{
//    CGPoint panTranslation = [gestureRecognizer translationInView:[self superview]];
//    
//    if (fabsf(panTranslation.x) > fabsf(panTranslation.y))
//    {
//        return YES;
//    }
//    
//    return NO;
//}
//
//- (void)panGesture:(UIPanGestureRecognizer *)gestureRecognizer
//{
//    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
//        panStartingPoint = self.center;
//    } else if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
//        CGPoint panTranslation = [gestureRecognizer translationInView:[self superview]];
//        self.center = CGPointMake(panStartingPoint.x + panTranslation.x, panStartingPoint.y);
//        markComplete = self.frame.origin.x < -self.frame.size.width/2;
//    } else if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
//        CGRect originalFrame = CGRectMake(0, self.frame.origin.y, self.bounds.size.width, self.bounds.size.height);
//        
//        if (!markComplete) {
//            [UIView animateWithDuration:0.2 animations:^{ self.frame = originalFrame;} ];
//        }
//    }
//}

@end
