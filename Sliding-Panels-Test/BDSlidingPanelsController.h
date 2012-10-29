//
//  BDSlidingPanelsController.h
//  Sliding-Panels-Test
//
//  Created by David Sklenar on 10/18/12.
//  Copyright (c) 2012 David Sklenar. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BDSlidingPanelsControllerDelegate;

typedef enum
{
    BDSlideDirectionLeft,
    BDSlideDirectionRight
} BDSlideDirection;

typedef enum
{
    BDSlideBackgroundTypeNone,
    BDSlideBackgroundTypeWhite,
    BDSlideBackgroundTypeBlack
} BDSlideBackgroundType;

/*
 * Manages sliding panels (any custom view controllers) which appear as
 * connected siblings over the main UI. This class does not present any UI
 * elements of its own.
 */

@interface BDSlidingPanelsController : UIViewController

@property(strong, nonatomic) NSMutableArray *viewControllers;
@property(assign, nonatomic) BDSlideDirection direction;
@property(assign, nonatomic) BDSlideBackgroundType backgroundType;
@property(weak, nonatomic) id<BDSlidingPanelsControllerDelegate> delegate;

- (void)slideViewControllerOn:(UIViewController *)viewController animate:(BOOL)animate;
- (void)slideViewControllersOn:(NSArray *)viewControllers animate:(BOOL)animate;
- (void)insertViewController:(UIViewController *)viewController atIndex:(NSInteger)idx;
- (void)dismissAllPanesAnimated:(BOOL)animate;

@end

@protocol BDSlidingPanelsControllerDelegate <NSObject>
@optional

- (void)slidingPanelsController:(BDSlidingPanelsController *)controller didAddPanel:(UIViewController *)panelViewController;
- (void)slidingPanelsController:(BDSlidingPanelsController *)controller didRemovePanel:(UIViewController *)panelViewController;
- (void)slidingPanelsControllerDidClose:(BDSlidingPanelsController *)controller;

@end