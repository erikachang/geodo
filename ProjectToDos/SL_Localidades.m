//
//  SL_Localidades.m
//  TesteSilencioso
//
//  Created by Matheus Cavalca on 29/01/14.
//  Copyright (c) 2014 Matheus Cavalca. All rights reserved.
//

#import "SL_Localidades.h"

@implementation SL_Localidades

@synthesize regiao;

-(id) initAll: (NSString*) ident with : (float) latitude with : (float) longitude with : (float) raio{
    self = [super init];
    
    if (self) {
        [self setIdentificador:ident];
        CLLocationCoordinate2D centre;
        centre.latitude = latitude;
        centre.longitude = longitude;
        regiao = [[CLRegion alloc] initCircularRegionWithCenter:centre radius:raio identifier:ident];
        
        self.raio = raio;
        self.latitude = latitude;
        self.longitude = longitude;
    }
    
    return self;
}

@end
