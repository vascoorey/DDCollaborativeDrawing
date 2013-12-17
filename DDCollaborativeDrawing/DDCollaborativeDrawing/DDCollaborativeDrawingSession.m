//
//  DDCollaborativeDrawingSession.m
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

#import "DDCollaborativeDrawingSession.h"

static NSString *const ActionKey = @"act";
static NSString *const StateKey = @"sta";
static NSString *const XKey = @"x";
static NSString *const YKey = @"y";
static NSString *const ColorKey = @"c";
static NSString *const PathKey = @"p";
static NSString *const Draw     = @"dr";
static NSString *const Erase    = @"er";
static NSString *const Ban      = @"ba";
static NSString *const Unban    = @"un";
static NSString *const NoAction = @"no";

// All actions should be represented by two character strings
NSString *NSStringFromDDCollaborativeAction(DDCollaborativeAction action)
{
  switch (action) {
    case DDCollaborativeActionNone:
      return NoAction;
      break;
    case DDCollaborativeActionDraw:
      return Draw;
      break;
    case DDCollaborativeActionErase:
      return Erase;
      break;
    case DDCollaborativeActionBan:
      return Ban;
      break;
    case DDCollaborativeActionUnban:
      return Unban;
      break;
    default:
      return nil;
      break;
  }
}

DDCollaborativeAction DDCollaborativeActionFromNSString(NSString *string)
{
  if([string isEqualToString:Draw])
  {
    return DDCollaborativeActionDraw;
  }
  else if([string isEqualToString:Erase])
  {
    return DDCollaborativeActionErase;
  }
  else if([string isEqualToString:Ban])
  {
    return DDCollaborativeActionBan;
  }
  else if([string isEqualToString:Unban])
  {
    return DDCollaborativeActionUnban;
  }
  else if([string isEqualToString:NoAction])
  {
    return DDCollaborativeActionNone;
  }
  return DDCollaborativeActionInvalid;
}

static NSString *const Began      = @"b";
static NSString *const Moved      = @"m";
static NSString *const Ended      = @"e";
static NSString *const Cancelled  = @"c";
static NSString *const NoState    = @"n";

// All states should be represented by single character strings
NSString *NSStringFromDDCollaborativeState(DDCollaborativeState state)
{
  switch (state) {
    case DDCollaborativeStateBegan:
      return Began;
      break;
    case DDCollaborativeStateMoved:
      return Moved;
      break;
    case DDCollaborativeStateEnded:
      return Ended;
      break;
    case DDCollaborativeStateCancelled:
      return Cancelled;
      break;
    case DDCollaborativeStateNone:
      return NoState;
      break;
    default:
      return nil;
      break;
  }
}

DDCollaborativeState DDCollaborativeStateFromNSString(NSString *string)
{
  if([string isEqualToString:Began])
  {
    return DDCollaborativeStateBegan;
  }
  else if([string isEqualToString:Moved])
  {
    return DDCollaborativeStateMoved;
  }
  else if([string isEqualToString:Ended])
  {
    return DDCollaborativeStateEnded;
  }
  else if([string isEqualToString:Cancelled])
  {
    return DDCollaborativeStateCancelled;
  }
  else if([string isEqualToString:NoState])
  {
    return DDCollaborativeStateNone;
  }
  return DDCollaborativeStateInvalid;
}

BOOL IsValidStateForAction(DDCollaborativeAction action, DDCollaborativeState state)
{
  switch (action) {
    case DDCollaborativeActionDraw:
    case DDCollaborativeActionErase:
      return state == DDCollaborativeStateMoved || state == DDCollaborativeStateEnded || state == DDCollaborativeStateBegan;
      break;
    default:
      return state == DDCollaborativeStateNone;
      break;
  }
}

