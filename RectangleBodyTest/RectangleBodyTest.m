//
//  PS4Tests.m
//  PS4Tests
//
//  Created by Ryan Dao on 2/4/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import "RectangleBodyTest.h"

@implementation RectangleBodyTest

- (void)setUp
{
  [super setUp];
  
  // Set-up code here.
}

- (void)tearDown
{
  // Tear-down code here.
  
  [super tearDown];
}

- (void)testNormalVectorOfEdge {
  RectangleBody *rect = [[RectangleBody alloc] initDynamicBody:[Vector2D vectorWith:100 y:200] 
                                                         size:CGSizeMake(200, 100) rotation:1 mass:1];
  STAssertEqualObjects([rect normalVectorOfEdge:0], [Vector2D vectorWith:0.5403 y:0.84147], @"", @"");
  STAssertEqualObjects([rect normalVectorOfEdge:1], [Vector2D vectorWith:0.84147 y:-0.5403], @"", @"");
  STAssertEqualObjects([rect normalVectorOfEdge:2], [Vector2D vectorWith:-0.5403 y:-0.84147], @"", @"");
  STAssertEqualObjects([rect normalVectorOfEdge:3], [Vector2D vectorWith:-0.84147 y:0.5403], @"", @"");
}

- (void)testTransformCoordinate {
  Vector2D *point;
  RectangleBody *rect = [[RectangleBody alloc] initDynamicBody:[Vector2D vectorWith:100 y:200] 
                                                         size:CGSizeMake(200, 100) rotation:M_PI_2 mass:1];
  point = [rect transformPointCoordinate:[Vector2D vectorWith:200 y:100]];
  STAssertEqualObjects(point, [Vector2D vectorWith:-100.0 y:-100.0], @"", @"");
  
  rect = [[RectangleBody alloc] initDynamicBody:[Vector2D vectorWith:100 y:200] 
                                          size:CGSizeMake(200, 100) rotation:M_PI_4 mass:1];
  point = [rect transformPointCoordinate:[Vector2D vectorWith:200 y:100]];
  STAssertEqualObjects(point, [Vector2D vectorWith:0.0 y:-141.4213], @"", @"");
}

- (void)testEndPointsOfEdge {
  Vector2D *point1;
  Vector2D *point2;
  RectangleBody *rect = [[RectangleBody alloc] initDynamicBody:[Vector2D vectorWith:100 y:200] 
                                                         size:CGSizeMake(200, 100) rotation:M_PI_4 mass:1];
  NSArray *test1 = [rect endPointsOfEdge:0];
  point1 = [test1 objectAtIndex:0];
  NSLog(@"%.2f", point1.x);
  point2 = [test1 objectAtIndex:1];
  STAssertEqualObjects(point1, [Vector2D vectorWith:100.0 y:-50.0], @"", @"");
  STAssertEqualObjects(point2, [Vector2D vectorWith:100.0 y:50.0], @"", @"");
  
  NSArray *test2 = [rect endPointsOfEdge:1];
  point1 = [test2 objectAtIndex:0];
  point2 = [test2 objectAtIndex:1];
  STAssertEqualObjects(point1, [Vector2D vectorWith:-100 y:-50], @"", @"");
  STAssertEqualObjects(point2, [Vector2D vectorWith:100 y:-50], @"", @"");
  
  NSArray *test3 = [rect endPointsOfEdge:2];
  point1 = [test3 objectAtIndex:0];
  point2 = [test3 objectAtIndex:1];
  STAssertEqualObjects(point1, [Vector2D vectorWith:-100.0 y:50], @"", @"");
  STAssertEqualObjects(point2, [Vector2D vectorWith:-100 y:-50], @"", @"");
  
  NSArray *test4 = [rect endPointsOfEdge:3];
  point1 = [test4 objectAtIndex:0];
  point2 = [test4 objectAtIndex:1];
  STAssertEqualObjects(point1, [Vector2D vectorWith:100 y:50], @"", @"");
  STAssertEqualObjects(point2, [Vector2D vectorWith:-100 y:50], @"", @"");
}

- (void)testDistanceFromWorldToEdge {
  RectangleBody *rect = [[RectangleBody alloc] initDynamicBody:[Vector2D vectorWith:100 y:200] 
                                                         size:CGSizeMake(200, 100) rotation:0.1 mass:1];
  STAssertEqualsWithAccuracy([rect distanceFromWorldToEdge:0], 219.4671, 0.0001, @"", @"");
  STAssertEqualsWithAccuracy([rect distanceFromWorldToEdge:1], -139.0174, 0.0001, @"", @"");
  STAssertEqualsWithAccuracy([rect distanceFromWorldToEdge:2], -19.4671, 0.0001, @"", @"");
  STAssertEqualsWithAccuracy([rect distanceFromWorldToEdge:3], 239.0174, 0.0001, @"", @"");
  
  rect = [[RectangleBody alloc] initDynamicBody:[Vector2D vectorWith:100 y:200] 
                                          size:CGSizeMake(200, 100) rotation:-0.1 mass:1];
  STAssertEqualsWithAccuracy([rect distanceFromWorldToEdge:0], 179.5337, 0.0001, @"", @"");
  STAssertEqualsWithAccuracy([rect distanceFromWorldToEdge:1], -158.9841, 0.0001, @"", @"");
  STAssertEqualsWithAccuracy([rect distanceFromWorldToEdge:2], 20.4662, 0.0001, @"", @"");
  STAssertEqualsWithAccuracy([rect distanceFromWorldToEdge:3], 258.9841, 0.0001, @"", @"");
  
  rect = [[RectangleBody alloc] initDynamicBody:[Vector2D vectorWith:100 y:200] 
                                          size:CGSizeMake(200, 100) rotation:(M_PI_2 + 0.1) mass:1];
  STAssertEqualsWithAccuracy([rect distanceFromWorldToEdge:0], 289.0174, 0.0001, @"", @"");
  STAssertEqualsWithAccuracy([rect distanceFromWorldToEdge:1], 169.4670, 0.0001, @"", @"");
  STAssertEqualsWithAccuracy([rect distanceFromWorldToEdge:2], -89.0174, 0.0001, @"", @"");
  STAssertEqualsWithAccuracy([rect distanceFromWorldToEdge:3], -69.4670, 0.0001, @"", @"");
}
@end
