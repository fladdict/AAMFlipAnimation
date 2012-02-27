//
//  AAMFlipLabel.h
//  AAMButtons
//
//  Created by 深津 貴之 on 12/02/26.
//  Copyright (c) 2012年 Art & Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol AAMFlipAnimationViewDelegate <NSObject>

-(void)flipAnimationDidComplete:(id)sender;

@end

@interface AAMFlipAnimationView : UIView
{
    //Layers for flip animation.
    CALayer *firstTopLayer;
    CALayer *firstBottomLayer;
    CALayer *secondTopLayer;
    CALayer *secondBottomLayer;
    
    //Layers for shadow and highlight.
    CALayer *highlightTopLayer;
    CALayer *highlightBottomLayer;
    CALayer *shadowTopLayer;
    CALayer *shadowBottomLayer;
    
    //Captured images for animation.
    UIImage *firstTopImage;
    UIImage *firstBottomImage;
    UIImage *secondTopImage;
    UIImage *secondBottomImage;
    
    int isFirstHalfAnimation;
}

@property (assign,nonatomic) id <AAMFlipAnimationViewDelegate> delegate;
@property (retain,nonatomic) UIColor *highlightColor;
@property (retain,nonatomic) UIColor *shadowColor;
@property (assign,nonatomic) NSTimeInterval duration;

@property (assign,nonatomic) BOOL hideAfterAnimation;   //hides this view after animation.
@property (assign,nonatomic) BOOL removeAfterAnimation; //removes this view after animation.

-(void)animate;
-(void)animateWithFirstImage:(UIImage*)theImage0 secondImage:(UIImage*)theImage;
-(void)animateWithNextImage:(UIImage*)theNextImage; //continue with using last secondImage
-(void)updateFirstImage:(UIImage*)theImage;
-(void)updateSecondImage:(UIImage*)theImage;

@end
