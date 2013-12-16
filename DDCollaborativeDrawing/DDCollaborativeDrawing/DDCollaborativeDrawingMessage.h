//
//  DDCollaborativeDrawingMessage.h
//  DDCollaborativeDrawing
//
//  Created by Vasco d'Orey on 16/12/13.
//  Copyright (c) 2013 DeltaDog. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DDParticipant;

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

/**
 *  Represents a collaborative drawing message passed between devices
 */
@interface DDCollaborativeDrawingMessage : NSObject

/**
 *  @return A new DDCollaborativeDrawingMessage with the given action and state
 */
+ (instancetype)messageWithOwner:(DDParticipant *)owner action:(DDCollaborativeAction)action state:(DDCollaborativeState)state;

/**
 *  @return A new DDCollaborativeDrawingMessage from the given NSData
 */
+ (instancetype)messageWithData:(NSData *)data;

/**
 *  The action this message represents
 */
@property (nonatomic, readonly) DDCollaborativeAction action;

/**
 *  The state this message represents
 */
@property (nonatomic, readonly) DDCollaborativeState state;

/**
 *  @return A concise NSData representation of the current message.
 */
- (NSData *)data;

@end
