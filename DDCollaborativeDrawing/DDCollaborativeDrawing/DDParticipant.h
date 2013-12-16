//
//  DDParticipant.h
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

typedef NS_ENUM(unsigned short, DDParticipantType)
{
  DDParticipantTypeNone = 0,
  DDParticipantTypeGuest,
  DDParticipantTypeAdmin
};

/**
 *  @param DDParticipantType The participant type
 *
 *  @return A unique NSString representation of the participant.
 */
DD_EXPORT_INLINE NSString *NSStringFromDDParticipantType(DDParticipantType);

/**
 *  @return YES if the participant type is valid, NO otherwise (includes DDParticipantTypeNone)
 */
DD_EXPORT_INLINE BOOL IsValidParticipantType(DDParticipantType);

@interface DDParticipant : NSObject

/**
 *  Creates a new DDParticipant and sets it's peerID property (with the given identifier)
 *
 *  @param type The participant type
 *
 *  @param identifier The participant identifier
 *
 *  @return A new DDParticipant object with the given identifier. Returns nil if type is set to DDParticipantTypeNone
 */
+ (instancetype)participantWithIdentifier:(NSString *)identifier type:(DDParticipantType)type;

/**
 *  @return A new DDParticipant with the given peerID and type
 */
+ (instancetype)participantWithPeer:(MCPeerID *)peerID type:(DDParticipantType)type;

/**
 *  The MCPeerID owned by the participant
 */
@property (nonatomic, readonly) MCPeerID *peerID;

/**
 *  The participant type.
 */
@property (nonatomic, readonly) DDParticipantType type;

@end

@interface DDParticipant (Deprecated)

/**
 *  Use the class methods participantWithIdentifier:type: participantWithPeer:type:
 */
- (id)init __deprecated_msg("Use the class methods participantWithIdentifier:type: participantWithPeer:type:");

@end
