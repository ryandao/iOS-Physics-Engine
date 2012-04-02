//
//  Collision.h
//  PS4
//
//  Created by Ryan Dao on 2/6/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RectangleBody.h"
#import "CollisionData.h"

@interface CollisionRectangle : NSObject
  // OVERVIEW: This class contains functions and methods for handling collision between rectangle objects
@property (strong, nonatomic) NSMutableArray *collisionDataList;

+ (Matrix2D *)transformationMatrixFrom:(RectangleBody *)rectA to:(RectangleBody *)rectB;
  // EFFEECTS: Return the transformation matrix from rect1's coordinate system
  //           to rect2's coordinate system

- (BOOL)collideRectangle:(RectangleBody *)rect1 with:(RectangleBody *)rect2;
  // EFFECTS: Check if two rectangle bodies are colliding and find contact points

- (void)applyImpulses;
  // EFFECTS: Apply impulses at all contact points

- (void)clear;
  // EFFECTS: Clear all collision data

@end
