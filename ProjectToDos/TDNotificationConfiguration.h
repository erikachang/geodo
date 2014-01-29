//
//  TDNotificationConfiguration.h
//  ProjectToDos
//
//  Created by Stephan Chang on 1/29/14.
//  Copyright (c) 2014 The ToDo Party. All rights reserved.
//

#import <Foundation/Foundation.h>

enum TDNotificationType {
    Location = 0,
    DateTime = 1
};

@interface TDNotificationConfiguration : NSObject
@property NSString *location;
@property NSDate *dateTime;
@property enum TDNotificationType type;
@property NSString *notificationDescription;

- (instancetype) initWithLocation:(NSString *)aLocation;
- (instancetype) initWithDateAndTime:(NSDate *)aDateTime;
@end
