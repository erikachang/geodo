//
//  TDEditToDoViewController.m
//  ProjectToDos
//
//  Created by Stephan Chang on 1/28/14.
//  Copyright (c) 2014 The ToDo Party. All rights reserved.
//

#import "TDEditToDoViewController.h"
#import "MapKitDragAndDropViewController.h"
#import "TDDateAndTimeViewController.h"
#import "TDLocalExistenteViewController.h"
#import "TDGlobalConfiguration.h"
#import "APLPositionToBoundsMapping.h"

@interface TDEditToDoViewController ()
{
    id btAux;
}
@property (weak, nonatomic) IBOutlet UIButton *addDateTimeNotificationButton;
@property (weak, nonatomic) IBOutlet UIButton *addLocationNotificationButton;
@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITableView *remindersTableView;

@property (strong, nonatomic) NSMutableDictionary *sectionsDic;

@end

@implementation TDEditToDoViewController

CAGradientLayer *grad;
short _editToDoViewControllerCharacterLimit = 40;

- (void)hideKeyboard {
    [self.view endEditing:YES];
}

- (IBAction)limitCharacterInput:(UITextField *)sender {
    if (sender.text.length >= _editToDoViewControllerCharacterLimit) {
        sender.text = [sender.text substringToIndex:_editToDoViewControllerCharacterLimit];
    }
}

- (IBAction)changeToDoNameAndViewTitle:(UITextField *)sender {
    [self resignFirstResponder];
    
    if ([sender.text isEqualToString:@""]) {
        sender.text = self.toDo.description;
    }
    else {
        self.toDo.description = sender.text;
    }
}

- (NSMutableDictionary *)sectionsDic
{
    if (_sectionsDic == nil)
        _sectionsDic = [[NSMutableDictionary alloc] init];
    return _sectionsDic;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)gotoDateAndTime
{
    [self performSegueWithIdentifier:@"AddDateTimeNotification" sender:Nil];
}

- (void)gotoLocation
{
    [self performSegueWithIdentifier:@"AddLocationNotification" sender:Nil];
}

- (void)swipeRight:(UISwipeGestureRecognizer *)gesture
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Table View delegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return self.sectionsDic.allKeys.count;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.sectionsDic.allKeys objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.toDo.reminders.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"cellReminders";
    TDRemindersCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    NSArray *reminders = self.toDo.reminders;
    
    [cell setBackgroundColor:[TDGlobalConfiguration backgroundColor]];
    [cell.lblText setTextColor:[TDGlobalConfiguration fontColor]];
    [cell.lblText setFont:[UIFont fontWithName:[TDGlobalConfiguration fontName] size:[TDGlobalConfiguration fontSize]]];
    
    cell.lblText.text =[[reminders objectAtIndex:indexPath.row] notificationDescription];
    cell.lblText.numberOfLines = 0;
    
    cell.btRemove.tag = indexPath.row;
    
    [cell.btRemove addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}

- (IBAction)buttonAction:(id)sender
{
    UIButton *button1 = (UIButton *)sender;
    btAux = sender;

    NSIndexPath *path = [NSIndexPath indexPathForRow:button1.tag inSection:0];
    UITableViewCell *cell = [self.tabView cellForRowAtIndexPath:path];
    
    UICollisionBehavior *collision = [[UICollisionBehavior alloc] initWithItems:@[cell]];
    [collision setTranslatesReferenceBoundsIntoBoundaryWithInsets:UIEdgeInsetsMake(cell.bounds.size.width + cell.bounds.size.width, 0, cell.bounds.size.width + cell.bounds.size.width+1, -400)];
    UIDynamicAnimator *animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    animator.delegate = self;
    
    UIGravityBehavior *gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[cell]];
    
    [gravityBehavior setGravityDirection:CGVectorMake(15.0, 0.0)];
    [animator addBehavior:gravityBehavior];
    [animator addBehavior:collision];
    
    self.animator = animator;

}

