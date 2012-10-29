//
//  AppDelegate.m
//  Sliding-Panels-Test
//
//  Created by David Sklenar on 10/18/12.
//  Copyright (c) 2012 David Sklenar. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    CGFloat scale = 4.71f/5.82f;
    CGAffineTransform scaleTransform = CGAffineTransformMakeScale(scale, scale);
    self.window.transform = CGAffineTransformConcat(scaleTransform, self.window.transform);
    self.window.clipsToBounds = YES;
    
//    [self statusBarChanged:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(statusBarChanged:)
                                                 name:UIApplicationDidChangeStatusBarOrientationNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    return YES;
}



//- (void)statusBarChanged:(NSNotification *)note {
//    CGFloat scale = 4.71f/5.82f;
//    CGAffineTransform scaleTransform = CGAffineTransformMakeScale(scale, scale);
//    UIWindow *statusBarWindow = (UIWindow *)[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"];
//    statusBarWindow.transform = CGAffineTransformConcat(scaleTransform, statusBarWindow.transform);
//}
//
//- (void)keyboardWillShow:(NSNotification *)note {
//    [self performSelector:(@selector(doMagicToKeyboard)) withObject:nil afterDelay:0];
//}
//
//-(void)doMagicToKeyboard {
//    for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
//        [self checkForKeyboard:window];
//    }
//}
//
//- (void)checkForKeyboard:(UIView *)view {
//    static BOOL didIt = NO;
//    for (UIView *currentView in view.subviews) {
//        if(([[currentView description] hasPrefix:@"<UIKeyboard"] == YES) && !didIt)
//        {
//            didIt = YES;
//            UIView *thisView = currentView.superview.superview;
//            thisView.clipsToBounds = YES;
//            CGFloat scale = 4.71f/5.82f;
//            CGAffineTransform scaleTransform = CGAffineTransformMakeScale(scale, scale);
//            thisView.transform = CGAffineTransformConcat(scaleTransform, thisView.transform);
//        } else {
//            [self checkForKeyboard:currentView];
//        }
//    }
//}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
