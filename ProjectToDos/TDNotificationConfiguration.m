//
//  TDNotificationConfiguration.m
//  ProjectToDos
//
//  Created by Stephan Chang on 1/29/14.
//  Copyright (c) 2014 The ToDo Party. All rights reserved.
//

#import "TDNotificationConfiguration.h"



@implementation TDNotificationConfiguration

-(instancetype)initWithDateAndTime:(NSDate *)aDateTime
{
    if (self = [super init])
    {
        self.dateTime = aDateTime;
        self.type = DateTime;
        self.notificationDescription = [NSString stringWithFormat:@"No dia: %@.", [aDateTime description]];
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
