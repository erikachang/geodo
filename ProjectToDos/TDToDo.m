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
        _description = aDescription;
        _active = YES;
        _priority = NO;
    }
    return self;
}

- (void)addNotificationConfigurationWithLocation:(NSString *)aLocation
{
    TDNotificationConfiguration *notification = [[TDNotificationConfiguration alloc] initWithLocation:aLocation];
    [self.reminders addObject:notification];
}

- (void)addNotificationConfigurationWithDateTime:(NSDate *)aDate with:(NSDate *)aTime with:(NSMutableArray *)aWeekDays
{
    TDNotificationConfiguration *notification = [[TDNotificationConfiguration alloc] initWithDate:aDate andTime:aTime orWeekDays:aWeekDays];
    [self.reminders addObject:notification];
}

- (void)toggleActive
{
    _active = !_active;
    if (!_active) {
        _priority = NO;
    }
}

- (void)togglePriority
{
    if (_active) {
        _priority = !_priority;
    }
}
@end
