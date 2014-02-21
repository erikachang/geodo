//
//  TDGlobalConfiguration.m
//  ProjectToDos
//
//  Created by Stephan Chang on 2/11/14.
//  Copyright (c) 2014 The ToDo Party. All rights reserved.
//

#import "TDGlobalConfiguration.h"

@implementation TDGlobalConfiguration

+ (UIColor *)fontColor
{
    return [UIColor colorWithRed:231.0f/255.0f green:238.0f/255.0f blue:255.0f/255.0f alpha:1.0f];
}

+ (UIColor *)backgroundColor
{
//    return [UIColor colorWithRed:72.0f/255.0f green:154.0f/255.0f blue:204.0f/255.0f alpha:1.0f];
//    return [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    return [UIColor clearColor];
}

+ (UIColor *)controlBackgroundColor
{
//    return [UIColor colorWithRed:22.0f/255.0f green:48.0f/255.0f blue:64.0f/255.0f alpha:1.0f];
    return [UIColor clearColor];
}

+ (UIColor *)buttonColor
{
    return [UIColor colorWithRed:134.0f/255.0f green:254.0f/255.0f blue:231.0f/255.0f alpha:1.0f];
}

+ (NSString *)fontName
{
    return @"Palatino-Bold";
}

+ (float)fontSize
{
    return 15.0f;
}

+ (short)characterLimit
{
    return 40;
}

+ (CAGradientLayer *)gradientLayer
{
    CAGradientLayer *grad = [CAGradientLayer layer];
    grad.colors = @[(id)[[UIColor colorWithRed:.0f green:.6f blue:.8f alpha:1.0f] CGColor],
                    (id)[[UIColor colorWithRed:.0f green:.3f blue:.4f alpha:1.0f] CGColor]];
    grad.locations = @[[NSNumber numberWithFloat:.0], [NSNumber numberWithFloat:1.]];
    
    return grad;
}

@end