- (void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator
{
    [self btRemove_Click:btAux];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 72;
}

-(void)btRemove_Click :(id)sender
{
    @try{
        TDNotificationConfiguration *reminder = [[TDNotificationConfiguration alloc]init];
        NSInteger tag = [sender tag];
        NSString* identificador = [self.toDo.reminders[tag] notificationDescription];
        for(int i=0;i<[_toDo reminders].count;i++){
            reminder = [_toDo reminders][i];
            if([identificador isEqualToString: reminder.notificationDescription]){
                if(reminder.type == Location){
                    [_toDo removeNotificationConfigurationBasedOnLocation: i];
                    break;
                }
                if(reminder.type == DateTime){
                    [_toDo removeNotificationConfigurationBasedOnLocation: i];
                    for(int j=0; j<reminder.arrayLocalNotifications.count;j++){
                        [[UIApplication sharedApplication] cancelLocalNotification: reminder.arrayLocalNotifications[j]];
                    }
                    break;
                }
            }
        }
    }
    @catch(NSException* exception){
        [_tabView reloadData];
    }
    @finally {
        [_tabView reloadData];
    }
}

#pragma mark - Parte do audio record

- (IBAction)recordAudio:(id)sender {
    if (![_toDo audioRecorder].recording)
    {
        _playButton.enabled = NO;
        _stopButton.enabled = YES;
        _playButton.hidden = YES;
        _stopButton.hidden = NO;
        [[_toDo audioRecorder ] record];
        [_toDo setRecorded:YES];
    }
}

- (IBAction)playAudio:(id)sender {
    if (![_toDo audioRecorder ].recording)
    {
        _stopButton.enabled = YES;
        _recordButton.enabled = NO;
        
        _stopButton.hidden = NO;
        _playButton.hidden = YES;
        
        NSError *error;
        
        _toDo.audioPlayer = [[AVAudioPlayer alloc]
                             initWithContentsOfURL:[_toDo audioRecorder].url
                             error:&error];
        
        _toDo.audioPlayer.delegate = self;
        
        if (error)
            NSLog(@"Error: %@",
                  [error localizedDescription]);
        else
            [[_toDo audioPlayer] play];
    }
}

- (IBAction)stopAudio:(id)sender {
    _stopButton.enabled = NO;
    _playButton.enabled = YES;
    _recordButton.enabled = YES;

    _stopButton.hidden = YES;
    _playButton.hidden = NO;
    
    if ([_toDo audioRecorder].recording)
    {
        [[_toDo audioRecorder] stop];
    } else if ([_toDo audioPlayer].playing) {
        [[_toDo audioPlayer] stop];
    }
}


-(void)audioPlayerDidFinishPlaying:
(AVAudioPlayer *)player successfully:(BOOL)flag
{
    _recordButton.enabled = YES;
    _stopButton.enabled = NO;
    
    _stopButton.hidden = YES;
    _playButton.hidden = NO;
}

-(void)audioPlayerDecodeErrorDidOccur:
(AVAudioPlayer *)player
                                error:(NSError *)error
{
    NSLog(@"Decode Error occurred");
}

-(void)audioRecorderDidFinishRecording:
(AVAudioRecorder *)recorder
                          successfully:(BOOL)flag
{
}

-(void)audioRecorderEncodeErrorDidOccur:
(AVAudioRecorder *)recorder
                                  error:(NSError *)error
{
    NSLog(@"Encode Error occurred");
}

#pragma mark - Parte da notificacao por local

- (IBAction)btLocal_click:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sua decisão"
                                                    message:@"Escolha entre local existente e um novo local"
                                                   delegate:self
                                          cancelButtonTitle:@"Existente"
                                          otherButtonTitles:@"Adicionar Local",nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0){
        [self performSegueWithIdentifier:@"getExistentLocal" sender:self];
    }else{
        [self performSegueWithIdentifier:@"AddLocationNotification" sender:self];
    }
    [_tabView reloadData];
}

