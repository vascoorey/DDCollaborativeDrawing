//
//  DDParticipant.h
//  DDCollaborativeDrawing
//
//  Created by Vasco d'Orey on 16/12/13.
//  Copyright (c) 2013 DeltaDog. All rights reserved.
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
