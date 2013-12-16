//
//  MessageSpec.m
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

SpecBegin(DDCollaborativeDrawingMessage)

describe(@"DDCollaborativeAction type should be valid", ^{
  it(@"should have a unique string for every action", ^{
    for(NSUInteger initial = 1; initial < DDCollaborativeActionCount; initial ++)
    {
      NSString *initialAction = NSStringFromDDCollaborativeAction((DDCollaborativeAction)initial);
      for(NSUInteger compare = initial + 1; compare < DDCollaborativeActionCount; compare ++)
      {
        expect(initialAction).toNot.equal(NSStringFromDDCollaborativeAction((DDCollaborativeAction)compare));
      }
    }
  });
});

describe(@"DDCollaborativeState type should be valid", ^{
  it(@"should have a unique string for every action", ^{
    for(NSUInteger initial = 1; initial < DDCollaborativeStateCount; initial ++)
    {
      NSString *initialState = NSStringFromDDCollaborativeState((DDCollaborativeState)initial);
      for(NSUInteger compare = initial + 1; compare < DDCollaborativeStateCount; compare ++)
      {
        expect(initialState).toNot.equal(NSStringFromDDCollaborativeState((DDCollaborativeState)compare));
      }
    }
  });
});

describe(@"A message should encapsulate the whole API", ^{
  
});

SpecEnd
