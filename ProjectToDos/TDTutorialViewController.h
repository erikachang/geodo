//
//  TDTutorialViewController.h
//  ProjectToDos
//
//  Created by Stephan Chang on 2/10/14.
//  Copyright (c) 2014 The ToDo Party. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TDTutorialViewController : UIPageViewController
@property (weak, nonatomic) IBOutlet UILabel *tutorialLabel;
@property (weak, nonatomic) IBOutlet UIImageView *tutorialImageView;
@property NSUInteger pageIndex;
@property NSString *pageTitle;
@property NSString *imageFileName;

@end
