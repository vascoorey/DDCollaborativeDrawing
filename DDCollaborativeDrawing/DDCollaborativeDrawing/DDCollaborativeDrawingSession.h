//
//  DDCollaborativeDrawingSession.h
//  DDCollaborativeDrawing
//
//  Created by Vasco d'Orey on 15/12/13.
//
//  Copyright 2013 Vasco d'Orey
//  Licensed under the Apache License, Version 2.0 (the "License");\
//  you may not use this file except in compliance with the License.\
//  You may obtain a copy of the License at\
//
//  http://www.apache.org/licenses/LICENSE-2.0\
//
//  Unless required by applicable law or agreed to in writing, software\
//  distributed under the License is distributed on an "AS IS" BASIS,\
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.\
//  See the License for the specific language governing permissions and\
//  limitations under the License.'
//

@import Foundation;
@import MultipeerConnectivity;

@interface DDCollaborativeDrawingSession : NSObject

/**
 *  @return A new DDCollaborativeDrawingSession object with the given identifier
 */
+ (instancetype)sessionWithIdentifier:(NSString *)identifier;

/**
 *  Starts actively looking for peers
 */
- (void)start;

/**
 *  Stops all actions
 */
- (void)stop;

@end
