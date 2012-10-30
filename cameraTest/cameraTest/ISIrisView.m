//
//  ISIrisView.m
//  IrisViewDemo
//
//  Created by yoyokko on 11-2-27.
//  Copyright 2011 yoyokko@gmail.com. All rights reserved.
//

#import "ISIrisView.h"
#import "ISIrisElementLayer.h"
#define RELEASE_BLOCK \
if (completedBlock_) {\
[completedBlock_ release];\
completedBlock_ = nil;\
}

@interface ISIrisView()

- (CGPoint) originAtIndex:(int) i
               withRadius:(CGFloat) radius
          withCenterPoint:(CGPoint) center
                withAngle:(double) angle;

@property (nonatomic, retain) UIImageView *statisIrisView;

@end

#define Radio 0.841081377f
#define RadioA 0.133974586f

@implementation ISIrisView
@synthesize statisIrisView = statisIrisView_;

- (CGPoint) originAtIndex:(int) i
               withRadius:(CGFloat) radius
          withCenterPoint:(CGPoint) center
                withAngle:(double) angle
{
	CGPoint origin = CGPointMake(center.x, center.y - radius);
	origin.x = origin.x - sin(angle*i)*radius;
	origin.y = origin.y + radius - cos(angle*i)*radius;
	return origin;
}

- (id) initWithFrame:(CGRect) frame 
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        self.statisIrisView = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)] autorelease];
        
        if ([[UIScreen mainScreen] bounds].size.height > 480) {
            self.statisIrisView.image = [UIImage imageNamed:@"Default-568h"];

        }
        else {
            self.statisIrisView.image = [UIImage imageNamed:@"Default"];

        }
        
        CGFloat radius = 600;
        self.clipsToBounds = YES;
        int layerIndex = 0;
        for (int i = 1; i < 9; i ++) 
        {
            CGPoint origin = [self originAtIndex:i 
                                      withRadius:radius
                                 withCenterPoint:CGPointMake(frame.size.width/2.0, frame.size.height/2.0)
                                       withAngle:M_PI_4];
            ISIrisElementLayer *layer = [[ISIrisElementLayer alloc] init];
            layer.layerIndex = layerIndex++;
            layer.frame = CGRectMake(0, 0, Radio*radius, radius);
            layer.position = origin;
            layer.anchorPoint = CGPointMake(RadioA, 0);
            CATransform3D transform = CATransform3DIdentity;
            transform = CATransform3DRotate(transform, i*M_PI_4, 0.0, 0.0, -1.0);
            layer.transform = transform;
            transform = CATransform3DRotate(transform, M_PI/120, 0, 0, 1.0);
            layer.transform = transform;
            [layer setNeedsDisplay];
            [self.layer addSublayer:layer];
            [layer release];		
        }
        
        CGPoint origin = [self originAtIndex:1 
                                  withRadius:radius
                             withCenterPoint:CGPointMake(frame.size.width/2.0, frame.size.height/2.0)
                                   withAngle:M_PI_4];
        
        ISIrisElementLayer *topLayer = [[ISIrisElementLayer alloc] init];
        topLayer.layerIndex = layerIndex++;
        topLayer.frame = CGRectMake(0, 0, Radio*radius, radius);
        topLayer.position = origin;
        topLayer.anchorPoint = CGPointMake(RadioA, 0);
        CATransform3D transform = CATransform3DIdentity;
        transform = CATransform3DRotate(transform, M_PI_4, 0.0, 0.0, -1.0);
        topLayer.transform = transform;
        transform = CATransform3DRotate(transform, M_PI/120, 0, 0, 1.0);
        topLayer.transform = transform;
        [topLayer setNeedsDisplay];
        [self.layer addSublayer:topLayer];
        [topLayer release];
    }
    return self;
}

- (void) didMoveToSuperview
{
    [self.superview addSubview:self.statisIrisView];
}

- (void)dealloc 
{
    self.statisIrisView = nil;
    if (completedBlock_) {
        [completedBlock_ release];
        completedBlock_ = nil;
    }
    [super dealloc];
}

- (void) animationDidStart:(CAAnimation *) anim
{
    self.hidden = NO;
    self.statisIrisView.hidden = YES;
}

- (void) animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (flag && self.hidden == NO)
    {
        self.hidden = YES;
        // open
        if (currentAction_ == ISIrisViewOpen) 
        {
            if (completedBlock_) {
                completedBlock_(ISIrisViewOpen);
            }
        }
        // close
        else if (currentAction_ == ISIrisViewClose)
        {
            self.statisIrisView.hidden = NO;
            if (completedBlock_) {
                completedBlock_(ISIrisViewClose);
            }
            
        }
        // shutter
        else if (currentAction_ == ISIrisViewShutter)
        {
            if (completedBlock_) {
                completedBlock_(ISIrisViewShutter);
            }
            
        }
    }
}

