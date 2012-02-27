//
//  ViewController.h
//  AAMFlipAnimation
//
//  Created by 深津 貴之 on 12/02/27.
//  Copyright (c) 2012年 Art & Mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AAMFlipAnimationView.h"

@interface ViewController : UIViewController <AAMFlipAnimationViewDelegate>
{
    AAMFlipAnimationView *flip0;
    AAMFlipAnimationView *flip1;
    AAMFlipAnimationView *flip2;
    AAMFlipAnimationView *flip3;
}

-(void)flipAnimationDidComplete:(id)sender;

@end