- (void) freshLatitudeLongitude :(SL_Localidades*)local{
    self.location = self.locationManager.location;
    
    //CLRegion* regAux;
    //for(int i=0; i<[[[SL_armazenaDados sharedArmazenaDados] listLocalidades]count];i++){
    //    regAux = [[[SL_armazenaDados sharedArmazenaDados]listLocalidades][i] regiao];
    //    [self.locationManager startMonitoringForRegion: regAux];
    //}
    
    //[self.locationManager startMonitoringForRegion:local.regiao];
    
    [_superController freshLatitudeLongitude:local];
    [_toDo addNotificationConfigurationWithLocation:local];
    
    int flagRegionNotInitialized=1;
    for(int i=0; i< [[SL_armazenaDados sharedArmazenaDados]listToDosRegs].count;i++){
        if([[[[SL_armazenaDados sharedArmazenaDados]listToDosRegs][i] regionIdentifier] isEqualToString:local.regiao.identifier]){
            [[[SL_armazenaDados sharedArmazenaDados]listToDosRegs][i] addToDo:_toDo];
            flagRegionNotInitialized=0;
            break;
        }
    }
    
    if(flagRegionNotInitialized){
        TD_RegiaoToDo *regionToDo = [[TD_RegiaoToDo alloc]initAll:local.regiao.identifier with:_toDo];
        [[[SL_armazenaDados sharedArmazenaDados] listToDosRegs] addObject:regionToDo];
    }
    
    [_tabView reloadData];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self hideKeyboard];
    
    if([[segue identifier] isEqualToString:@"AddLocationNotification"])
    {
        MapKitDragAndDropViewController *child = (MapKitDragAndDropViewController *)segue.destinationViewController;
        [child setSuperController:self];
    }
    else if([[segue identifier] isEqualToString:@"getExistentLocal"])
    {
        TDLocalExistenteViewController *child = (TDLocalExistenteViewController*)segue.destinationViewController;
        [child setSuperController:self];
    }
    else if([[segue identifier] isEqualToString:@"AddDateTimeNotification"])
    {
        TDDateAndTimeViewController *child = (TDDateAndTimeViewController*)segue.destinationViewController;
        [child setSuperController:self];
    }
}


- (void)addDate:(NSDate *)date andTime:(NSDate *)time orWeekDays:(NSMutableArray *)weekDays
{
    if(date==nil){
        [self.toDo addNotificationConfigurationWithDateTime:date with:time with:weekDays];
        TDNotificationConfiguration *reminder = [self.toDo reminders][[self.toDo reminders].count-1];
        [_tabView reloadData];
        
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *comps = [gregorian components:NSWeekdayCalendarUnit fromDate:[NSDate date]];
        //aqui retorna de 1 a 7 e o vetor vem de 0 a 6
        int todaysWeekDay = [comps weekday]-1;
        int todasWeekDayIncremento = todaysWeekDay;
        for(int i=0; i<7;i++,todasWeekDayIncremento++){
            if ([weekDays containsObject:[NSNumber numberWithInt:todasWeekDayIncremento]]){
                //aqui vai as notificacoes certinhas com o fire date e repeat interval
                
                NSDateComponents *timeComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitHour | NSCalendarUnitMinute fromDate:time];
                
                NSDateComponents *componentsDate = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
                
                
                [componentsDate setHour: timeComponents.hour];
                [componentsDate setMinute: timeComponents.minute];
                
                
                NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
                NSDate *fireDate = [gregorian dateFromComponents:componentsDate];
                
                NSDateComponents *adicionaDia = [[NSDateComponents alloc] init];
                
                if((todasWeekDayIncremento - todaysWeekDay)<0){
                    [adicionaDia setDay: 7+(todasWeekDayIncremento - todaysWeekDay)];
                }
                else{
                    [adicionaDia setDay: todasWeekDayIncremento - todaysWeekDay];
                }
                
                fireDate = [[NSCalendar currentCalendar] dateByAddingComponents:adicionaDia
                                                                         toDate:fireDate
                                                                        options:0];
                
                UILocalNotification *notification = [[UILocalNotification alloc] init];
                notification.fireDate = fireDate;
                
                notification.repeatInterval = NSWeekCalendarUnit;
                NSTimeZone* timezone = [NSTimeZone defaultTimeZone];
                notification.timeZone = timezone;
                notification.alertBody = [_toDo description];
                notification.alertAction = @"Analisar notificação";
                notification.soundName = @"alarm.wav";
                [[UIApplication sharedApplication] scheduleLocalNotification:notification];
                
                [reminder addLocalnotifications:notification];

            }
            if(todasWeekDayIncremento==6){
                todasWeekDayIncremento=-1;
            }
        }
        
    }else{
        //por enquanto só com data e hora.
        [self.toDo addNotificationConfigurationWithDateTime:date with:time with:weekDays];
        TDNotificationConfiguration *reminder = [self.toDo reminders][[self.toDo reminders].count-1];
        [_tabView reloadData];
        
        NSDateComponents *timeComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitHour | NSCalendarUnitMinute fromDate:time];
        
        NSDateComponents *componentsDate = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
        
        [componentsDate setHour: timeComponents.hour];
        [componentsDate setMinute: timeComponents.minute];
        
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDate *fireDate = [gregorian dateFromComponents:componentsDate];
        
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.fireDate = fireDate;
        NSTimeZone* timezone = [NSTimeZone defaultTimeZone];
        notification.timeZone = timezone;
        notification.alertBody = [_toDo description];
        notification.alertAction = @"Analisar notificação";
        notification.soundName = @"alarm.wav";
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        
        [reminder addLocalnotifications:notification];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 22;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.remindersTableView.frame.size.width, 25)];
    [view setBackgroundColor:[TDGlobalConfiguration fontColor]];
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(15, 0, self.remindersTableView.frame.size.width, view.frame.size.height)];
    
    [textField setFont:[UIFont fontWithName:[TDGlobalConfiguration fontName] size:[TDGlobalConfiguration fontSizeSmall]]];
