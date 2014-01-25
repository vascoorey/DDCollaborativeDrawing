//
//  DDMyScene.m
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

#import "DDCollaborativeDrawingScene.h"
#import "DDCollaborativeDrawingSession.h"

typedef NS_ENUM(NSInteger, DDCollaborativePathState)
{
  DDCollaborativePathStateNone = -1,
  DDCollaborativePathStateBegan,
  DDCollaborativePathStateMoved,
  DDCollaborativePathStateEnded,
  DDCollaborativePathStateCancelled
};

@interface DDCollaborativeDrawingScene () <DDCollaborativeDrawing>
@property (nonatomic, strong) SKNode *backgroundNode;
@property (nonatomic, strong) DDCollaborativeDrawingSession *session;
@property (nonatomic, strong) SKLabelNode *browseLabel;
@property (nonatomic, strong) NSMutableDictionary *receivedPaths;
@property (nonatomic, getter = isDrawing) BOOL drawing;
@property (nonatomic, strong) SKShapeNode *currentNode;
@property (nonatomic) CGMutablePathRef currentPath;
@property (nonatomic) DDCollaborativePathState currentPathState;
@end

@implementation DDCollaborativeDrawingScene

-(id)initWithSize:(CGSize)size
{
  if (self = [super initWithSize:size])
  {
    /* Setup your scene here */
    
    self.backgroundColor = [SKColor whiteColor];
    
    self.browseLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    
    self.browseLabel.text = @"Browse";
    self.browseLabel.fontSize = 30;
    self.browseLabel.fontColor = UIColor.blackColor;
    self.browseLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame) - 50);
    
    [self addChild:self.browseLabel];
    
    _receivedPaths = [NSMutableDictionary dictionary];
    
    _backgroundNode = [SKNode node];
    [self addChild:_backgroundNode];
    
    _session = [DDCollaborativeDrawingSession sessionWithIdentifier:@"dd-sample" delegate:self userInfo:nil];
    _session.movementResolution = DDCollaborativeMovementResolutionRealtime;
  }
  return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  CGPoint touchLocation = [touches.anyObject locationInNode:self];
  SKNode *touchedNode = [self nodeAtPoint:[touches.anyObject locationInNode:self]];
  if(!self.isDrawing && touchedNode == self.browseLabel)
  {
    [self browseLabelTapped];
  }
  else
  {
    self.drawing = YES;
    self.currentPath = CGPathCreateMutable();
    CGPathMoveToPoint(self.currentPath, NULL, touchLocation.x, touchLocation.y);
    CGPathAddLineToPoint(self.currentPath, NULL, touchLocation.x, touchLocation.y);
    self.currentPathState = DDCollaborativePathStateBegan;
    self.currentNode = SKShapeNode.node;
    self.currentNode.path = self.currentPath;
    self.currentNode.lineWidth = 2.f;
    self.currentNode.strokeColor = UIColor.blackColor;
    [self addChild:self.currentNode];
  }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
  if(!self.currentPath)
  {
    self.currentPath = CGPathCreateMutable();
    self.currentNode = SKShapeNode.node;
  }
  self.currentPathState = DDCollaborativePathStateMoved;
  CGPoint touchLocation = [touches.anyObject locationInNode:self];
  CGPathAddLineToPoint(self.currentPath, NULL, touchLocation.x, touchLocation.y);
  self.currentNode.path = self.currentPath;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
  CGPoint touchLocation = [touches.anyObject locationInNode:self];
  CGPathAddLineToPoint(self.currentPath, NULL, touchLocation.x, touchLocation.y);
  self.currentNode.path = self.currentPath;
  self.drawing = NO;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
  self.currentPath = NULL;
  [self.currentNode removeFromParent];
  self.currentNode = nil;
  self.drawing = NO;
}

-(void)update:(CFTimeInterval)currentTime
{
  /* Called before each frame is rendered */
}

- (void)browseLabelTapped
{
  if(!self.session.isBrowsing)
  {
    [self.session startBrowsingForPeers];
    self.browseLabel.text = @"Browsing";
  }
  else
  {
    [self.session stopBrowsingForPeers];
    self.browseLabel.text = @"Browse";
  }
}

#pragma mark - DDCollaborativeDrawing

- (void)drawingSession:(DDCollaborativeDrawingSession *)drawingSession didNotStartWithError:(NSError *)error
{
  
}

- (BOOL)drawingSession:(DDCollaborativeDrawingSession *)drawingSession shouldAcceptInviteFromPeer:(MCPeerID *)peer withContext:(NSData *)context
{
  return YES;
}

- (void)drawingSession:(DDCollaborativeDrawingSession *)drawingSession peer:(MCPeerID *)peer didBeginDrawingAtPoint:(CGPoint)point
{
  
}

- (void)drawingSession:(DDCollaborativeDrawingSession *)drawingSession peer:(MCPeerID *)peer didMoveDrawingToPoint:(CGPoint)point
{
  
}

- (void)drawingSession:(DDCollaborativeDrawingSession *)drawingSession peer:(MCPeerID *)peer didEndDrawingWithPath:(UIBezierPath *)path color:(UIColor *)color
{
  
}

@end
