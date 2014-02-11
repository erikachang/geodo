//
//  TDTutorialViewController.m
//  ProjectToDos
//
//  Created by Stephan Chang on 2/10/14.
//  Copyright (c) 2014 The ToDo Party. All rights reserved.
//

#import "TDTutorialViewController.h"

@interface TDTutorialViewController ()

@end

@implementation TDTutorialViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tutorialImageView.image = [UIImage imageNamed:self.imageFileName];
    self.tutorialLabel.text = self.pageTitle;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
