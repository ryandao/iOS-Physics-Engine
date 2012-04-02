//
//  Constants.h
//  PS4
//
//  Created by Ryan Dao on 2/9/12.
//  Copyright (c) 2012 National University of Singapore. All rights reserved.
//

#import <Foundation/Foundation.h>

#define TOLERANCE 0.00001      // Tolerance for floating point comparison
#define GRAVITY 9.81           // The earth gravity magnitude
#define FRAME_RATE 1.0 / 60.0  // The animation frame rate
#define TIME_STEP 1.0 / 20.0   // The standard time step used in simulation
#define IMPULSE_ITERATION 8    // The number of iterations of applying impulses to a contact point

// Define notations for the positions of corners and edges of a rectangle body.
// Note: The notations follow the coordinate system of the body itself. 
#define TOP_RIGHT_CORNER 0
#define BOTTOM_RIGHT_CORNER 1
#define BOTTOM_LEFT_CORNER 2
#define TOP_LEFT_CORNER 3
#define RIGHT_MOST_EDGE 0
#define BOTTOM_EDGE 1
#define LEFT_MOST_EDGE 2
#define TOP_EDGE 3

