//
//  CollaboratorSpec.m
//  DDCollaborativeDrawing
//
//  Created by Vasco d'Orey on 16/12/13.
//  Copyright (c) 2013 DeltaDog. All rights reserved.
//

#import "DDParticipant.h"

SpecBegin(DDParticipant)

describe(@"A participant in a collaborative drawing session", ^{
  it(@"Should create participants correctly", ^{
    DDParticipant *me = [DDParticipant participantWithIdentifier:[UIDevice currentDevice].name type:DDParticipantTypeAdmin];
    expect(me.peerID.displayName).to.equal([UIDevice currentDevice].name);
    expect(@(me.type)).to.equal(@(DDParticipantTypeAdmin));
    //
    MCPeerID *peer = [[MCPeerID alloc] initWithDisplayName:@"hello"];
    me = [DDParticipant participantWithPeer:peer type:DDParticipantTypeGuest];
    expect(me.peerID).to.equal(peer);
    expect(@(me.type)).to.equal(@(DDParticipantTypeGuest));
  });
  
  it(@"Should handle invalid params correctly", ^{
    expect([DDParticipant participantWithIdentifier:nil type:100]).to.beNil();
    expect([DDParticipant participantWithIdentifier:@"1" type:100]).to.beNil();
    expect([DDParticipant participantWithPeer:[[MCPeerID alloc] initWithDisplayName:@"hello"] type:DDParticipantTypeNone]).to.beNil();
    expect([DDParticipant participantWithPeer:nil type:DDParticipantTypeGuest]).to.beNil();
  });
});

SpecEnd