//    [textField setBackgroundColor:[TDGlobalConfiguration fontColor]];
    [textField setText:self.toDo.description];
    [textField addTarget:self action:@selector(changeToDoNameAndViewTitle:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [textField addTarget:self action:@selector(limitCharacterInput:) forControlEvents:UIControlEventEditingChanged];
    
    [view addSubview:textField];
    return view;
}

#pragma mark Pan Gesture

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    CGPoint translation = [gestureRecognizer translationInView:[self.remindersTableView superview]];
    // Handle horizontal pan only
    return fabsf(translation.x) > fabsf(translation.y);
}

CGPoint _originalCenter, _cellLocation;
BOOL _markComplete, _detailToDo;
UITableViewCell *_firstCell;
- (void)panLeft:(UIPanGestureRecognizer *)recognizer {
    // When the pan begins, take note of what cell the gesture started at and its location.
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        
        _cellLocation = [recognizer locationInView:self.remindersTableView];
        NSIndexPath *indexPath = [self.remindersTableView indexPathForRowAtPoint:_cellLocation];
        _firstCell = [self.remindersTableView cellForRowAtIndexPath:indexPath];
        _originalCenter = _firstCell.center;
    }
    
    // Translates the cell, following the user's gesture.
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        
        CGPoint translation = [recognizer translationInView:_firstCell];
        _firstCell.center = CGPointMake(_originalCenter.x + translation.x, _originalCenter.y);
        
        // Checks whether the cell has been moved to the far left or the far right
        // and flags an action as a consequence.
//        _detailToDo = _firstCell.frame.origin.x < -_firstCell.frame.size.width / 3; // Panning to the left brings up the detailed ToDo View.
        _markComplete = _firstCell.frame.origin.x > _firstCell.frame.size.width/ 3; // Panning to the right marks the task as complete.
    }
    
    // When the user let go of the touch screen, decides whether an action needs to be taken and performs it.
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        CGRect originalFrame = CGRectMake(0, _firstCell.frame.origin.y,
                                          _firstCell.bounds.size.width, _firstCell.bounds.size.height);
        
        if (!_markComplete) {
            // if the item is not being deleted, snap back to the original location
            [UIView animateWithDuration:0.2
                             animations:^{
                                 _firstCell.frame = originalFrame;
                             }
             ];
        } else {
            
            NSIndexPath *indexPath = [self.remindersTableView indexPathForRowAtPoint:_cellLocation];
            
            TDNotificationConfiguration *reminder = [self.toDo.reminders objectAtIndex:indexPath.row];
            
            [self.toDo removeNotificationConfigurationBasedOnLocation:indexPath.row];
            
            if (reminder.type == DateTime) {
                for(int i=0; i<reminder.arrayLocalNotifications.count;i++) {
                    [[UIApplication sharedApplication] cancelLocalNotification: reminder.arrayLocalNotifications[i]];
                }
            }
            
            [self.remindersTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
        }
    }
}

