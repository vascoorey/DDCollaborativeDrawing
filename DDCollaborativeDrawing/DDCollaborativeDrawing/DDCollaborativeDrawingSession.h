//
//  DDCollaborativeDrawingSession.h
//  DDCollaborativeDrawing
//
//  Created by Vasco d'Orey on 15/12/13.
//  Copyright (c) 2013 DeltaDog. All rights reserved.
//

@import Foundation;
@import MultipeerConnectivity;

typedef NS_ENUM(unsigned short, DDCollaborativeAction)
{
  DDCollaborativeActionNone = 0,
  DDCollaborativeActionDraw,
  DDCollaborativeActionErase,
  DDCollaborativeActionBan,
  DDCollaborativeActionUnban
};

typedef NS_ENUM(unsigned short, DDCollaborativeState)
{
  DDCollaborativeStateNone = 0,
  DDCollaborativeStateBegan,
  DDCollaborativeStateMoved,
  DDCollaborativeStateEnded,
  DDCollaborativeStateCancelled
};

typedef NS_ENUM(unsigned short, DDCollaborator)
{
  DDCollaboratorNone = 0,
  DDCollaboratorGuest,
  DDCollaboratorAdmin
};

/**
 *  @param DDCollaborativeAction The action
 *
 *  @return A unique NSString representation of the action.
 */
DD_EXPORT NSString *NSStringFromDDCollaborativeAction(DDCollaborativeAction);

/**
 *  @param DDCollaborativeState The state
 *
 *  @return A unique NSString representation of the state.
 */
DD_EXPORT NSString *NSStringFromDDCollaborativeState(DDCollaborativeState);

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
