//
//  TDGlobalConfiguration.h
//  ProjectToDos
//
//  Created by Stephan Chang on 2/11/14.
//  Copyright (c) 2014 The ToDo Party. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDGlobalConfiguration : NSObject

//@property (readonly) UIColor *fontColor, *backgroundColor, *controlBackgroundColor, *cellBackgroundColor;
//@property (readonly) NSString *fontName;
//@property (readonly) float fontSize;
//@property (readonly) short characterLimit;

+ (UIColor *)fontColor;
+ (UIColor *)backgroundColor;
+ (UIColor *)controlBackgroundColor;
+ (UIColor *)cellBackgroundColor;
+ (NSString *)fontName;
+ (float)fontSize;
+ (short)characterLimit;

@end
