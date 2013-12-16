//
//  DDCollaborativeDrawingMessage.m
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

#import "DDCollaborativeMessage.h"

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

// All actions should be represented by two character strings
NSString *NSStringFromDDCollaborativeAction(DDCollaborativeAction action)
{
  switch (action) {
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
  return DDCollaborativeActionNone;
}

static NSString *const Began      = @"b";
static NSString *const Moved      = @"m";
static NSString *const Ended      = @"e";
static NSString *const Cancelled  = @"c";

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
  return DDCollaborativeStateNone;
}

@interface DDCollaborativeMessage ()

@property (nonatomic, readwrite) DDCollaborativeAction action;

@property (nonatomic, readwrite) DDCollaborativeState state;

@property (nonatomic, strong, readwrite) DDParticipant *owner;

@property (nonatomic, readwrite) CGPoint point;

@property (nonatomic, readwrite, strong) UIColor *color;

@property (nonatomic, readwrite, strong) UIBezierPath *path;

@property (nonatomic) BOOL hasSetDrawPoint;

- (id)initWithOwner:(DDParticipant *)owner action:(DDCollaborativeAction)action;

- (id)initWithData:(NSData *)data;

@end

@implementation DDCollaborativeMessage

#pragma mark - Class

+ (instancetype)messageWithOwner:(DDParticipant *)owner action:(DDCollaborativeAction)action
{
  return [[self alloc] initWithOwner:owner action:action];
}

+ (instancetype)messageWithData:(NSData *)data
{
  return [[self alloc] initWithData:data];
}

#pragma mark - Lifecycle

- (id)initWithOwner:(DDParticipant *)owner action:(DDCollaborativeAction)action
{
  if((self = [super init]))
  {
    _owner = owner;
    _action = action;
    _state = DDCollaborativeStateBegan;
  }
  return self;
}

- (id)initWithData:(NSData *)data
{
  if((self = [super init]))
  {
    NSError *error = nil;
    NSDictionary *message = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    if(error)
    {
      _state = [message[StateKey] integerValue];
      _action = [message[StateKey] integerValue];
      
      if(_action == DDCollaborativeActionDraw)
      {
        if(_state == DDCollaborativeStateBegan || _state == DDCollaborativeStateMoved)
        {
          _point = CGPointMake([message[XKey] intValue], [message[YKey] intValue]);
        }
        else if(_state == DDCollaborativeStateEnded)
        {
          _path = [NSKeyedUnarchiver unarchiveObjectWithData:message[PathKey]];
          _color = [NSKeyedUnarchiver unarchiveObjectWithData:message[ColorKey]];
        }
      }
    }
  }
  return self;
}

#pragma mark - Instance

- (NSData *)data
{
  NSMutableDictionary *info = [NSMutableDictionary dictionary];
  info[StateKey] = @(self.state);
  info[ActionKey] = @(self.action);
  if(self.action == DDCollaborativeActionDraw)
  {
    if(self.state == DDCollaborativeStateBegan || self.state == DDCollaborativeStateMoved)
    {
      info[XKey] = @((short)self.point.x);
      info[YKey] = @((short)self.point.y);
    }
    else if(self.state == DDCollaborativeStateEnded)
    {
      info[PathKey] = [NSKeyedArchiver archivedDataWithRootObject:self.path];
      info[ColorKey] = [NSKeyedArchiver archivedDataWithRootObject:self.color];
    }
  }
  
  NSError *error = nil;
  NSData *data = [NSJSONSerialization dataWithJSONObject:info options:NSJSONWritingPrettyPrinted error:&error];
  if(error)
  {
    NSLog(@"%@", error.localizedDescription);
  }
  return data;
}

- (void)setDrawPoint:(CGPoint)point
{
  if(!self.hasSetDrawPoint)
  {
    self.hasSetDrawPoint = YES;
    self.state = DDCollaborativeStateMoved;
  }
  self.point = point;
}

- (void)setDrawColor:(UIColor *)color
{
  self.color = color;
}

- (void)setDrawPath:(UIBezierPath *)path
{
  self.state = DDCollaborativeStateEnded;
  self.path = path;
}

@end

@implementation DDCollaborativeMessage (Deprecated)

- (id)init
{
  return [super init];
}

@end
