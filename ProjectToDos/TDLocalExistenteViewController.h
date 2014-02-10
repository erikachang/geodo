//
//  TDLocalExistenteViewController.h
//  ProjectToDos
//
//  Created by Matheus Cavalca on 04/02/14.
//  Copyright (c) 2014 The ToDo Party. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SL_armazenaDados.h"
#import "SL_Localidades.h"
#import "TDLocaisCell.h"
#import "TDEditToDoViewController.h"
#import "TDMapaLocaisViewController.h"

@interface TDLocalExistenteViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *tableViewLocais;
@property (strong, nonatomic) IBOutlet UILabel *lblIdentificador;

@property(nonatomic, retain)TDEditToDoViewController *superController;

@property (nonatomic , strong) CLLocationManager* locationManager;
@end
