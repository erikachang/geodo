//
//  TD_RegiaoToDo.h
//  ProjectToDos
//
//  Created by Matheus Cavalca on 06/02/14.
//  Copyright (c) 2014 The ToDo Party. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TDToDo.h"

@interface TD_RegiaoToDo : NSObject

@property NSString* regionIdentifier;
@property NSMutableArray* listToDos;

-(id) initAll: (NSString*) ident with : (TDToDo*) toDo;
-(void)addToDo : (TDToDo*) toDo;
-(void)removeToDo : (TDToDo*) toDo;
-(BOOL)hasToDo;
@end
