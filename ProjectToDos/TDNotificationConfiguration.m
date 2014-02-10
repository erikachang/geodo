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
        NSDateComponents *componentsDate = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:aDate];
        NSInteger day = [componentsDate day];
        NSInteger month = [componentsDate month];
        NSInteger year = [componentsDate year];
        
        NSDateComponents *componentsHour = [[NSCalendar currentCalendar] components:NSCalendarUnitHour | NSCalendarUnitMinute fromDate:aTime];
        NSInteger hour = [componentsHour hour];
        NSInteger minute = [componentsHour minute];
    
        NSString* descricaoData = [[NSString alloc]initWithFormat: @"%i/%i/%i",day,month,year];
        NSString* descricaoHora = [[NSString alloc]initWithFormat: @"%i:%i",hour,minute];
        self.notificationDescription = [NSString stringWithFormat:@"No dia: %@ às %@", descricaoData,descricaoHora];
    }
    return self;
}

-(instancetype)initWithLocation:(SL_Localidades *)aLocation
{
    if (self = [super init])
    {
        self.location = aLocation;
        self.type = Location;
        self.notificationDescription = [NSString stringWithFormat:@"Quando eu chegar em %@", aLocation.identificador];
    }
    return self;
}


@end
