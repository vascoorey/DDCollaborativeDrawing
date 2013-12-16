//
//  DDCollaborativeMessage.h
//  DDCollaborativeDrawing
//
//  Created by Vasco d'Orey on 15/12/13.
//
//  Copyright 2013 Vasco d'Orey
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.'
//

#import <Foundation/Foundation.h>

@class DDParticipant;

typedef NS_ENUM(NSInteger, DDCollaborativeAction)
{
  DDCollaborativeActionNone = -1,
  DDCollaborativeActionDraw,
  /**
   *  Erase is not currently supported. Does nothing.
   */
  DDCollaborativeActionErase,
  /**
   *  Ban is not currently supported. Does nothing.
   */
  DDCollaborativeActionBan,
  /**
   *  Unban is not currently supported. Does nothing.
   */
  DDCollaborativeActionUnban,
  DDCollaborativeActionCount
};

typedef NS_ENUM(NSInteger, DDCollaborativeState)
{
  DDCollaborativeStateNone = -1,
  DDCollaborativeStateBegan,
  DDCollaborativeStateMoved,
  DDCollaborativeStateEnded,
  DDCollaborativeStateCancelled,
  DDCollaborativeStateCount
};

/**
 *  @param DDCollaborativeAction The action
 *
 *  @return An NSString representation of the action. nil if DDCollaborativeActionNone or other invalid action.
 */
DD_EXPORT_INLINE NSString *NSStringFromDDCollaborativeAction(DDCollaborativeAction);

/**
 *  @param The string
 *
 *  @return The DDCollaborativeAction type represented
 */
DD_EXPORT_INLINE DDCollaborativeAction DDCollaborativeActionFromNSString(NSString *);

/**
 *  @param DDCollaborativeState The state
 *
 *  @return An NSString representation of the state. nil if DDCollaborativeStateNone or other invalid state.
 */
DD_EXPORT_INLINE NSString *NSStringFromDDCollaborativeState(DDCollaborativeState);

/**
 *  @param  The string
 *
 *  @return The DDCollaborativeState type represented
 */
DD_EXPORT_INLINE DDCollaborativeState DDCollaborativeStateFromNSString(NSString *);

/**
 *  Represents a collaborative drawing message passed between devices
 */
@interface DDCollaborativeMessage : NSObject

/**
 *  @return A new DDCollaborativeDrawingMessage with the given action and state
 */
+ (instancetype)messageWithOwner:(DDParticipant *)owner action:(DDCollaborativeAction)action;

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
 *  The point (to draw). Sent with DDCollaborativeState[Began|Moved]
 */
@property (nonatomic, readonly) CGPoint point;

/**
 *  The path (to draw). Sent with DDCollaborativeStateEnded
 */
@property (nonatomic, readonly) UIBezierPath *path;

/**
 *  This message's ownwer
 */
@property (nonatomic, readonly) DDParticipant *owner;

/**
 *  @return A concise NSData representation of the current message.
 */
- (NSData *)data;

/**
 *  Sets the given point (only valid if action is DDCollaborativeActionDraw)
 *  The first time this is set the state is set to DDDrawingStateBegan, subsequent times will set it to DDDrawingStateMoved
 */
- (void)setDrawPoint:(CGPoint)point;

/**
 *  Sets the given drawing color. Will set state to DDDrawingStateEnded
 */
- (void)setDrawColor:(UIColor *)color;

/**
 *  Sets the given path (only valid if state is DDCollaborativeStateEnded and action is DDCollaborativeActionDraw)
 */
- (void)setDrawPath:(UIBezierPath *)path;

@end

@interface DDCollaborativeMessage (Deprecated)

- (id)init __deprecated_msg("Use the provided class contructors");

@end
