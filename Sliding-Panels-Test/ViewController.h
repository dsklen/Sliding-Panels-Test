//
//  ViewController.h
//  Sliding-Panels-Test
//
//  Created by David Sklenar on 10/18/12.
//  Copyright (c) 2012 David Sklenar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BDSlidingPanelsController.h"

@interface ViewController : UIViewController <BDSlidingPanelsControllerDelegate>

@property (strong, nonatomic) BDSlidingPanelsController *slidingPanelsController;

- (IBAction)panel:(id)sender;
- (IBAction)panels:(id)sender;

@end
