//
//  SL_Localidades.h
//  TesteSilencioso
//
//  Created by Matheus Cavalca on 29/01/14.
//  Copyright (c) 2014 Matheus Cavalca. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MapKit/MapKit.h>

@interface SL_Localidades : NSObject

@property (nonatomic, retain) NSString* identificador;
@property CLRegion* regiao;
@property float latitude;
@property float longitude;
@property float raio;

-(id) initAll: (NSString*) ident with : (float) latitude with : (float) longitude with : (float) raio;
@end
