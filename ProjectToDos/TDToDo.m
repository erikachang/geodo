//
//  TDToDo.m
//  ProjectToDos
//
//  Created by Stephan Chang on 1/28/14.
//  Copyright (c) 2014 The ToDo Party. All rights reserved.
//

#import "TDToDo.h"

@implementation TDToDo

- (instancetype)initWithDescription:(NSString *)aDescription
{
    if (self = [super init])
    {
        self.description = aDescription;
        self.active = YES;
    }
    return self;
}

-(void)addNotificationConfigurationWithLocation:(NSString *)aLocation
{
    TDNotificationConfiguration *notification = [[TDNotificationConfiguration alloc] initWithLocation:aLocation];
    [self.reminders addObject:notification];
}

-(void)addNotificationConfigurationWithDateTime:(NSDate *)aDateTime
{
    TDNotificationConfiguration *notification = [[TDNotificationConfiguration alloc] initWithDateAndTime:aDateTime];
    [self.reminders addObject:notification];
}
@end
