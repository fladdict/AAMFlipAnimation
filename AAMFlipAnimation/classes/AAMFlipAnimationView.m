//
//  AAMFlipLabel.m
//  AAMButtons
//
//  Created by 深津 貴之 on 12/02/26.
//  Copyright (c) 2012年 Art & Mobile. All rights reserved.
//

#import "AAMFlipAnimationView.h"


@interface AAMFlipAnimationView(private)

- (void)setup;
- (void)animateFirstHalf;
- (void)animateLastHalf;
@end



@implementation AAMFlipAnimationView

@synthesize delegate;
@synthesize highlightColor, shadowColor;
@synthesize duration;
@synthesize hideAfterAnimation;
@synthesize removeAfterAnimation;

#pragma mark - initialize

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self){
        [self setup];
    }
    return self;
}

-(void)setup
{
    //value initialization
    duration = 2.f;
    isFirstHalfAnimation = YES;
    hideAfterAnimation = YES;
    removeAfterAnimation = NO;
    highlightColor = [UIColor colorWithWhite:1.0f alpha:0.5f];
    shadowColor = [UIColor colorWithWhite:0.0f alpha:0.75f];

    //creation
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue
                     forKey:kCATransactionDisableActions];
    
    secondTopLayer = [CALayer layer];
    secondTopLayer.rasterizationScale = [[UIScreen mainScreen] scale];
    secondBottomLayer = [CALayer layer];
    secondBottomLayer.rasterizationScale = [[UIScreen mainScreen] scale];
    firstTopLayer = [CALayer layer];
    firstTopLayer.rasterizationScale = [[UIScreen mainScreen] scale];
    firstBottomLayer = [CALayer layer];
    firstBottomLayer.rasterizationScale = [[UIScreen mainScreen] scale];
    [self.layer addSublayer:firstBottomLayer];
    [self.layer addSublayer:secondTopLayer];
    [self.layer addSublayer:firstTopLayer];
    [self.layer addSublayer:secondBottomLayer];
    
    //highlight shadow creation;
    highlightTopLayer = [CALayer layer];
    highlightBottomLayer = [CALayer layer];
    shadowTopLayer = [CALayer layer];
    shadowBottomLayer = [CALayer layer];
    [firstTopLayer addSublayer:shadowTopLayer];
    [firstBottomLayer addSublayer:shadowBottomLayer];
    [secondTopLayer addSublayer:highlightTopLayer];
    [secondBottomLayer addSublayer:highlightBottomLayer];

    secondBottomLayer.hidden = YES;
    
    [CATransaction commit];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect b = self.bounds;
    float w = b.size.width;
    float hh = b.size.height*0.5f;
    
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue
                     forKey:kCATransactionDisableActions];
    
    firstTopLayer.frame = CGRectMake(0, hh*0.5f, w, hh);
    firstTopLayer.anchorPoint = CGPointMake(0.5, 1.f);
    firstBottomLayer.frame = CGRectMake(0, hh*0.5, w, hh);
    firstBottomLayer.anchorPoint = CGPointMake(0.5, 0.f);
    secondTopLayer.frame = CGRectMake(0, hh*0.5, w, hh);
    secondTopLayer.anchorPoint = CGPointMake(0.5, 1.f);
    secondBottomLayer.frame = CGRectMake(0, hh*0.5, w, hh);
    secondBottomLayer.anchorPoint = CGPointMake(0.5, 0.f);
    
    CGRect r = CGRectMake(0, 0, w, hh);
    highlightTopLayer.frame = r;
    highlightBottomLayer.frame = r; 
    shadowTopLayer.frame = r;
    shadowBottomLayer.frame = r;
    [CATransaction commit];
}

#pragma mark - internal

-(CALayer*)maskLayerWithImage:(UIImage*)theImage
{
    CALayer *mask = [CALayer layer];
    mask.contents = (id)theImage.CGImage;
    mask.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height*0.5f);
    return mask;
}

- (CATransform3D)transformWithRotation:(float)theValue
{
    CATransform3D t = CATransform3DIdentity;
    t.m34 = 1.0 / -400;
    return CATransform3DRotate(t,  theValue * M_PI / 180.0f, 1.0f, 0.0f, 0.0f);
}

