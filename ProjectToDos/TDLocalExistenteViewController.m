//
//  TDLocalExistenteViewController.m
//  ProjectToDos
//
//  Created by Matheus Cavalca on 04/02/14.
//  Copyright (c) 2014 The ToDo Party. All rights reserved.
//

#import "TDLocalExistenteViewController.h"

@interface TDLocalExistenteViewController ()

@end

@implementation TDLocalExistenteViewController
{
    NSMutableArray *arrayItems;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    arrayItems = [[NSMutableArray alloc]init];
    for(int i=0; i<[[SL_armazenaDados sharedArmazenaDados]listLocalidades].count; i++){
        [arrayItems addObject:[[[SL_armazenaDados sharedArmazenaDados] listLocalidades][i] identificador]];
    }
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
    
    cell.btConfirma.tag = indexPath.row;
    [cell.btConfirma addTarget:self action:@selector(btConfirma_Click:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

-(void)btConfirma_Click :(id)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Custom Button Pressed"
                                                        message:[NSString stringWithFormat: @"You pressed the custom button on cell"]
                                                       delegate:self cancelButtonTitle:@"Great"
                                              otherButtonTitles:nil];
    [alertView show];
    NSInteger tag = [sender tag];
    NSString* identificador = arrayItems[tag];
    NSLog(@"%@",identificador);
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
