//
//  TDNotificationConfiguration.h
//  ProjectToDos
//
//  Created by Stephan Chang on 1/29/14.
//  Copyright (c) 2014 The ToDo Party. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SL_Localidades.h"

@interface TDNotificationConfiguration : NSObject
enum TDNotificationType {
    Location = 0,
    DateTime = 1
};


@property SL_Localidades *location;
@property NSDate *date;
@property NSDate *time;
@property NSMutableArray *weekDays;
@property enum TDNotificationType type;
@property NSString *notificationDescription;

- (instancetype) initWithLocation:(SL_Localidades *)aLocation;
-(instancetype)initWithDate:(NSDate *)aDate andTime:(NSDate *)aTime orWeekDays:(NSMutableArray *)aWeekDays;

@end
