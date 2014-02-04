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
    return cell;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
