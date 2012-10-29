//
//  BDSlidingPanelsController.m
//  Sliding-Panels-Test
//
//  Created by David Sklenar on 10/18/12.
//  Copyright (c) 2012 David Sklenar. All rights reserved.
//

#import "BDSlidingPanelsController.h"
#import "UIColor+BD.h"
#import <QuartzCore/QuartzCore.h>

#define SLIDE_ANIMATION_SPEED 0.2
#define PANE_TAG_OFFSET 100

@interface BDSlidingPanelsController()

- (void)panGesture:(UIPanGestureRecognizer *)recognizer;
- (void)tapGesture:(UIPanGestureRecognizer *)recognizer;

- (void)addView:(NSNotification *)aNotification;
- (void)resetViewControllerTags;
- (void)resetViewControllerPositions;

- (void)setScaledBackgroundOpacity:(CGFloat)opacity;

@end

@implementation BDSlidingPanelsController


#pragma mark Properties

@synthesize viewControllers = _viewControllers;
@synthesize direction = _direction;
@synthesize backgroundType = _backgroundType;
@synthesize delegate = _delegate;


#pragma mark API

- (void)slideViewControllerOn:(UIViewController *)viewController animate:(BOOL)animate;
{
    NSParameterAssert( viewController != nil );
    
    [self slideViewControllersOn:[NSArray arrayWithObjects:viewController, nil] animate:YES];
}

- (void)slideViewControllersOn:(NSArray *)viewControllers animate:(BOOL)animate;
{
    NSParameterAssert( [viewControllers count] > 0 );
    
    // Determine the width of the new view(s).
    
    CGRect viewport = self.view.bounds;
    CGFloat width = 0.0f;
    
    for ( UIViewController *viewController in viewControllers )
        width += CGRectGetWidth( viewController.view.frame );
    
    viewport.size.width = width;
    
    // Position the new views behind the last panel (or offscreen) and add them
    // to our array
   
    UIView *lastPanel = [[self.viewControllers lastObject] view];
        
    __block CGRect lastPanelFrame;
    
    if ( self.direction == BDSlideDirectionLeft )
        lastPanelFrame = ( lastPanel != nil ) ? lastPanel.frame : CGRectZero;
    else
        lastPanelFrame = ( lastPanel != nil ) ? lastPanel.frame : CGRectMake( self.view.bounds.size.width / 2.0f, 0.0f, lastPanel.frame.size.width, lastPanel.frame.size.height );

    // Set-up view controller and views before animating.
    
    for ( UIViewController *viewController in viewControllers )
    {
        NSAssert( ![self.viewControllers containsObject:viewController], @"view controller is already on screen" );
        
        CGRect frame = viewController.view.frame;
        
        frame.origin.y = CGRectGetMinY( viewport );
        frame.size.height = CGRectGetHeight( viewport );
        
        if ( self.direction == BDSlideDirectionLeft )
            frame.origin.x = CGRectGetMaxX( lastPanelFrame ) - width;
        else
            frame.origin.x = self.view.bounds.size.width / 2.0f ;
        
        viewController.view.frame = frame;

        width -= CGRectGetWidth( frame );
                
        if ( lastPanel == nil )
        {
            [self.view addSubview:viewController.view];
            lastPanel = viewController.view;
        }
        else
            [self.view insertSubview:viewController.view atIndex:0];
        
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
        [viewController.view addGestureRecognizer:panGestureRecognizer];
        
        viewController.view.layer.shadowColor = [UIColor blackColor].CGColor;
        viewController.view.layer.shadowOffset = CGSizeMake( 2.0f, 0.0f );
        viewController.view.layer.shadowRadius = 2.0f;
        viewController.view.clipsToBounds = NO;
        viewController.view.layer.masksToBounds = NO;
        viewController.view.layer.shadowOpacity = 0.5f;
        viewController.view.layer.shouldRasterize = YES;
        viewController.view.layer.rasterizationScale = [[UIScreen mainScreen] scale];

        [self.viewControllers addObject:viewController];
    }    
    
    // Set view tags.
    
    [self resetViewControllerTags];
    
    // Animate the move to the final postion.
    
    NSTimeInterval duration = ( animate ) ? SLIDE_ANIMATION_SPEED : -1.0;
    
    [UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        for ( UIViewController *viewController in viewControllers )
        {
            CGRect frame = viewController.view.frame;
            
            if ( self.direction == BDSlideDirectionLeft )
            {
                frame.origin.x = CGRectGetMaxX( lastPanelFrame );
                viewController.view.frame = frame;
                lastPanelFrame = frame;
            }
            else
            {
                frame.origin.x -= viewController.view.frame.size.width;
                viewController.view.frame = frame;
            }
        }
        
        [self setScaledBackgroundOpacity:1.0f];
        
    } completion:^(BOOL finished) {
        
        if ( self.delegate != nil && [self.delegate respondsToSelector:@selector(slidingPanelsController:didAddPanel:)] )
            for ( UIViewController *viewController in viewControllers )
                [self.delegate slidingPanelsController:self didAddPanel:viewController];
    }];
}

