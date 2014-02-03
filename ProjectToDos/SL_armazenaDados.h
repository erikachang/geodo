//
//  SL_armazenaDados.h
//  TesteSilencioso
//
//  Created by Matheus Cavalca on 28/01/14.
//  Copyright (c) 2014 Matheus Cavalca. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SL_armazenaDados : NSObject

@property (nonatomic, retain) NSMutableArray* listNotificacoes;
@property (nonatomic, retain) NSMutableArray* listLocalidades;
@property (nonatomic, retain) NSMutableDictionary* dicNotsRegs;

+ (id)sharedArmazenaDados;

@end
