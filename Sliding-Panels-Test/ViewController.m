//
//  ViewController.m
//  Sliding-Panels-Test
//
//  Created by David Sklenar on 10/18/12.
//  Copyright (c) 2012 David Sklenar. All rights reserved.
//

#import "ViewController.h"
#import "BDSlidingPanelsController.h"
#import "FirstViewController.h"
#import "UIColor+BD.h"

@interface ViewController ()

@end

@implementation ViewController

- (IBAction)panel:(id)sender;
{
    // Close the sliding panels controller if it's open.
    
    if ( self.slidingPanelsController != nil )
    {
        [self.slidingPanelsController setDelegate:nil];
        [self.slidingPanelsController dismissAllPanesAnimated:YES];
    }
    
    self.slidingPanelsController = [[BDSlidingPanelsController alloc] init];
    self.slidingPanelsController.delegate = self;
    
    CGRect bounds = self.view.frame;
    bounds.size.width = bounds.size.width * 2;
    [self.slidingPanelsController.view setFrame:bounds];
    
    FirstViewController *first = [[FirstViewController alloc] initWithNibName:@"FirstViewController" bundle:nil];
    
    [self.view addSubview:self.slidingPanelsController.view];

    [self.slidingPanelsController slideViewControllerOn:first animate:YES];
}

- (IBAction)panels:(id)sender;
{        
    // Close the sliding panels controller if it's open.
    
    if ( self.slidingPanelsController != nil )
    {
        [self.slidingPanelsController setDelegate:nil];
        [self.slidingPanelsController dismissAllPanesAnimated:YES];
    }
    
    self.slidingPanelsController = [[BDSlidingPanelsController alloc] init];
    self.slidingPanelsController.delegate = self;
    
    CGRect bounds = self.view.frame;
    bounds.size.width = bounds.size.width * 3;
    [self.slidingPanelsController.view setFrame:bounds];
    
    FirstViewController *first = [[FirstViewController alloc] initWithNibName:@"FirstViewController" bundle:nil];
    first.view.backgroundColor = [UIColor randomColor];
    
    FirstViewController *second = [[FirstViewController alloc] initWithNibName:@"FirstViewController" bundle:nil];
    second.view.backgroundColor = [UIColor randomColor];

    FirstViewController *third = [[FirstViewController alloc] initWithNibName:@"FirstViewController" bundle:nil];
    third.view.backgroundColor = [UIColor randomColor];

    [self.view addSubview:self.slidingPanelsController.view];
    
    [self.slidingPanelsController slideViewControllersOn:[NSArray arrayWithObjects:first, second, third, nil] animate:YES];
}


#pragma mark - TVSlidingPanelsControllerDelegate

- (void)slidingPanelsControllerDidClose:(BDSlidingPanelsController *)controller;
{
    self.slidingPanelsController = nil;
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"linen_texture"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSUInteger)supportedInterfaceOrientations;
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

@end