BOOL IsValidStateTransition(DDCollaborativeAction action, DDCollaborativeState fromState, DDCollaborativeState toState)
{
  switch (action) {
    case DDCollaborativeActionDraw:
    case DDCollaborativeActionErase:
      if(fromState == DDCollaborativeStateBegan)
      {
        return toState == DDCollaborativeStateEnded || toState == DDCollaborativeStateMoved;
      }
      else if(fromState == DDCollaborativeStateMoved)
      {
        return toState == DDCollaborativeStateMoved || toState == DDCollaborativeStateEnded;
      }
      else
      {
        return NO;
      }
      break;
    default:
      return fromState == DDCollaborativeStateNone && fromState == toState;
      break;
  }
}

@interface DDCollaborativeDrawingSession () <MCNearbyServiceAdvertiserDelegate, MCNearbyServiceBrowserDelegate, MCSessionDelegate>
@property (nonatomic, weak) id <DDCollaborativeDrawing> delegate;
@property (nonatomic) DDCollaborativeAction currentAction;
@property (nonatomic) DDCollaborativeState currentState;
@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, copy) NSDictionary *userInfo;
@property (nonatomic, strong, readwrite) MCNearbyServiceBrowser *browser;
@property (nonatomic, getter = isBrowsing) BOOL browsing;
@property (nonatomic, strong, readwrite) MCNearbyServiceAdvertiser *advertiser;
@property (nonatomic, strong) MCSession *session;
@property (nonatomic, strong) MCPeerID *peer;
@property (nonatomic, strong, readwrite) NSMutableArray *peers;
@property (nonatomic, strong) NSMutableDictionary *peersInfo;
@property (nonatomic) CGMutablePathRef currentPath;
@property NSUInteger actionsSinceDataSent;
- (void)setup;
- (NSData *)sendParams:(NSDictionary *)params mode:(MCSessionSendDataMode)mode forceSend:(BOOL)forceSend;
- (void)handleData:(NSData *)data fromPeer:(MCPeerID *)peer;
@end

@implementation DDCollaborativeDrawingSession

#pragma mark - Class

+ (instancetype)sessionWithIdentifier:(NSString *)identifier delegate:(id <DDCollaborativeDrawing>)delegate userInfo:(NSDictionary *)userInfo
{
  NSParameterAssert(delegate);
  // Delegate and identifier can't be nil
  static NSString *IdentifierRegEx = @"[A-Za-z0-9-]+";
  NSPredicate *identifierTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", IdentifierRegEx];
  if(!delegate || identifier.length < 1 || identifier.length > 15 || ![identifierTest evaluateWithObject:identifier])
  {
    return nil;
  }
  DDCollaborativeDrawingSession *session = [[self alloc] init];
  session.identifier = identifier;
  session.delegate = delegate;
  session.userInfo = userInfo;
  [session setup];
  return session;
}

#pragma mark - Properties

- (NSMutableDictionary *)peersInfo
{
  if(!_peersInfo)
  {
    _peersInfo = [NSMutableDictionary dictionary];
  }
  return _peersInfo;
}

- (void)setDelegate:(id <DDCollaborativeDrawing>)delegate
{
  if([delegate conformsToProtocol:@protocol(DDCollaborativeDrawing)])
  {
    _delegate = delegate;
  }
  else
  {
    [[NSException exceptionWithName:NSInvalidArgumentException reason:@"Delegate must not be nil and should conform to DDCollaborativeDrawing" userInfo:nil] raise];
  }
}

- (void)setMovementResolution:(DDCollaborativeMovementResolution)movementResolution
{
  switch (movementResolution) {
    case DDCollaborativeMovementResolutionHigh:
    case DDCollaborativeMovementResolutionLow:
    case DDCollaborativeMovementResolutionMedium:
    case DDCollaborativeMovementResolutionRealtime:
      _movementResolution = movementResolution;
      break;
    default:
      [[NSException exceptionWithName:NSInvalidArgumentException reason:@"movementResolution is not valid" userInfo:nil] raise];
      break;
  }
}

#pragma mark - Instance

