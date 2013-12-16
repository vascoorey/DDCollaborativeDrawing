//
//  DDCollaborativeDrawingMessage.h
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
