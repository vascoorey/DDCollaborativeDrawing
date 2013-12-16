//
//  CollaboratorSpec.m
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
