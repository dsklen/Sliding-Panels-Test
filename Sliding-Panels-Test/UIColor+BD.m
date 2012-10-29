//
//  UIColor+BD.m
//  Sliding-Panels-Test
//
//  Created by David Sklenar on 10/26/12.
//  Copyright (c) 2012 David Sklenar. All rights reserved.
//

#import "UIColor+BD.h"

@implementation UIColor (BD)

+ (UIColor *)randomColor;
{
    return [UIColor colorWithRed:(random()%100)/100.0f green:(random()%100)/100.0f blue:(random()%100)/100.0f alpha:1.0f];
}

@end
