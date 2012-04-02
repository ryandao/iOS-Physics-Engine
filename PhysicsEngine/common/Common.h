//
//  Common.h
//  PS4
//
//  Created by Ryan Dao on 2/7/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Vector2D.h"

@interface Common : NSObject

+ (NSArray *)clipVector:(Vector2D *)end1 secondEnd:(Vector2D *)end2 clippingDirection:(Vector2D *)d
                  distanceWorldToClippingLine:(double)D;
  // EFFECTS: Clip and two ends of a vector against a clipping line. 
  //          It's not neccesary to pass the clipping line as parameter. Instead we can use
  //		      the clipping direction and the distance from the world origin to the clipping line.
  //          Return NO if both ends do not fall within the boundary of the clipping line.


+ (Vector2D *)projectPointOnLine:(Vector2D *)point withNormal:(Vector2D *)n 
             distanceWorldToLine:(double)D;
  // EFFECTS: Return a projection of a point on a line that has a
  //          normal vector n and distance from world origin D.
  
@end
