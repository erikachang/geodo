//
//  TDNotificationConfiguration.m
//  ProjectToDos
//
//  Created by Stephan Chang on 1/29/14.
//  Copyright (c) 2014 The ToDo Party. All rights reserved.
//

#import "TDNotificationConfiguration.h"



@implementation TDNotificationConfiguration

- (instancetype)initWithDate:(NSDate *)aDate andTime:(NSDate *)aTime orWeekDays:(NSMutableArray *)aWeekDays
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
        if (!isRecorrente) {
            self.type = DateTime;
        
            NSDateFormatter *data = [[NSDateFormatter alloc] init];
            [data setDateFormat:@"dd/MM/yyyy"];
            NSString *descricaoData = [data stringFromDate:aDate];
            NSDateFormatter *hora = [[NSDateFormatter alloc] init];
            [hora setDateFormat:@"HH:mm"]; //24hr time format
            NSString *descricaoHora = [hora stringFromDate:aTime];
            self.notificationDescription = [NSString stringWithFormat:@"No dia: %@ às %@", descricaoData, descricaoHora];
        }
        else {
            self.type = DateTime;
            
            NSDateFormatter *hora = [[NSDateFormatter alloc] init];
            [hora setDateFormat:@"HH:mm"]; //24hr time format
            NSString *descricaoHora = [hora stringFromDate:aTime];
            
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

- (instancetype)initWithLocation:(SL_Localidades *)aLocation
{
    if (self = [super init])
    {
        self.location = aLocation;
        self.type = Location;
        self.notificationDescription = [NSString stringWithFormat:@"Quando eu chegar em %@", aLocation.identificador];
    }
    return self;
}

- (void)addLocalnotifications:(UILocalNotification *)object{
    if(_arrayLocalNotifications==nil){
        _arrayLocalNotifications = [[NSMutableArray alloc]init];
    }
    [_arrayLocalNotifications addObject:object];
}



@end
