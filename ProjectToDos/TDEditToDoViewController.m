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

@interface TDEditToDoViewController ()
@property (weak, nonatomic) IBOutlet UIButton *addDateTimeNotificationButton;
@property (weak, nonatomic) IBOutlet UIButton *addLocationNotificationButton;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITableView *remindersTableView;

@property (strong, nonatomic) NSMutableDictionary *sectionsDic;

@end

@implementation TDEditToDoViewController

short _editToDoViewControllerCharacterLimit = 40;

- (IBAction)limitCharacterInput:(UITextField *)sender {
    if (sender.text.length >= _editToDoViewControllerCharacterLimit) {
        sender.text = [sender.text substringToIndex:_editToDoViewControllerCharacterLimit];
    }
}

- (IBAction)changeToDoNameAndViewTitle:(UITextField *)sender {
    [self resignFirstResponder];
    
    if ([self.titleTextField.text isEqualToString:@""]) {
        self.titleTextField.text = self.toDo.description;
    }
    else {
        self.toDo.description = self.titleTextField.text;
        self.title = self.titleTextField.text;
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

- (void)viewWillAppear:(BOOL)animated
{
    [[self navigationController] setNavigationBarHidden:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //parte do recorder
    if(![_toDo recorded]){
        _playButton.enabled = NO;
    }
    _stopButton.enabled = NO;
    
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
    

	// Do any additional setup after loading the view.
    [self.titleTextField setBorderStyle:UITextBorderStyleNone];
    [self.titleTextField setText:self.toDo.description];
    NSDictionary *sections = @{@"Lembre-me:":@"Lembre-me:"};
    [self.sectionsDic addEntriesFromDictionary:sections];
    [self.remindersTableView setBackgroundColor:[UIColor clearColor]];
 
    // Adding Swip Gesture Recognizers
    UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)];
    [swipeRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:swipeRecognizer];
    
    // Date and Time Notification button customization
    {
        [self.addDateTimeNotificationButton setTitle:@"+ Data/Hora" forState:UIControlStateNormal];
        [self.addDateTimeNotificationButton addTarget:self action:@selector(gotoDateAndTime) forControlEvents:UIControlEventTouchDown];
    }
    
    // Location Notification button customization
    {
        [self.addLocationNotificationButton setTitle:@"+ Local" forState:UIControlStateNormal];
        [self.addLocationNotificationButton addTarget:self action:@selector(gotoLocation) forControlEvents:UIControlEventTouchDown];
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
    
    
    cell.lblText.text =[[reminders objectAtIndex:indexPath.row] notificationDescription];
    cell.lblText.numberOfLines = 0;
    
    cell.btRemove.tag = indexPath.row;
    [cell.btRemove addTarget:self action:@selector(btRemove_Click:) forControlEvents:UIControlEventTouchUpInside];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}

-(void)btRemove_Click :(id)sender
{
    TDNotificationConfiguration *reminder = [[TDNotificationConfiguration alloc]init];
    NSInteger tag = [sender tag];
    NSString* identificador = [self.toDo.reminders[tag] notificationDescription];
    
    
    for(int i=0;i<[_toDo reminders].count;i++){
        reminder = [_toDo reminders][i];
        if([identificador isEqualToString: reminder.notificationDescription]){
            if(reminder.type == Location){
                [_toDo removeNotificationConfigurationBasedOnLocation: i];
                [self verificarPossivelParadaDeMonitoramento : reminder.location.regiao];
                break;
            }
        }
    }
    [_tabView reloadData];
}

-(void) verificarPossivelParadaDeMonitoramento : (CLRegion*) regiao{
    
}


#pragma mark - Parte do audio record

- (IBAction)recordAudio:(id)sender {
    if (![_toDo audioRecorder].recording)
    {
        _playButton.enabled = NO;
        _stopButton.enabled = YES;
        [[_toDo audioRecorder ] record];
        [_toDo setRecorded:YES];
    }
}

- (IBAction)playAudio:(id)sender {
    if (![_toDo audioRecorder ].recording)
    {
        _stopButton.enabled = YES;
        _recordButton.enabled = NO;
        
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
}

- (void) freshLatitudeLongitude :(SL_Localidades*)local{
    self.location = self.locationManager.location;
    
    //CLRegion* regAux;
    //for(int i=0; i<[[[SL_armazenaDados sharedArmazenaDados] listLocalidades]count];i++){
    //    regAux = [[[SL_armazenaDados sharedArmazenaDados]listLocalidades][i] regiao];
    //    [self.locationManager startMonitoringForRegion: regAux];
    //}
    
    [self.locationManager startMonitoringForRegion:local.regiao];
    
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


-(void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    //terá que ser visto qual é a data para saber colocar no fireDate e também ver se já passou a data
    //para cancelar o region monitoring
    
    NSMutableArray *arrayToDos = [[SL_armazenaDados sharedArmazenaDados]listToDosRegs];
    NSMutableArray *arrayRemoveToDos = [[NSMutableArray alloc]init];
    NSMutableArray *arrayRemoveReminders = [[NSMutableArray alloc]init];
    
    for (TD_RegiaoToDo *RegiaoToDo in arrayToDos) {
        if([[RegiaoToDo regionIdentifier]isEqualToString:region.identifier]){
            for(TDToDo* toDo in [RegiaoToDo listToDos] ){
                for(TDNotificationConfiguration* reminder in [toDo reminders]){
                    if([reminder.location.regiao.identifier isEqualToString:region.identifier]){
                        //essa parte é sem cláusula de horário
                        NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
                        NSDate *currentDate = [NSDate date];
                        NSDate *fireDate = nil;
                        
                        [dateComponents setSecond: 1];
                        
                        fireDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents
                                                                                 toDate:currentDate
                                                                                options:0];
                        
                        UILocalNotification *notification = [[UILocalNotification alloc] init];
                        notification.fireDate = [NSDate date];
                        NSTimeZone* timezone = [NSTimeZone defaultTimeZone];
                        notification.timeZone = timezone;
                        notification.alertBody = [toDo description];
                        notification.alertAction = @"Analisar notificação";
                        notification.soundName = @"alarm.wav";
                        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
                        
                        //aqui vai precisar para quando tiver cláusula de horário
                        //[[[SL_armazenaDados sharedArmazenaDados]dicNotsRegs] setObject:notification forKey:region.identifier];
                        [arrayRemoveReminders addObject:reminder];
                        [arrayRemoveToDos addObject:toDo];
                    }
                }
                for(TDNotificationConfiguration* reminder in arrayRemoveReminders){
                    [[toDo reminders] removeObject:reminder];
                }
            }
        }
        for(TDToDo* toDo in arrayRemoveToDos){
            [RegiaoToDo removeToDo:toDo];
        }
        if(![RegiaoToDo hasToDo]){
            [self.locationManager stopMonitoringForRegion:region];
        }
    }
    [_tabView reloadData];
}

-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    //cancelar a partir da region, ver se funciona quando o didEnterRegion não foi feito antes
    for(int i=0;i<[[[SL_armazenaDados sharedArmazenaDados] listLocalidades]count];i++){
        SL_Localidades* locAux = [[SL_armazenaDados sharedArmazenaDados]listLocalidades][i];
        if([locAux.regiao.identifier isEqualToString : region.identifier]){
            id object = [[[SL_armazenaDados sharedArmazenaDados]dicNotsRegs] objectForKey:region.identifier];
            if(object){
                int index = [[UIApplication sharedApplication]indexOfAccessibilityElement:object];
                if(index>=0){
                    [[UIApplication sharedApplication] cancelLocalNotification: [[[SL_armazenaDados sharedArmazenaDados]dicNotsRegs] objectForKey:region.identifier]];
                }
            }
        }
    }
}

-(void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region {
    NSLog(@"Now monitoring for %@", region.identifier);
}



- (void)addDate:(NSDate *)date andTime:(NSDate *)time orWeekDays:(NSMutableArray *)weekDays
{
    [self.toDo addNotificationConfigurationWithDateTime:date with:time with:weekDays];
    [_tabView reloadData];
}

@end
