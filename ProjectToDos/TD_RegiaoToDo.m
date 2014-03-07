//
//  TD_RegiaoToDo.m
//  ProjectToDos
//
//  Created by Matheus Cavalca on 06/02/14.
//  Copyright (c) 2014 The ToDo Party. All rights reserved.
//

#import "TD_RegiaoToDo.h"

@implementation TD_RegiaoToDo

@synthesize listToDos;
@synthesize regionIdentifier;

- (instancetype)initAll:(NSString*)ident with:(TDToDo*)toDo
{
    self = [super init];
    
    if (self) {
        [self setRegionIdentifier:ident];
        listToDos = [[NSMutableArray alloc]init];
        [self addToDo:toDo];
    }
    
    return self;
}

- (void)addToDo:(TDToDo*)toDo
{
    [listToDos addObject:toDo];
}

- (void)removeToDo:(TDToDo*)toDo
{
    [listToDos removeObject:toDo];
}

- (BOOL)hasToDo
{
    return listToDos.count != 0;
}
@end