- (void)insertViewController:(UIViewController *)viewController atIndex:(NSInteger)idx;
{    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    [viewController.view addGestureRecognizer:panGestureRecognizer];
    
    viewController.view.layer.shadowColor = [UIColor blackColor].CGColor;
    viewController.view.layer.shadowOffset = CGSizeMake( 2.0f, 0.0f );
    viewController.view.layer.shadowRadius = 2.0f;
    viewController.view.clipsToBounds = NO;
    viewController.view.layer.masksToBounds = NO;
    viewController.view.layer.shadowOpacity = 0.5f;
    viewController.view.layer.shouldRasterize = YES;
    viewController.view.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    
    UIView *superPane = [self.view viewWithTag:viewController.view.tag - 1];
    
    CGRect startingFrame = viewController.view.frame;
    
    if ( viewController.view.tag > 1)
        startingFrame = [superPane frame];
    else
        startingFrame.origin.x = -1.0f * startingFrame.size.width;
    
    viewController.view.frame = startingFrame;
    
    if (viewController.view.tag > 1 )
        [self.view insertSubview:viewController.view belowSubview:superPane];
    else
        [self.view addSubview:viewController.view];
    
    [self.viewControllers insertObject:viewController atIndex: (viewController.view.tag > 1 ) ? viewController.view.tag - 1 : 0];
    [self resetViewControllerPositions];
}

- (void)dismissAllPanesAnimated:(BOOL)animate;
{
    NSTimeInterval duration = ( animate ) ? SLIDE_ANIMATION_SPEED : -1.0;
    
    [UIView animateWithDuration:duration delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        NSArray *reverse = [[self.viewControllers reverseObjectEnumerator] allObjects];
        CGFloat width = 0.0f;
        
        for ( UIViewController *viewController in reverse )
        {
            viewController.view.layer.shouldRasterize = YES;
            viewController.view.layer.rasterizationScale = [[UIScreen mainScreen] scale];
            
            CGRect frame = viewController.view.frame;
            
            if ( self.direction == BDSlideDirectionLeft )
            {
                frame.origin.x = 0.0 - CGRectGetWidth( frame ) - width;
                width += CGRectGetWidth( frame );
            }
            else
                frame.origin.x += viewController.view.frame.size.width;
            
            viewController.view.frame = frame;
        }
        
        self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.0f];
        
    } completion:^(BOOL finished) {
        
        [self.view removeFromSuperview];
        
        if ( [self.delegate respondsToSelector:@selector(slidingPanelsControllerDidClose:)] )
            [self.delegate slidingPanelsControllerDidClose:self];
    }];
}


#pragma mark Private API - Gestures

