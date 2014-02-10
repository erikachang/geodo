//
//  TDToDo.h
//  ProjectToDos
//
//  Created by Stephan Chang on 1/28/14.
//  Copyright (c) 2014 The ToDo Party. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TDNotificationConfiguration.h"

@interface TDToDo : NSObject
@property NSString *description;
@property (readonly) NSMutableArray *reminders;
@property (readonly) BOOL active;
@property (readonly) BOOL priority;

- (instancetype)initWithDescription:(NSString *)aDescription;
- (void)addNotificationConfigurationWithLocation:(NSString *)aLocation;
- (void)addNotificationConfigurationWithDateTime:(NSDate *)aDate with:(NSDate *)aTime with:(NSMutableArray *)aWeekDays;
- (void)toggleActive;
- (void)togglePriority;
@end
