//
//  TDToDo.h
//  ProjectToDos
//
//  Created by Stephan Chang on 1/28/14.
//  Copyright (c) 2014 The ToDo Party. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "TDNotificationConfiguration.h"
#import "SL_Localidades.h"

@interface TDToDo : NSObject
@property NSString *description;
@property (readonly) NSMutableArray *reminders;
@property (readonly) BOOL active;
@property (readonly) BOOL priority;

@property BOOL recorded;
@property (strong, nonatomic) AVAudioRecorder *audioRecorder;
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;

- (instancetype)initWithDescription:(NSString *)aDescription;
- (void)addNotificationConfigurationWithLocation:(SL_Localidades *)aLocation;
- (void)addNotificationConfigurationWithDateTime:(NSDate *)aDate with:(NSDate *)aTime with:(NSMutableArray *)aWeekDays;
- (void)toggleActive;
- (void)togglePriority;

-(void)removeNotificationConfigurationBasedOnLocation:(int)indiceNotificationConfiguration;
-(BOOL) hasReminderByRegion : (NSString*)regionIdentifier;
@end
