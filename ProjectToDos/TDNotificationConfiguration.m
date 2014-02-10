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
        bool isRecorrente=NO;
        if (aDate != Nil) {
            self.date = aDate;
        }
        if (aTime != Nil) {
            self.time = aTime;
        }
        if (aWeekDays != Nil) {
            isRecorrente=YES;
            self.weekDays = aWeekDays;
        }
        if(!isRecorrente){
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
        else{
            self.type = DateTime;
            NSDateComponents *componentsHour = [[NSCalendar currentCalendar] components:NSCalendarUnitHour | NSCalendarUnitMinute fromDate:aTime];
            NSInteger hour = [componentsHour hour];
            NSInteger minute = [componentsHour minute];
            NSString* descricaoHora = [[NSString alloc]initWithFormat: @"%i:%i",hour,minute];
            
            NSString *descricaoDias = [[NSString alloc]init];
            for(int i =0; i<self.weekDays.count;i++){
                NSString *temp = [[NSMutableString alloc] init];
                switch ([self.weekDays[i] integerValue]) {
                    case 0:
                        temp=@"Dom";
                        break;
                    case 1:
                        temp=@"Seg";
                        break;
                    case 2:
                        temp=@"Ter";
                        break;
                    case 3:
                        temp=@"Qua";
                        break;
                    case 4:
                        temp=@"Qui";
                        break;
                    case 5:
                        temp=@"Sex";
                        break;
                    case 6:
                        temp=@"Sab";
                        break;
                    default:
                        break;
                }
                
                NSString *dscAux = [[NSString alloc]initWithFormat:@"%@; ",temp];
                descricaoDias = [descricaoDias stringByAppendingString: dscAux];
            }
            self.notificationDescription = [NSString stringWithFormat:@"Nos dias: %@ às %@", descricaoDias,descricaoHora];
        }
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

-(void)addLocalnotifications:(UILocalNotification *)object{
    if(_arrayLocalNotifications==nil){
        _arrayLocalNotifications = [[NSMutableArray alloc]init];
    }
    [_arrayLocalNotifications addObject:object];
}



@end
