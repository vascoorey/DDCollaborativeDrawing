//
//  DDCollaborativeDrawingSession.h
//  DDCollaborativeDrawing
//
//  Created by Vasco d'Orey on 15/12/13.
//  Copyright (c) 2013 DeltaDog. All rights reserved.
//

@import Foundation;
@import MultipeerConnectivity;

@interface DDCollaborativeDrawingSession : NSObject

/**
 *  @return A new DDCollaborativeDrawingSession object with the given identifier
 */
+ (instancetype)sessionWithIdentifier:(NSString *)identifier;

/**
 *  Starts actively looking for peers
 */
- (void)start;

/**
 *  Stops all actions
 */
- (void)stop;

@end
