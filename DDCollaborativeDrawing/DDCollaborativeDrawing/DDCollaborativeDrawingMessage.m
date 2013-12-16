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

#import "DDCollaborativeDrawingMessage.h"

// All actions should be represented by two character strings
NSString *NSStringFromDDCollaborativeAction(DDCollaborativeAction action)
{
  switch (action) {
    case DDCollaborativeActionDraw:
      return @"dr";
      break;
    case DDCollaborativeActionErase:
      return @"er";
      break;
    case DDCollaborativeActionBan:
      return @"ba";
      break;
    case DDCollaborativeActionUnban:
      return @"un";
      break;
    default:
      return nil;
      break;
  }
}

// All states should be represented by single character strings
NSString *NSStringFromDDCollaborativeState(DDCollaborativeState state)
{
  switch (state) {
    case DDCollaborativeStateBegan:
      return @"b";
      break;
    case DDCollaborativeStateMoved:
      return @"m";
      break;
    case DDCollaborativeStateEnded:
      return @"e";
      break;
    case DDCollaborativeStateCancelled:
      return @"c";
      break;
    default:
      return nil;
      break;
  }
}

@implementation DDCollaborativeDrawingMessage

@end
