//
//  SL_armazenaDados.m
//  TesteSilencioso
//
//  Created by Matheus Cavalca on 28/01/14.
//  Copyright (c) 2014 Matheus Cavalca. All rights reserved.
//

#import "SL_armazenaDados.h"

@implementation SL_armazenaDados

@synthesize listNotificacoes;
@synthesize listLocalidades;
@synthesize dicNotsRegs;
@synthesize listToDosRegs;

static SL_armazenaDados *sharedArmazenaDados = nil;

#pragma mark Singleton Methods

+ (id)sharedArmazenaDados {
    if (sharedArmazenaDados == nil) {
        sharedArmazenaDados = [[super allocWithZone:NULL] init];
    }
    return sharedArmazenaDados;
}

- (id)init {
    if (self = [super init]) {
        listNotificacoes = [[NSMutableArray alloc]init];
        listLocalidades = [[NSMutableArray alloc]init];
        dicNotsRegs = [[NSMutableDictionary alloc]init];
        listToDosRegs = [[NSMutableArray alloc]init];
        
    }
    return self;
}

@end
