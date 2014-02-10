//
//  TDNotificationConfiguration.m
//  ProjectToDos
//
//  Created by Stephan Chang on 1/29/14.
//  Copyright (c) 2014 The ToDo Party. All rights reserved.
//

#import "TDNotificationConfiguration.h"



@implementation TDNotificationConfiguration

-(instancetype)initWithDate:(NSDate *)aDate andTime:(NSDate *)aTime orWeekDays:(NSMutableArray *)aWeekDays
{
    if (self = [super init])
    {
        if (aDate != Nil) {
            self.date = aDate;
        }
        if (aTime != Nil) {
            self.time = aTime;
        }
        if (aWeekDays != Nil) {
            self.weekDays = aWeekDays;
        }
        self.type = DateTime;
        self.notificationDescription = [NSString stringWithFormat:@"No dia: %@.", [aDate description]];
    }
    return self;
}

-(instancetype)initWithLocation:(NSString *)aLocation
{
    if (self = [super init])
    {
        self.location = aLocation;
        self.type = Location;
        self.notificationDescription = [NSString stringWithFormat:@"Quando eu chegar em %@", aLocation];
    }
    return self;
}

@end