#pragma mark View Delegates

- (void)viewWillAppear:(BOOL)animated
{
    [[self navigationController] setNavigationBarHidden:NO];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //parte do recorder
    if(![_toDo recorded]){
        _playButton.enabled = NO;
    }
    _stopButton.enabled = NO;
    _stopButton.hidden = YES;
    _playButton.hidden = NO;
    
    if([_toDo audioRecorder]==nil){
        NSArray *dirPaths;
        NSString *docsDir;
        
        
        dirPaths = NSSearchPathForDirectoriesInDomains(
                                                       NSDocumentDirectory, NSUserDomainMask, YES);
        docsDir = [dirPaths objectAtIndex:0];
        NSString *pathComponent = [[NSString alloc]initWithFormat:@"%@.caf", [_toDo description]];
        NSString *soundFilePath = [docsDir
                                   stringByAppendingPathComponent:pathComponent];
        
        NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
        
        NSDictionary *recordSettings = [NSDictionary
                                        dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithInt:AVAudioQualityMin],
                                        AVEncoderAudioQualityKey,
                                        [NSNumber numberWithInt:16],
                                        AVEncoderBitRateKey,
                                        [NSNumber numberWithInt: 2],
                                        AVNumberOfChannelsKey,
                                        [NSNumber numberWithFloat:44100.0],
                                        AVSampleRateKey,
                                        nil];
        
        NSError *error = nil;
        
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord
                            error:nil];
        
        _toDo.audioRecorder = [[AVAudioRecorder alloc]
                               initWithURL:soundFileURL
                               settings:recordSettings
                               error:&error];
        
        if (error)
        {
            NSLog(@"error: %@", [error localizedDescription]);
        }   else {
            [[_toDo audioRecorder] prepareToRecord];
        }
    }
    //fim do recorder
    
    grad = [TDGlobalConfiguration gradientLayer];
    grad.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    [self.view.layer insertSublayer:grad atIndex:0];
    
    NSMutableArray *barButtons = [[NSMutableArray alloc] init];
    UIBarButtonItem *locationBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"plus_map"] style:UIBarButtonItemStylePlain target:self action:@selector(btLocal_click:)];
    UIBarButtonItem *dateBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"plus_datetime"] style:UIBarButtonItemStylePlain target:self action:@selector(gotoDateAndTime)];
    [barButtons addObject:locationBarButton];
    [barButtons addObject:dateBarButton];
    
    self.navigationItem.rightBarButtonItems = barButtons;
    
	// Do any additional setup after loading the view.
//    [self.titleTextField setBorderStyle:UITextBorderStyleNone];
//    [self.titleTextField setText:self.toDo.description];
//    [self.titleTextField setFont:[UIFont fontWithName:[TDGlobalConfiguration fontName] size:[TDGlobalConfiguration fontSize]]];
//    [self.titleTextField setTextColor:[TDGlobalConfiguration fontColor]];
    
    NSDictionary *sections = @{@"Lembre-me:":@"Lembre-me:"};
    [self.sectionsDic addEntriesFromDictionary:sections];
    [self.remindersTableView setBackgroundColor:[TDGlobalConfiguration controlBackgroundColor]];
//    [self.view setBackgroundColor:[TDGlobalConfiguration backgroundColor]];
    
    // Adding Swip Gesture Recognizers
//    UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)];
//    [swipeRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
//    [self.view addGestureRecognizer:swipeRecognizer];
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panLeft:)];
    [self.remindersTableView addGestureRecognizer:panRecognizer];
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    tapRecognizer.numberOfTapsRequired = 1;
    tapRecognizer.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:tapRecognizer];
    
    // Date and Time Notification button customization
    {
        [self.addDateTimeNotificationButton setTitle:@"+ Data/Hora" forState:UIControlStateNormal];
        [self.addDateTimeNotificationButton setTitleColor:[TDGlobalConfiguration buttonColor] forState:UIControlStateNormal];
    }
    
    // Location Notification button customization
    {
        [self.addLocationNotificationButton setTitle:@"+ Local" forState:UIControlStateNormal];
        [self.addLocationNotificationButton setTitleColor:[TDGlobalConfiguration buttonColor] forState:UIControlStateNormal];
    }
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
