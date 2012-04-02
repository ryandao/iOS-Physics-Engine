//
//  ViewController.m
//  PS4
//
//  Created by Ryan Dao on 2/4/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import "ViewController.h"
#import "Constants.h"

@implementation ViewController
@synthesize blockViews = blockViews_;
@synthesize world = world_;
@synthesize blockMap = blockMap_;
@synthesize gravity = gravity_;

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (Vector2D *)gravity {
  switch([UIDevice currentDevice].orientation) {
    case UIDeviceOrientationPortrait:
      return [Vector2D vectorWith:0 y:GRAVITY];
      break;
    case UIDeviceOrientationPortraitUpsideDown:
      return [Vector2D vectorWith:0 y:-GRAVITY];
      break;
    case UIDeviceOrientationLandscapeLeft:
      return [Vector2D vectorWith:-GRAVITY y:0];
      break;
    case UIDeviceOrientationLandscapeRight:
      return [Vector2D vectorWith:GRAVITY y:0];
      break;
    default:
      return [Vector2D vectorWith:0 y:GRAVITY];
      break;
  }
  return [Vector2D vectorWith:0 y:GRAVITY];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  world_ = [[World alloc] initWithGravity:self.gravity]; 
  blockMap_ = [[NSMutableDictionary alloc] init];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationHandler:)
                                              name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)viewDidUnload {
  [self setBlockViews:nil];
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
}

- (void)simulateWorld {
  // Update the box views
  [UIView animateWithDuration:FRAME_RATE animations:^ {
    [world_ step:TIME_STEP];
    for (NSNumber *blockIndex in blockMap_) {
      UIView *block = [blockViews_ objectAtIndex:[blockIndex intValue]];
      RectangleBody *body = [world_.bodyList objectAtIndex:[[blockMap_ objectForKey:blockIndex] intValue]];
      /*NSLog(@"pre center: %.2f %.2f", block.center.x, block.center.y);
      NSLog(@"post center: %.2f %.2f", body.center.x, body.center.y);*/
      //NSLog(@"velocity: (%.2f, %.2f); angular velocity: %.2f", body.linearVelocity.x, body.linearVelocity.y, body.angularVelocity); */
      block.center = CGPointMake(body.center.x, body.center.y);
      block.transform = CGAffineTransformMakeRotation(body.rotation);
    }
  } completion:^(BOOL finished) {
    [self simulateWorld];
  }];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  // Create the static bodies, i.e. ground and walls
  CGRect screenRect = [[UIScreen mainScreen] bounds];
  [world_ createStaticBody:[Vector2D vectorWith:screenRect.size.width/2 y:screenRect.size.height] 
                      size:CGSizeMake(screenRect.size.width, 0) rotation:0];
  [world_ createStaticBody:[Vector2D vectorWith:screenRect.size.width/2 y:0] 
                      size:CGSizeMake(screenRect.size.width, 0) rotation:0]; 
  [world_ createStaticBody:[Vector2D vectorWith:0 y:screenRect.size.height/2] 
                     size:CGSizeMake(0, screenRect.size.height) rotation:0]; 
  [world_ createStaticBody:[Vector2D vectorWith:screenRect.size.width y:screenRect.size.height/2] 
                     size:CGSizeMake(0, screenRect.size.height) rotation:0]; 
  
  // Create the physical bodies from the box views
  for (int i = 0; i < [blockViews_ count]; i++) {
    UIView *block = [blockViews_ objectAtIndex:i];
    [world_ createDynamicBody:[Vector2D vectorWith:block.center.x y:block.center.y]
                                              size:block.frame.size rotation:0 mass:1];
    NSLog(@"%d", [world_.bodyList count]);
    [blockMap_ setObject:[NSNumber numberWithInteger:[world_.bodyList count] - 1] 
                  forKey:[NSNumber numberWithInteger:i]];
  }
  
  // Simulate the world
  [self simulateWorld];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return NO;
}

- (void)orientationHandler:(NSNotification *)notification {
  world_.gravity = self.gravity;
}

@end
