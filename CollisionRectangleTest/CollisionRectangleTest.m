//
//  CollisionRectangleTest.m
//  CollisionRectangleTest
//
//  Created by Ryan Dao on 2/9/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import "CollisionRectangleTest.h"

@implementation CollisionRectangleTest

- (void)setUp
{
  [super setUp];
    
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testNotColliding {
  testCollision_ = [[CollisionRectangle alloc] init];
  RectangleBody *rectA = [[RectangleBody alloc] initDynamicBody:[Vector2D vectorWith:100 y:200] 
                                                             size:CGSizeMake(300, 200) rotation:0 mass:1];
  RectangleBody *rectB = [[RectangleBody alloc] initDynamicBody:[Vector2D vectorWith:350 y:150] 
                                                             size:CGSizeMake(199, 100) rotation:0 mass:1];
  STAssertFalse([testCollision_ collideRectangle:rectA with:rectB], @"", @"");
  
  rectA = [[RectangleBody alloc] initDynamicBody:[Vector2D vectorWith:100 y:200] size:CGSizeMake(200, 100) 
                                           rotation:M_PI/3 - 0.01 mass:1];
  rectB = [[RectangleBody alloc] initDynamicBody:[Vector2D vectorWith:100 y:400] size:CGSizeMake(200, 100) 
                                           rotation:M_PI/3 - 0.01 mass:1];
  STAssertFalse([testCollision_ collideRectangle:rectA with:rectB], @"", @"");
  
  rectA = [[RectangleBody alloc] initDynamicBody:[Vector2D vectorWith:100 y:200] size:CGSizeMake(200, 100) 
                                           rotation:-0.01 mass:1];
  rectB = [[RectangleBody alloc] initDynamicBody:[Vector2D vectorWith:299 y:-0.01] size:CGSizeMake(200, 100) 
                                           rotation:M_PI/3 mass:1];
  STAssertFalse([testCollision_ collideRectangle:rectA with:rectB], @"", @"");
}

- (void)testCollision1 {
  testCollision_ = [[CollisionRectangle alloc] init];
  RectangleBody *rectA = [[RectangleBody alloc] initDynamicBody:[Vector2D vectorWith:400 y:924] 
                                                          size:CGSizeMake(300, 200) rotation:0 mass:1];
  RectangleBody *rectB = [[RectangleBody alloc] initDynamicBody:[Vector2D vectorWith:348 y:1024] 
                                                          size:CGSizeMake(696, 0) rotation:0 mass:1];
  STAssertTrue([testCollision_ collideRectangle:rectA with:rectB], @"", @"");
  RectangleCollisionData *data = [testCollision_.collisionDataList objectAtIndex:0];
  STAssertEqualObjects([data.contactPoints objectAtIndex:0], [Vector2D vectorWith:550 y:1024], @"", @"");
  STAssertEqualObjects([data.contactPoints objectAtIndex:1], [Vector2D vectorWith:250 y:1024], @"", @"");
  
  rectA.linearVelocity = [Vector2D vectorWith:0 y:130];
  rectA.angularVelocity = 0.0;
  [testCollision_ applyImpulses];
  NSLog(@"velocity: %.2f %.2f", rectA.linearVelocity.x, rectA.linearVelocity.y);
  //STAssertEqualObjects(rectA.linearVelocity, [Vector2D vectorWith:0 y:0], @"", @"");
}

- (void)testCollision2 {
  testCollision_ = [[CollisionRectangle alloc] init];
  RectangleBody *rectA = [[RectangleBody alloc] initDynamicBody:[Vector2D vectorWith:100 y:200] size:CGSizeMake(200, 100) 
                                        rotation:M_PI/3 + 0.01 mass:1];
  RectangleBody *rectB = [[RectangleBody alloc] initDynamicBody:[Vector2D vectorWith:100 y:400] size:CGSizeMake(200, 100) 
                                        rotation:M_PI/3 + 0.01 mass:1];
  STAssertTrue([testCollision_ collideRectangle:rectA with:rectB], @"", @"");
  RectangleCollisionData *data = [testCollision_.collisionDataList objectAtIndex:0];
  Vector2D *contactPoint1 = [data.contactPoints objectAtIndex:0];
  Vector2D *contactPoint2 = [data.contactPoints objectAtIndex:1];
  STAssertEqualObjects(contactPoint1, [Vector2D vectorWith:44.99 y:204.25], @"", @"");
  STAssertEqualObjects(contactPoint2, [Vector2D vectorWith:7.32 y:137.47], @"", @"");
}

@end
