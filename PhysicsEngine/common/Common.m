//
//  Common.m
//  PS4
//
//  Created by Ryan Dao on 2/7/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import "Common.h"

@implementation Common
  // OVERVIEW: This class defines methods and functions for math and physics computation

+ (NSArray *)clipVector:(Vector2D *)end1 secondEnd:(Vector2D *)end2 clippingDirection:(Vector2D *)d
                  distanceWorldToClippingLine:(double)D {
  // EFFECTS: Clip and two ends of a vector against a clipping line. 
  //          It's not neccesary to have the clipping line as a param. Instead we use
  //		      the clipping direction and the distance from the world origin to the clipping line.
  //          Return NO if both ends do not fall within the boundary of the clipping line.
  
  double dist1 = [end1 dot:d] - D;  // Distance from end1 to clipping line
  double dist2 = [end2 dot:d] - D;  // Distance from end2 to clipping line
  if (dist1 > 0 && dist2 > 0) {  // both ends do not fall within the boundary of the clipping line 
    return nil;  
  } else if (dist1 <= 0 && dist2 <= 0) {  // both ends fall within the boundary of the clipping line
    return [NSArray arrayWithObjects:end1, end2, nil];     
  } else {  // only one end falls within the boundary of the clipping line. Clip the other end.
    Vector2D *clipEnd1;
    if (dist1 > 0 && dist2 <= 0) {  
      clipEnd1 = end2;
    } else {
      clipEnd1 = end1;
    }
    Vector2D *clipEnd2 = [end1 add:[[end2 subtract:end1] multiply:(dist1 / (dist1 - dist2))]];
    return [NSArray arrayWithObjects:clipEnd1, clipEnd2, nil];
  }
}

+ (Vector2D *)projectPointOnLine:(Vector2D *)point withNormal:(Vector2D *)n 
             distanceWorldToLine:(double)D {
  // EFFECTS: Return a projection of a point on a line that has a
  //          normal vector n and distance from world origin D.
  
  double separation = [n dot:point] - D;
  return [point subtract:[n multiply:separation]];
}

@end
