//
//  OTSFPSLabel.m
//  OneStore
//
//  Created by Eason Qian on 15/11/22.
//  Copyright © 2015年 OneStore. All rights reserved.
//

#import "OTSFPSLabel.h"
#import "PureLayout.h"
#import <CoreFoundation/CoreFoundation.h>

@interface OTSWeakProxy : NSProxy

@property (nonatomic, weak) id target;
+ (instancetype)weakProxyForObject:(id)targetObject;

@end

@implementation OTSWeakProxy

#pragma mark Life Cycle
+ (instancetype)weakProxyForObject:(id)targetObject {
    OTSWeakProxy *weakProxy = [OTSWeakProxy alloc];
    weakProxy.target = targetObject;
    return weakProxy;
}


#pragma mark Forwarding Messages

- (id)forwardingTargetForSelector:(SEL)selector {
    return _target;
}


#pragma mark - NSWeakProxy Method Overrides, Handling Unimplemented Methods

- (void)forwardInvocation:(NSInvocation *)invocation {
    void *nullPointer = NULL;
    [invocation setReturnValue:&nullPointer];
}


- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector {
    return [NSObject instanceMethodSignatureForSelector:@selector(init)];
}


@end

#define kSize CGSizeMake(55, 20)

@implementation OTSFPSLabel

DEF_SINGLETON(OTSFPSLabel);

CADisplayLink *_link;
NSUInteger _count;
NSTimeInterval _lastTime;
UIFont *_font;
NSTimeInterval _llll;


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    self.layer.cornerRadius = 5;
    self.clipsToBounds = YES;
    self.textAlignment = NSTextAlignmentCenter;
    self.userInteractionEnabled = NO;
    self.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.700];
    
    _font = [UIFont fontWithName:@"Menlo" size:14];
    
    _link = [CADisplayLink displayLinkWithTarget:[OTSWeakProxy weakProxyForObject:self] selector:@selector(tick:)];
    [_link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    return self;
}


- (void)showBuoyCartWithView:(UIView *)aView
{
    [self removeFromSuperview];
    [aView addSubview:self];
    
    UIView *view = self;
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [view autoSetDimensionsToSize:kSize];
    [view autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:aView withOffset:2];
    [view autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:aView withOffset:-85];
}

- (void)dealloc {
    [_link invalidate];
}

- (CGSize)sizeThatFits:(CGSize)size {
    return kSize;
}

- (void)tick:(CADisplayLink *)link {
    if (_lastTime == 0) {
        _lastTime = link.timestamp;
        return;
    }
    
    _count++;
    NSTimeInterval delta = link.timestamp - _lastTime;
    if (delta < 1) return;
    _lastTime = link.timestamp;
    float fps = _count / delta;
    _count = 0;
    
    CGFloat progress = fps / 60.0;
    UIColor *color = [UIColor colorWithHue:0.27 * (progress - 0.2) saturation:1 brightness:0.9 alpha:1];
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%dfps",(int)round(fps)]];
   [text setAttributes:@{NSFontAttributeName:_font,NSForegroundColorAttributeName:color} range:NSMakeRange(0, text.length - 3)];
    [text setAttributes:@{NSFontAttributeName:_font,NSForegroundColorAttributeName:[UIColor whiteColor]} range:NSMakeRange(text.length - 3, 3)];
    
    self.attributedText = text;
}

@end
