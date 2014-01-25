//
//  DDCollaborativeDrawingSession.h
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

@import Foundation;
@import MultipeerConnectivity;

typedef NS_ENUM(NSInteger, DDCollaborativeAction)
{
  DDCollaborativeActionInvalid = -1,
  DDCollaborativeActionNone,
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
  DDCollaborativeStateInvalid = -1,
  DDCollaborativeStateNone,
  DDCollaborativeStateBegan,
  DDCollaborativeStateMoved,
  DDCollaborativeStateEnded,
  DDCollaborativeStateCancelled,
  DDCollaborativeStateCount
};

typedef NS_ENUM(NSInteger, DDCollaborativeMovementResolution)
{
  /**
   *  Any movements will be accurately shown on all devices
   */
  DDCollaborativeMovementResolutionRealtime = 0,
  /**
   *  Data is sent every 5 points moved
   */
  DDCollaborativeMovementResolutionHigh = 5,
  /**
   *  Data is sent every 10 points moved
   */
  DDCollaborativeMovementResolutionMedium = 10,
  /**
   *  Data is sent every 20 points moved
   */
  DDCollaborativeMovementResolutionLow = 20
};

/**
 *  @return NSString representation of the given action
 */
DD_EXPORT_INLINE NSString *NSStringFromDDCollaborativeAction(DDCollaborativeAction);

/**
 *  @return action represented by the given string.
 */
DD_EXPORT_INLINE DDCollaborativeAction DDCollaborativeActionFromNSString(NSString *string);

/**
 *  @return NSString representation of the given state
 */
DD_EXPORT_INLINE NSString *NSStringFromDDCollaborativeState(DDCollaborativeState);

/**
 *  @return state represented by the given string.
 */
DD_EXPORT_INLINE DDCollaborativeState DDCollaborativeStateFromNSString(NSString *);

/**
 *  Given an action returns YES if the state is valid for that action
 */
DD_EXPORT_INLINE BOOL IsValidStateForAction(DDCollaborativeAction, DDCollaborativeState);

/**
 *  Given a current action, from state and to state will evaluate them and return YES if the transition is valid.
 */
DD_EXPORT_INLINE BOOL IsValidStateTransition(DDCollaborativeAction, DDCollaborativeState, DDCollaborativeState);

@class DDCollaborativeDrawingSession;

@protocol DDCollaborativeDrawing <NSObject>

@required

/**
 *  Informs the delegate that the drawing session failed to start.
 */
- (void)drawingSession:(DDCollaborativeDrawingSession *)drawingSession didNotStartWithError:(NSError *)error;

/**
 *  Asks the delegate if an invite should be accepted
 *
 *  @param drawingSession The drawing session object
 *  @param peer           The inviting peer
 *  @param context        The context for the invite
 */
- (BOOL)drawingSession:(DDCollaborativeDrawingSession *)drawingSession shouldAcceptInviteFromPeer:(MCPeerID *)peer withContext:(NSData *)context;

/**
 *  Informs the delegate that the given peer initiated a draw event
 */
- (void)drawingSession:(DDCollaborativeDrawingSession *)drawingSession peer:(MCPeerID *)peer didBeginDrawingAtPoint:(CGPoint)point;

/**
 *  Informs the delegate that the given peer continued drawing
 */
- (void)drawingSession:(DDCollaborativeDrawingSession *)drawingSession peer:(MCPeerID *)peer didMoveDrawingToPoint:(CGPoint)point;

/**
 *  Informs the delegate that the given peer ended drawing
 */
- (void)drawingSession:(DDCollaborativeDrawingSession *)drawingSession peer:(MCPeerID *)peer didEndDrawingWithPath:(UIBezierPath *)path color:(UIColor *)color;

@end

@interface DDCollaborativeDrawingSession : NSObject

/**
 *  @param identifier A valid identifier (1-15 characters, only letters, numbers and hyphens)
 *
 *  @param userInfo Any aditional information you want to pass to browsers. Can be nil.
 *
 *  @return A new DDCollaborativeDrawingSession object with the given identifier or nil if the identifier is invalid or the delegate is nil.
 */
+ (instancetype)sessionWithIdentifier:(NSString *)identifier delegate:(id <DDCollaborativeDrawing>)delegate userInfo:(NSDictionary *)userInfo;

/**
 *  Set this property to change the frequency of updates.
 *  Will raise an NSInvalidArgumentException if the given resolution is invalid.
 */
@property (nonatomic) DDCollaborativeMovementResolution movementResolution;

/**
 *  Is the current instance browsing for peers?
 */
@property (nonatomic, readonly, getter = isBrowsing) BOOL browsing;

/**
 *  Is the current instance advertising ?
 */
@property (nonatomic, readonly, getter = isAdvertising) BOOL advertising;

/**
 *  Starts browsing.
 */
- (void)startBrowsingForPeers;

/**
 *  Stops browsing.
 */
- (void)stopBrowsingForPeers;

/**
 *  Starts advertising.
 */
- (void)startAdvertisingPeer;

/**
 *  Stops advertising.
 */
- (void)stopAdvertisingPeer;

/**
 *  Stops all actions
 */
- (void)stop;

/**
 *  Initiates a draw event at the given point
 */
- (NSData *)beginDrawingAtPoint:(CGPoint)point;

/**
 *  Sends a move event at the given point. Will raise an assertion error if a draw event wasn't previously started
 */
- (NSData *)moveDrawingToPoint:(CGPoint)point;

/**
 *  Sends a end event at the given point. Will raise an assertion error if a draw event wasn't previously started or moved
 */
- (NSData *)endDrawingAtPoint:(CGPoint)point color:(UIColor *)color;

/**
 *  Initiates an erase event at the given point
 */
- (NSData *)beginErasingAtPoint:(CGPoint)point;

/**
 *  Bans all the given participants from interacting with the group
 */
- (NSData *)banParticipants:(NSArray *)participants;

/**
 *  Unbans all the given participants from interacting the the group
 */
- (NSData *)unbanParticipants:(NSArray *)participants;

/**
 *  Treats the given data as if being received from the network (for ze testing)
 */
- (void)handleData:(NSData *)data;

@end