- (void)panGesture:(UIPanGestureRecognizer *)recognizer;
{
    UIView *view = recognizer.view;
    CGRect frame = [view frame];

    CGPoint translation = [recognizer translationInView:[view superview]];
    CGPoint rootLocation = [recognizer locationInView:view];;
    
    CGFloat maxX = CGRectGetMaxX( [[[self.viewControllers lastObject] view] frame] );

    if ( self.direction == BDSlideDirectionLeft )
    {
        if ( recognizer.state == UIGestureRecognizerStateBegan )
        {
            // Reset translation point for start of pan gesture.
            
            [recognizer setTranslation:CGPointZero inView:[view superview]];
        }
        else if ( recognizer.state == UIGestureRecognizerStateChanged )
        {
            // Only slide the view controller pane if the net movement is to the left.
            
            if ( translation.x <= 0.0f )
            {
                if ( [self.viewControllers count] == 1 )
                {
                    if ( translation.x <= 0.0f )
                    {
                        frame.origin.x = translation.x;
                        [view setFrame:frame];
                    }
                }
                else
                {
                    CGFloat width = 0.0f;
                    
                    for ( int i = 0; i < [self.viewControllers count]; i++ )
                    {
                        UIViewController *viewController = [self.viewControllers objectAtIndex:i];
                        
                        CGRect newFrame = viewController.view.frame;
                        newFrame.origin.x = width + translation.x;
                        
                        width += CGRectGetWidth( newFrame );

                        if ( viewController.view.tag >= view.tag )
                            viewController.view.frame = newFrame;
                    }
                }
                
                view.layer.cornerRadius = fminf( 60.0f, fmaxf( 0.0f, -4.0f * ( view.frame.size.width / 2.0f + translation.x - 15.0f )) );
                
                [[view viewWithTag:1000] setAlpha:fminf( 1.0f, fmaxf( 0.0f, -0.05f * ( view.frame.size.width / 2.0f + translation.x - 5.0f )) )];
                
                // Change background opacity as user slides panels.
                
                CGFloat alpha = (maxX + translation.x) / maxX;
                [self setScaledBackgroundOpacity:alpha];
            }
        }
        else if ( recognizer.state == UIGestureRecognizerStateEnded )
        {                        
            NSLog(@"Translation: %f", translation.x);
            
            // Check whether to dismiss the translated view controller panel or
            // to reset the panes to their original positions.
            
            BOOL isSlidPastDismissDistance = ( translation.x * -1.0f ) > ( 0.5f * view.frame.size.width );
            BOOL isLastPaneAndShouldDismiss = frame.origin.x <= -1.0f* frame.size.width / 2.0f;
            
            if ( (isSlidPastDismissDistance && rootLocation.x <= maxX ) ||  isLastPaneAndShouldDismiss )
            {
                // Dismiss the view controller.
                
                // Resetting the view controllers will reposition the remaining view 
                // controllers properly once the view controller to dismiss is removed
                // from self.viewControllers.
                
                UIViewController *viewControllerToRemove = [self.viewControllers objectAtIndex:view.tag - 1];
               
                [self.viewControllers removeObject:viewControllerToRemove];
                                
                if ( [self.viewControllers count] > 0)
                    [self resetViewControllerPositions];
                
                // We still have to hide the view controller to dismiss.
                
                CGFloat animationDuration = ( [self.viewControllers count] == 0 ) ? SLIDE_ANIMATION_SPEED : 1.2 * SLIDE_ANIMATION_SPEED;
                CGFloat animationDelay = ( [self.viewControllers count] == 0 ) ? 0.0f : fabsf( translation.x / view.frame.size.width ) * 0.15f;

                [UIView animateWithDuration:animationDuration delay:animationDelay options:UIViewAnimationOptionCurveEaseIn animations:^{
                    
                    CGRect newFrame = view.frame;
                    newFrame.origin.x = 0.0f - view.frame.size.width;
                    view.frame = newFrame;

                } completion:^(BOOL finished) {
                    
                    // Notify the delegate that our view controller has been dismissed.
                    // The delegate is still responsible for deallocating the view controller
                    // instance.
                    
                    if ( self.delegate != nil && [self.delegate respondsToSelector:@selector(slidingPanelsController:didRemovePanel:)] )
                            [self.delegate slidingPanelsController:self didRemovePanel:viewControllerToRemove];
                    
                    [view removeFromSuperview];
                }];
            }
            else
                [self resetViewControllerPositions];
        }
    }
    else
    {
        // TODO: Handle sliding from the right.
    }
}

- (void)tapGesture:(UIPanGestureRecognizer *)recognizer;
{
    NSAssert( recognizer.view == self.view, @"unknown gesture recognizer" );
        
    UIView *view = recognizer.view;
    CGPoint location = [recognizer locationInView:view];;
    
    if ( self.direction == BDSlideDirectionLeft )
    {
        if ( recognizer.state == UIGestureRecognizerStateEnded )
        {
            CGFloat maxX = CGRectGetMaxX( [[[self.viewControllers lastObject] view] frame] );
            
            if ( location.x >= maxX )
                [self dismissAllPanesAnimated:YES];
        }
    }
}


#pragma mark Private API - Panes Management

