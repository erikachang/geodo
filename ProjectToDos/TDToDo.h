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
@property BOOL active;

-(instancetype)initWithDescription:(NSString *)aDescription;
-(void)addNotificationConfigurationWithLocation:(NSString *)aLocation;
-(void)addNotificationConfigurationWithDateTime:(NSDate *)aDateTime;
@end
