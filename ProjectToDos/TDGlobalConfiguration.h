//
//  TDGlobalConfiguration.h
//  ProjectToDos
//
//  Created by Stephan Chang on 2/11/14.
//  Copyright (c) 2014 The ToDo Party. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDGlobalConfiguration : NSObject

+ (UIColor *)fontColor;
+ (UIColor *)backgroundColor;
+ (UIColor *)controlBackgroundColor;
+ (UIColor *)buttonColor;
+ (NSString *)fontName;
+ (float)fontSizeBig;
+ (float)fontSize;
+ (float)fontSizeSmall;
+ (short)characterLimit;
+ (UIColor *)navigationBarCoor;
+ (CAGradientLayer *)gradientLayer;

@end