- (void)setup
{
  self.peer = [[MCPeerID alloc] initWithDisplayName:[UIDevice currentDevice].name];
  
  self.session = [[MCSession alloc] initWithPeer:self.peer];
  self.session.delegate = self;
  
  self.browser = [[MCNearbyServiceBrowser alloc] initWithPeer:self.peer serviceType:self.identifier];
  self.browser.delegate = self;
  
  self.advertiser = [[MCNearbyServiceAdvertiser alloc] initWithPeer:self.peer discoveryInfo:self.userInfo serviceType:self.identifier];
  self.advertiser.delegate = self;
}

- (void)startBrowsingPeers
{
  [self.browser startBrowsingForPeers];
}

- (void)startAdvertisingPeer
{
  [self.advertiser startAdvertisingPeer];
}

- (void)stop
{
  [self.browser stopBrowsingForPeers];
  [self.advertiser stopAdvertisingPeer];
  [self.session disconnect];
}

- (NSData *)beginDrawingAtPoint:(CGPoint)point
{
  self.actionsSinceDataSent = 0;
  self.currentPath = CGPathCreateMutable();
  CGPathMoveToPoint(self.currentPath, NULL, point.x, point.y);
  self.currentAction = DDCollaborativeActionDraw;
  self.currentState = DDCollaborativeStateBegan;
  return [self sendParams:@{ ActionKey : @(self.currentAction), StateKey : @(self.currentState), XKey : @((short)point.x), YKey : @((short)point.y) } mode:MCSessionSendDataReliable forceSend:YES];
}

- (NSData *)moveDrawingToPoint:(CGPoint)point
{
  NSData *data = nil;
  CGPathMoveToPoint(self.currentPath, NULL, point.x, point.y);
  if(IsValidStateTransition(self.currentAction, self.currentState, DDCollaborativeStateMoved))
  {
    self.currentState = DDCollaborativeStateMoved;
    data = [self sendParams:@{ ActionKey : @(self.currentAction), StateKey : @(self.currentState), XKey : @((short)point.x), YKey : @((short)point.y) } mode:MCSessionSendDataUnreliable forceSend:NO];
  }
  return data;
}

- (NSData *)endDrawingAtPoint:(CGPoint)point color:(UIColor *)color
{
  NSData *data = nil;
  CGPathMoveToPoint(self.currentPath, NULL, point.x, point.y);
  UIBezierPath *bezierPath = [UIBezierPath bezierPathWithCGPath:self.currentPath];
  if(IsValidStateTransition(self.currentAction, self.currentState, DDCollaborativeStateEnded))
  {
    self.currentState = DDCollaborativeStateEnded;
    data = [self sendParams:@{ ActionKey : @(self.currentAction), StateKey : @(self.currentState), PathKey : [NSKeyedArchiver archivedDataWithRootObject:bezierPath], ColorKey : [NSKeyedArchiver archivedDataWithRootObject:color] } mode:MCSessionSendDataReliable forceSend:YES];
  }
  return data;
}

- (NSData *)beginErasingAtPoint:(CGPoint)point
{
  return nil;
}

- (NSData *)banParticipants:(NSArray *)participants
{
  return nil;
}

- (NSData *)unbanParticipants:(NSArray *)participants
{
  return nil;
}

- (void)handleData:(NSData *)data fromPeer:(MCPeerID *)peer
{
  NSLog(@"Received %d bytes", data.length);
  NSError *error = nil;
  NSDictionary *params = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
  if(error)
  {
    NSLog(@"%@", error.localizedDescription);
    return;
  }
  DDCollaborativeState state = [params[StateKey] integerValue];
  DDCollaborativeAction action = [params[ActionKey] integerValue];
  if(IsValidStateForAction(action, state))
  {
    switch (action) {
      case DDCollaborativeActionDraw:
      {
        switch (state) {
          case DDCollaborativeStateBegan:
            [self.delegate drawingSession:self peer:peer didBeginDrawingAtPoint:CGPointMake([params[XKey] intValue], [params[YKey] intValue])];
            break;
          case DDCollaborativeStateMoved:
            [self.delegate drawingSession:self peer:peer didMoveDrawingToPoint:CGPointMake([params[XKey] intValue], [params[YKey] intValue])];
            break;
          case DDCollaborativeStateEnded:
            [self.delegate drawingSession:self peer:peer didEndDrawingWithPath:[NSKeyedUnarchiver unarchiveObjectWithData:params[PathKey]] color:[NSKeyedUnarchiver unarchiveObjectWithData:params[ColorKey]]];
          default:
            break;
        }
      }
        break;
      default:
        break;
    }
  }
}