#pragma mark-

-(void)animateWithFirstImage:(UIImage*)theImage0 secondImage:(UIImage*)theImage1
{
    [self updateFirstImage:theImage0];
    [self updateSecondImage:theImage1];
    [self animate];
}

-(void)animateWithNextImage:(UIImage*)theNextImage
{
    
    if(secondTopImage){
        firstTopImage = secondTopImage;
        firstBottomImage =  secondBottomImage;
    }
    [self updateSecondImage:theNextImage];
    [self animate];
}

-(void)updateFirstImage:(UIImage*)theImage
{
    self.hidden = NO;
    float w = CGImageGetWidth(theImage.CGImage);
    float h = CGImageGetHeight(theImage.CGImage);
    CGContextRef ctx;
    CGSize s = CGSizeMake(w, h);
    
    //Draw first top
    UIGraphicsBeginImageContext(s);
    ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    CGContextScaleCTM(ctx, 1.f,2.0f);
    [theImage drawAtPoint:CGPointMake(0, 0)];
    firstTopImage = UIGraphicsGetImageFromCurrentImageContext();

    CGContextClearRect(ctx, CGRectMake(0, 0, s.width, s.height));
    [theImage drawAtPoint:CGPointMake(0, -h*0.5f)];
    firstBottomImage = UIGraphicsGetImageFromCurrentImageContext();
    CGContextRestoreGState(ctx);
    UIGraphicsEndImageContext();
}

-(void)updateSecondImage:(UIImage*)theImage
{
    self.hidden = NO;
    float w = CGImageGetWidth(theImage.CGImage);
    float h = CGImageGetHeight(theImage.CGImage);
    CGContextRef ctx;
    CGSize s = CGSizeMake(w, h);
    
    //Draw second top
    UIGraphicsBeginImageContext(s);
    ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    CGContextScaleCTM(ctx, 1.f,2.0f);
    [theImage drawAtPoint:CGPointMake(0, 0)];
    secondTopImage = UIGraphicsGetImageFromCurrentImageContext();
    CGContextClearRect(ctx, CGRectMake(0, 0, s.width, s.height));
    
    [theImage drawAtPoint:CGPointMake(0, -h*0.5f)];
    secondBottomImage = UIGraphicsGetImageFromCurrentImageContext();
    CGContextRestoreGState(ctx);
    UIGraphicsEndImageContext();
}

-(void)animateWithFirstView:(UIView*)theView0 lastView:(UIView*)theView1
{
    
}

-(void)animate
{
    [firstTopLayer removeAllAnimations];
    [firstBottomLayer removeAllAnimations];
    [secondTopLayer removeAllAnimations];
    [secondBottomLayer removeAllAnimations];
    
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue
                     forKey:kCATransactionDisableActions];
    
    firstTopLayer.transform = CATransform3DIdentity;
    firstBottomLayer.transform = CATransform3DIdentity;
    secondTopLayer.transform = CATransform3DIdentity;
    secondBottomLayer.transform = CATransform3DIdentity;

    //Set captured image to layer;
    secondTopLayer.contents = (id)(secondTopImage.CGImage);
    secondBottomLayer.contents = (id)(secondBottomImage.CGImage);
    firstTopLayer.contents = (id)(firstTopImage.CGImage);
    firstBottomLayer.contents = (id)(firstBottomImage.CGImage);
    
    //Setup Shadows
    shadowTopLayer.mask = [self maskLayerWithImage:firstTopImage];
    shadowTopLayer.backgroundColor = shadowColor.CGColor;
    shadowTopLayer.opacity = 0.0f;
    shadowBottomLayer.mask = [self maskLayerWithImage:firstBottomImage];
    shadowBottomLayer.backgroundColor = shadowColor.CGColor;
    shadowBottomLayer.opacity = 0.0f;
    //Setup Highlights
    highlightTopLayer.mask = [self maskLayerWithImage:secondTopImage];
    highlightTopLayer.backgroundColor = shadowColor.CGColor;
    highlightTopLayer.opacity = 0.0f;
    highlightBottomLayer.mask = [self maskLayerWithImage:secondBottomImage];
    highlightBottomLayer.backgroundColor = highlightColor.CGColor;
    highlightBottomLayer.opacity = 0.0f;
    [CATransaction commit];

    //この時点でFirstTopLayerが正しく表示されているべきなのだが正しくない。
    [self animateFirstHalf];
}