- (void)addView:(NSNotification *)aNotification;
{
    UIViewController *viewController = [aNotification object];
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    [viewController.view addGestureRecognizer:panGestureRecognizer];
    
    viewController.view.layer.shadowColor = [UIColor blackColor].CGColor;
    viewController.view.layer.shadowOffset = CGSizeMake( 2.0f, 0.0f );
    viewController.view.layer.shadowRadius = 2.0f;
    viewController.view.clipsToBounds = NO;
    viewController.view.layer.masksToBounds = NO;
    viewController.view.layer.shadowOpacity = 0.5f;
    viewController.view.layer.shouldRasterize = YES;
    viewController.view.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    
    UIView *superPane = [self.view viewWithTag:viewController.view.tag - 1];
    
    CGRect startingFrame = viewController.view.frame;
    
    if ( viewController.view.tag > 1)
        startingFrame = [superPane frame];
    else
        startingFrame.origin.x = -1.0f * startingFrame.size.width;

    viewController.view.frame = startingFrame;

    if (viewController.view.tag > 1 )
        [self.view insertSubview:viewController.view belowSubview:superPane];
    else
        [self.view addSubview:viewController.view];

    [self.viewControllers insertObject:viewController atIndex: (viewController.view.tag > 1 ) ? viewController.view.tag - 1 : 0];
    [self resetViewControllerPositions];
}

- (void)resetViewControllerTags;
{
    for ( int i = 0; i < [self.viewControllers count]; i++ )
    {
        UIViewController *viewController = [self.viewControllers objectAtIndex:i];
        viewController.view.tag = i + 1;
    }
    
    for ( UIViewController *vc in self.viewControllers )
        NSLog(@"%i - %@", vc.view.tag, NSStringFromCGPoint(vc.view.frame.origin));
    
    NSLog(@"========");
}

- (void)resetViewControllerPositions;
{
    NSArray *viewControllers = self.viewControllers;
    
    NSParameterAssert( [viewControllers count] > 0 );
    
    // Reset view tags.
    
    [self resetViewControllerTags];
    
    // Animate the move to the final postion.
        
    [UIView animateWithDuration:SLIDE_ANIMATION_SPEED delay:0.0 options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        CGFloat width = 0.0f;
        
        for ( int i = 0; i < [self.viewControllers count]; i++ )
        {
            UIViewController *viewController = [self.viewControllers objectAtIndex:i];
            
            CGRect frame = viewController.view.frame;
            
            if ( self.direction == BDSlideDirectionLeft )
            {
                frame.origin.x = width;
                viewController.view.frame = frame;
                
                viewController.view.layer.cornerRadius = 0.0f;
                
                width += frame.size.width;
            }
        }
        
        [self setScaledBackgroundOpacity:1.0f];
        
    } completion:NULL];
}

- (void)setScaledBackgroundOpacity:(CGFloat)opacity;
{
    switch ( self.backgroundType )
    {
        case BDSlideBackgroundTypeNone:
            self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.0f * opacity];
            break;
        case BDSlideBackgroundTypeWhite:
            self.view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6f * opacity];
            break;
        case BDSlideBackgroundTypeBlack:
            self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4f * opacity];
            break;
        default:
            break;
    }
}


#pragma mark UIViewController

- (void)viewDidLoad;
{
    [super viewDidLoad];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    UIColor *backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.0f];
    [self.view setBackgroundColor:backgroundColor];
    
    [self.view setOpaque:NO];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addView:) name:@"AddView" object:nil];
}

- (void)viewDidUnload;
{
    // Note that this assumes if viewDidLoad is called again, the panels will
    // have to be added once again by the controller that manages this object.
    // If this isn't the desired behavior, we'll have to check to see if
    // self.viewControllers contains any objects in viewDidLoad and add them to
    // the view.
    
    [super viewDidUnload];
    [self.viewControllers removeAllObjects];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AddView" object:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;
{
    return YES;
}

#pragma mark UIResponder

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Dismiss the panels if the user tapped in the "outside" area.
    
    UITouch *touch = [touches anyObject];
    
    if ( [self.view hitTest:[touch locationInView:self.view] withEvent:event] == self.view )
    {
        [self dismissAllPanesAnimated:YES];
    }
}

#pragma mark NSObject

- (id)init;
{
    if ( ( self = [super init] ) )
    {
        _viewControllers = [[NSMutableArray alloc] init];
        _backgroundType = BDSlideBackgroundTypeWhite;
        _direction = BDSlideDirectionLeft;
    }
    
    return self;
}

@end