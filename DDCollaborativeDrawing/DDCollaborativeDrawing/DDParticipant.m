//
//  DDCollaborator.m
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

NSString *NSStringFromDDParticipantType(DDParticipantType type)
{
  switch (type) {
    case DDParticipantTypeAdmin:
      return @"DDParticipantTypeAdmin";
      break;
    case DDParticipantTypeGuest:
      return @"DDParticipantTypeGuest";
      break;
    default:
      return @"DDParticipantTypeNone";
      break;
  }
}

BOOL IsValidParticipantType(DDParticipantType type)
{
  return type > DDParticipantTypeNone && type <= DDParticipantTypeAdmin;
}

@interface DDParticipant ()

@property (nonatomic, strong, readwrite) MCPeerID *peerID;

@property (nonatomic, readwrite) DDParticipantType type;

- (id)initWithIdentifier:(NSString *)identifier type:(DDParticipantType)type;

- (id)initWithPeer:(MCPeerID *)peerID type:(DDParticipantType)type;

@end

@implementation DDParticipant (Deprecated)

- (id)init
{
  return [super init];
}

@end

@implementation DDParticipant

#pragma mark - Class

+ (instancetype)participantWithIdentifier:(NSString *)identifier type:(DDParticipantType)type
{
  return [[self alloc] initWithIdentifier:identifier type:type];
}


+ (instancetype)participantWithPeer:(MCPeerID *)peerID type:(DDParticipantType)type
{
  return [[self alloc] initWithPeer:peerID type:type];
}

#pragma mark - Lifecycle

- (id)initWithIdentifier:(NSString *)identifier type:(DDParticipantType)type
{
  if((self = [super init]))
  {
    if(identifier && IsValidParticipantType(type))
    {
      _peerID = [[MCPeerID alloc] initWithDisplayName:identifier];
      _type = type;
    }
    else
    {
      self = nil;
    }
  }
  return self;
}

- (id)initWithPeer:(MCPeerID *)peerID type:(DDParticipantType)type
{
  if((self = [super init]))
  {
    if(peerID && IsValidParticipantType(type))
    {
      _peerID = peerID;
      _type = type;
    }
    else
    {
      self = nil;
    }
  }
  return self;
}

@end