- (void) openIris
{
    [self openIrisAnimationDuration:0.1];
}

- (void) closeIris
{
    [self closeIrisAnimationDuration:0.1];
}

- (void) shutterIris
{
    [self shutterIrisAnimationDuration:1.0];
}


- (void) openIrisWithCompleteBlock:(ISIrisAnimationBlock)aBlock andDuration:(CGFloat)duration {
    [self openIris];
    completedBlock_ = [aBlock copy];
    
   
}

- (void) closeIrisWithCompleteBlock:(ISIrisAnimationBlock)aBlock andDuration:(CGFloat)duration {
    [self closeIris];

    completedBlock_ = [aBlock copy];
    
    
}

- (void) shutterIrisWithCompleteBlock:(ISIrisAnimationBlock)aBlock andDuration:(CGFloat)duration {
    [self shutterIris];

    completedBlock_ = [aBlock copy];
    
    
}
- (void) openIrisAnimationDuration:(CGFloat)duration {
    RELEASE_BLOCK
    [self.layer.sublayers makeObjectsPerformSelector:@selector(resetTransform)];
    currentAction_ = ISIrisViewOpen;
    for (ISIrisElementLayer *oneLayer in self.layer.sublayers)
    {
		CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
		animation.duration = duration;
        animation.delegate = self;
        animation.fromValue = [NSValue valueWithCATransform3D:oneLayer.transform];
        CATransform3D transform = oneLayer.transform;
        transform = CATransform3DRotate(transform, M_PI/5.2, 0.0, 0.0, 1.0f);
        animation.toValue = [NSValue valueWithCATransform3D:transform];
		animation.removedOnCompletion = YES;
		animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        oneLayer.transform = transform;
		[oneLayer addAnimation:animation forKey:@"open"];
    }
}

- (void) closeIrisAnimationDuration:(CGFloat)duration {
    RELEASE_BLOCK
    [self.layer.sublayers makeObjectsPerformSelector:@selector(resetTransform)];
    currentAction_ = ISIrisViewClose;
    for (ISIrisElementLayer *oneLayer in self.layer.sublayers)
    {
        CATransform3D oldTransform = oneLayer.transform;
        CATransform3D newTransform = oneLayer.transform;
        newTransform = CATransform3DRotate(newTransform, M_PI/5.2, 0.0, 0.0, 1.0f);
        
		CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
		animation.duration = duration;
        animation.delegate = self;
        
        animation.fromValue = [NSValue valueWithCATransform3D:newTransform];
        animation.toValue = [NSValue valueWithCATransform3D:oldTransform];
		animation.removedOnCompletion = YES;
		animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
		[oneLayer addAnimation:animation forKey:@"close"];
    }
}

- (void) shutterIrisAnimationDuration:(CGFloat)duration {
    RELEASE_BLOCK
    [self.layer.sublayers makeObjectsPerformSelector:@selector(resetTransform)];
    currentAction_ = ISIrisViewShutter;
    for (ISIrisElementLayer *oneLayer in self.layer.sublayers)
    {
        CATransform3D firstTransform = CATransform3DRotate(oneLayer.transform, M_PI/5.2, 0, 0, 1.0);
        
        CATransform3D endTransform = CATransform3DRotate(oneLayer.transform, M_PI/5.2, 0.0, 0.0, 1.0f);
        
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
        animation.duration = duration;
        animation.delegate = self;
        animation.removedOnCompletion = YES;
        animation.fillMode = kCAFillModeForwards;
        animation.values = [NSArray arrayWithObjects:[NSValue valueWithCATransform3D:firstTransform],
                            [NSValue valueWithCATransform3D:oneLayer.transform],
                            [NSValue valueWithCATransform3D:oneLayer.transform],
                            [NSValue valueWithCATransform3D:endTransform], nil];
        animation.keyTimes = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0],
                              [NSNumber numberWithFloat:0.2],
                              [NSNumber numberWithFloat:0.8],
                              [NSNumber numberWithFloat:1.0], nil];
        animation.timingFunctions = [NSArray arrayWithObjects:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear], nil];
        
        oneLayer.transform = endTransform;
        [oneLayer addAnimation:animation forKey:@"shutter"];
    }

}
@end
