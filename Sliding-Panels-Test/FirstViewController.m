//
//  FirstViewController.m
//  Sliding-Panels-Test
//
//  Created by David Sklenar on 10/18/12.
//  Copyright (c) 2012 David Sklenar. All rights reserved.
//

#import "FirstViewController.h"
#import "UIColor+BD.h"
#import <QuartzCore/QuartzCore.h>

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addViewBelow:(id)sender
{
    FirstViewController *newViewController = [[FirstViewController alloc] initWithNibName:@"FirstViewController" bundle:nil];
    newViewController.view.backgroundColor = [UIColor randomColor];
    newViewController.view.tag = self.view.tag + 1;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AddView" object:newViewController];
}


- (IBAction)addViewAbove:(id)sender;
{
    FirstViewController *newViewController = [[FirstViewController alloc] initWithNibName:@"FirstViewController" bundle:nil];
    newViewController.view.backgroundColor = [UIColor randomColor];
    newViewController.view.tag = self.view.tag - 1;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AddView" object:newViewController];
}

@end