- (void)handleData:(NSData *)data
{
  [self handleData:data fromPeer:nil];
}

- (NSData *)sendParams:(NSDictionary *)params mode:(MCSessionSendDataMode)mode forceSend:(BOOL)force
{
  NSData *data = nil;
  if(force || self.actionsSinceDataSent >= self.movementResolution)
  {
    NSError *error = nil;
    data = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:&error];
    if(error)
    {
      NSLog(@"%@", error.localizedDescription);
    }
    else
    {
      NSLog(@"Sending %d bytes", data.length);
      [self.session sendData:data toPeers:self.peers withMode:mode error:&error];
      if(error)
      {
        NSLog(@"%@", error.localizedDescription);
      }
    }
    self.actionsSinceDataSent = 0;
  }
  else
  {
    self.actionsSinceDataSent ++;
  }
  return data;
}

#pragma mark - MCBrowser Delegate

-(void)browser:(__unused MCNearbyServiceBrowser *)browser didNotStartBrowsingForPeers:(NSError *)error
{
  [self stop];
  [self.delegate drawingSession:self didNotStartWithError:error];
}

-(void)browser:(__unused MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info
{
  // Store the peer's user info (if any)
  if(info)
  {
    self.peersInfo[peerID] = info;
  }
  [self.browser invitePeer:peerID toSession:self.session withContext:nil timeout:10.f];
}

-(void)browser:(__unused MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID
{
  [self.peersInfo removeObjectForKey:peerID];
}

#pragma mark - MCAdvertiser Delegater

-(void)advertiser:(__unused MCNearbyServiceAdvertiser *)advertiser didNotStartAdvertisingPeer:(NSError *)error
{
  [self stop];
  [self.delegate drawingSession:self didNotStartWithError:error];
}

-(void)advertiser:(__unused MCNearbyServiceAdvertiser *)advertiser didReceiveInvitationFromPeer:(MCPeerID *)peerID withContext:(NSData *)context invitationHandler:(void (^)(BOOL, MCSession *))invitationHandler
{
  [self.advertiser stopAdvertisingPeer];
  invitationHandler([self.delegate drawingSession:self shouldAcceptInviteFromPeer:peerID withContext:context], self.session);
}

#pragma mark - MCSession Delegate

-(void)session:(__unused MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID
{
  [self handleData:data fromPeer:peerID];
}

-(void)session:(__unused MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state
{
  if(state == MCSessionStateConnected)
  {
    NSLog(@"Connected to %@", peerID);
    [self.peers addObject:peerID];
  }
  else
  {
    NSLog(@"Lost connection to %@", peerID);
    [self.peers removeObject:peerID];
    [self.advertiser startAdvertisingPeer];
  }
}

-(void)session:(__unused MCSession *)session didStartReceivingResourceWithName:(__unused NSString *)resourceName fromPeer:(__unused MCPeerID *)peerID withProgress:(__unused NSProgress *)progress
{
  
}

-(void)session:(__unused MCSession *)session didFinishReceivingResourceWithName:(__unused NSString *)resourceName fromPeer:(__unused MCPeerID *)peerID atURL:(__unused NSURL *)localURL withError:(__unused NSError *)error
{
  
}

-(void)session:(__unused MCSession *)session didReceiveStream:(__unused NSInputStream *)stream withName:(__unused NSString *)streamName fromPeer:(__unused MCPeerID *)peerID
{
  
}

@end
