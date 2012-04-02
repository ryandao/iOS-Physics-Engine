//
//  RectangleShape.h
//  PS4
//
//  Created by Ryan Dao on 2/5/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Body.h"
#import "Vector2D.h"
#import "Matrix2D.h"

@interface RectangleBody : NSObject <Body> 
@property (nonatomic, readonly) CGSize size;             // The size (width and height) of the rectangle body
@property (nonatomic) CGFloat rotation;                  // The rotation angle of the rectangle body (in radian)
@property (strong, nonatomic) Matrix2D *rotationMatrix;  // The rotation matrix corresponding to the rotation angle
@property (strong, nonatomic) NSArray *corners;  
@property (strong, nonatomic) NSArray *edges; 

- (void)checkRep;
  // EFFECTS: Ensure that this body conforms to a set of specifications
  //          The specifications include:
  //	          size != ZeroSize
  //            mass != 0
  //            if(isStatic) -> linearVelocity = 0 && angularVelocity = 0
  
- (id)initWithCenter:(Vector2D *)center size:(CGSize)size rotation:(CGFloat)rotation mass:(CGFloat)mass 
         restitution:(CGFloat)restitution friction:(CGFloat)friction isStatic:(BOOL)isStatic;
  // EFFECTS: Return a fully initialized RectangleBody 

- (id)initDynamicBody:(Vector2D *)center size:(CGSize)size rotation:(CGFloat)rotation 
                                         mass:(CGFloat)mass ;
  // EFFECTS: Return a fully initialized dynamic RectangleBody with center, size, rotation angle and mass

- (id)initStaticBody:(Vector2D *)center size:(CGSize)size rotation:(CGFloat)rotation;
  // EFFECTS: Return a fully initialized static RectangleBody 

- (double)distanceFromWorldToEdge:(int)edgeIndex;
  // REQUIRES: edgeIndex < 4 && edgeIndex >= 0
  // EFFECTS: Return the distance from the world origin to a given edge of this rectangle body

- (Vector2D *)normalVectorOfEdge:(int)edgeIndex;
  // REQUIRES: edgeIndex < 4 && edgeIndex >= 0
  // EFFECTS: Return the unit normal vector of a given edge of this rectangle body

- (int)positiveAdjacentEdgeOf:(int)edgeIndex;
  // REQUIRES: edgeIndex < 4 && edgeIndex >= 0 
  // EFFECTS: Return the index of the positive edge adjacent to a given edge

- (int)negativeAdjacentEdgeOf:(int)edgeIndex;
  // REQUIRES: edgeIndex < 4 && edgeIndex >= 0 
  // EFFECTS: Return the index of the negative edge adjacent to a given edge

- (NSArray *)endPointsOfEdge:(int)edgeIndex;
  // REQUIRES: edgeIndex < 4 && edgeIndex >= 0 
  // EFFECTS: Return an array of the two end points of a given edge

- (Vector2D *)transformVectorCoordinate:(Vector2D *)vector; 
  // EFFECTS: Transform a vector in the world coordinate system to the body coordinate system

- (Vector2D *)invTransformVectorCoordinate:(Vector2D *)vector;
  // EFFECTS: Transform a vector in this body coordinate system to the world coordinate system

- (Vector2D *)transformPointCoordinate:(Vector2D *)worldPoint;
  // REQUIRES: A vector representation of a point in the world's coordinate system
  // EEFECTS: Transform a point in the world's coordinate system to the body's coordinate system

- (Vector2D *)invTransformPointCoordinate:(Vector2D *)point;
  // EEFECTS: Transform a point in the body coordinate system to the world coordinate system 
  
@end
