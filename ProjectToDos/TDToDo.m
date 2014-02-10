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
        _reminders = [[NSMutableArray alloc]init];
    }
    return self;
}

-(void)addNotificationConfigurationWithLocation:(SL_Localidades *)aLocation
{
    TDNotificationConfiguration *notification = [[TDNotificationConfiguration alloc] initWithLocation:aLocation];
    [self.reminders addObject:notification];
}

-(void)removeNotificationConfigurationBasedOnLocation:(int)indiceNotificationConfiguration
{
    [self.reminders removeObjectAtIndex:indiceNotificationConfiguration];
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

-(BOOL) hasReminderByRegion : (NSString*)regionIdentifier
{
    for(TDNotificationConfiguration *notification in _reminders){
        if([notification.location.regiao.identifier isEqualToString:regionIdentifier]){
            return true;
        }
    }
    return false;
}

@end