- (void)animateFirstHalf{
    //アニメーション前半。
    //上からパタリとお落ちてくる真ん中まで
    isFirstHalfAnimation = YES;
    self.hidden = NO;
    
    
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue
                     forKey:kCATransactionDisableActions];
        firstTopLayer.hidden = NO;
        firstBottomLayer.hidden = NO;
        secondTopLayer.hidden = NO;
        secondBottomLayer.hidden = YES;
        highlightTopLayer.opacity = 0.5f;
    [CATransaction commit];
    
    //フリップする画像のアニメ
    CATransform3D rotationAndPerspectiveTransform = [self transformWithRotation:-90];    
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.fromValue = [NSNumber valueWithCATransform3D:CATransform3DIdentity]; // 最終状態をセット
    animation.toValue = [NSNumber valueWithCATransform3D:rotationAndPerspectiveTransform]; // 最終状態をセット
    animation.duration = duration*0.5f;
    animation.delegate = self;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    firstTopLayer.transform = CATransform3DIdentity;
    [firstTopLayer addAnimation:animation forKey:@"flipAnim"];
    
    //上半分の影の変化のアニメ
    animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = [NSNumber numberWithFloat:0.0f];
    animation.toValue = [NSNumber numberWithFloat:1.0f];
    animation.duration = duration*0.5f;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    shadowTopLayer.opacity = 1.0f;
    [shadowTopLayer addAnimation:animation forKey:@"opacity"];
    
    //下半分の影の変化のアニメ
    animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = [NSNumber numberWithFloat:0.0f];
    animation.toValue = [NSNumber numberWithFloat:1.0f];
    animation.duration = duration*0.5f;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    shadowBottomLayer.opacity = 1.0f;
    [shadowBottomLayer addAnimation:animation forKey:@"opacity"];
}

- (void)animateLastHalf{
    //アニメーション後半。真ん中からしたまで。
    isFirstHalfAnimation = NO;
    
    firstTopLayer.hidden = YES;
    secondBottomLayer.hidden = NO;

    
    CATransform3D rotationAndPerspectiveTransform = [self transformWithRotation:90];    
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"transform"];    
    animation.fromValue = [NSNumber valueWithCATransform3D:rotationAndPerspectiveTransform]; // 最終状態をセット
    animation.toValue = [NSNumber valueWithCATransform3D:CATransform3DIdentity];
    animation.duration = duration*0.5f;
    animation.delegate = self;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    [secondBottomLayer addAnimation:animation forKey:@"flipAnim"];
    
    animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = [NSNumber numberWithFloat:0.5f];
    animation.toValue = [NSNumber numberWithFloat:0.0f];
    animation.duration = duration*0.5f;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    highlightTopLayer.opacity = 0.0f;
    [highlightTopLayer addAnimation:animation forKey:@"opacity"];
    
    animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = [NSNumber numberWithFloat:1.0f];
    animation.toValue = [NSNumber numberWithFloat:0.0f];
    animation.duration = duration*0.5f;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    highlightBottomLayer.opacity = 0.0f;
    [highlightBottomLayer addAnimation:animation forKey:@"opacity"];
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag {
    //前半なら後半を開始する
    if(isFirstHalfAnimation){      
        [self animateLastHalf];
    }else{
        if(hideAfterAnimation){
            self.hidden = YES;
        }
        
        //DispatchEvent
        if([self.delegate respondsToSelector:@selector(flipAnimationDidComplete:)]){
            [self.delegate flipAnimationDidComplete:self];
        }
        
        //Delete automatically?
        if(removeAfterAnimation){
            [self removeFromSuperview];
        }
    }
}

@end
