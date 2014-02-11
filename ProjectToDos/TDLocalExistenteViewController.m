//
//  TDLocalExistenteViewController.m
//  ProjectToDos
//
//  Created by Matheus Cavalca on 04/02/14.
//  Copyright (c) 2014 The ToDo Party. All rights reserved.
//

#import "TDLocalExistenteViewController.h"
#import "TDGlobalConfiguration.h"

@interface TDLocalExistenteViewController ()

@end

@implementation TDLocalExistenteViewController
{
    NSMutableArray *arrayItems;
}

@synthesize superController;

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Escolher local";
    
    [self.lblIdentificador setFont:[UIFont fontWithName:[TDGlobalConfiguration fontName] size:[TDGlobalConfiguration fontSize]]];
    [self.lblIdentificador setTextColor:[TDGlobalConfiguration fontColor]];
    [self.tableViewLocais setBackgroundColor:[TDGlobalConfiguration controlBackgroundColor]];
    
    arrayItems = [[NSMutableArray alloc]init];
    for(int i=0; i<[[SL_armazenaDados sharedArmazenaDados]listLocalidades].count; i++){
        [arrayItems addObject:[[[SL_armazenaDados sharedArmazenaDados] listLocalidades][i] identificador]];
    }
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
    _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
    [_locationManager startUpdatingLocation];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrayItems.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //UILabel *lblTitle = (UILabel *)[cell viewWithTag:10];
    //lblTitle.text = [arrayItems objectAtIndex:indexPath.row];
    
    
    static NSString *CellIdentifier = @"cellLocais";
    TDLocaisCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    [cell.lblIdentificador setText:[arrayItems objectAtIndex:indexPath.row]];
    
    [cell setBackgroundColor:[TDGlobalConfiguration backgroundColor]];
    
    cell.btConfirma.tag = indexPath.row;
    [cell.btConfirma addTarget:self action:@selector(btConfirma_Click:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

-(void)btConfirma_Click :(id)sender
{
    SL_Localidades *local = [[SL_Localidades alloc]init];
    NSInteger tag = [sender tag];
    NSString* identificador = arrayItems[tag];
    
    
    for(int i=0;i<[[[SL_armazenaDados sharedArmazenaDados] listLocalidades] count];i++){
        local = [[SL_armazenaDados sharedArmazenaDados] listLocalidades][i];
        if([identificador isEqualToString: local.identificador]){
            [self.superController freshLatitudeLongitude: local];
            [self.navigationController popViewControllerAnimated:YES];
            break;
        }
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"segueMapaLocalidades"])
    {
        TDMapaLocaisViewController *child = (TDMapaLocaisViewController *)segue.destinationViewController;
        NSIndexPath *idxPath = [self.tableViewLocais indexPathForCell:sender];
        
        SL_Localidades *local = [[SL_Localidades alloc]init];
        for(int i=0;i<[[[SL_armazenaDados sharedArmazenaDados] listLocalidades] count];i++){
            local = [[SL_armazenaDados sharedArmazenaDados] listLocalidades][i];
            if([[arrayItems objectAtIndex:idxPath.row] isEqualToString: local.identificador]){
                child.local = local;
            }
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
