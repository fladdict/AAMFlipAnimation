//
//  ViewController.m
//  AAMFlipAnimation
//
//  Created by 深津 貴之 on 12/02/27.
//  Copyright (c) 2012年 Art & Mobile. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

-(UIImage*)flipImageWithString:(NSString*)theString
{
    UIImage *img = [UIImage imageNamed:@"flip_0"];
    UILabel *l = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, img.size.width, img.size.height)];
    l.text = theString;
    l.textColor = [UIColor whiteColor];
    l.font = [UIFont boldSystemFontOfSize:72];
    l.textAlignment = UITextAlignmentCenter;
    
    UIGraphicsBeginImageContext(img.size);
    [img drawAtPoint:CGPointMake(0, 0)];
    [l drawTextInRect:CGRectMake(0, 0, img.size.width, img.size.height)];
    img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

#pragma mark - View 


-(void)doNextAnim:(AAMFlipAnimationView*)theView
{
    if(theView==flip0){
        [theView animateWithNextImage:[self flipImageWithString:[NSString stringWithFormat:@"%.3d",(int)rand()%500]]];
    }else{
        NSArray *ar = [NSArray arrayWithObjects:@"quadcamera",@"superalbum",@"superpopcam",@"tiltshift-generator",@"toycamera", nil];
        [theView animateWithNextImage:[UIImage imageNamed:[ar objectAtIndex:rand()%[ar count]]]];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /*
     Initialize flip view0
     */
    UIImageView *bg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"flip_background_0"]];
    bg.frame = CGRectMake(20, 20, 280, 112);
    [self.view addSubview:bg];
	flip0 = [[AAMFlipAnimationView alloc]initWithFrame:CGRectMake(25, 25, 270, 102)];
    flip0.duration = 1.f;
    flip0.delegate = self;
    flip0.hideAfterAnimation = NO;
    [self.view addSubview:flip0];
    [flip0 updateFirstImage:[self flipImageWithString:@"START"]];
    [self doNextAnim:flip0];
    
    /*
     Initialize flip view1
     */
    
    flip1 = [[AAMFlipAnimationView alloc]initWithFrame:CGRectMake(25, 152, 75, 75)];
    flip1.duration = 1;
    flip1.delegate = self;
    flip1.hideAfterAnimation = NO;
    [self.view addSubview:flip1];
    [flip1 updateFirstImage:[UIImage imageNamed:@"tiltshift-generator"]];
    [self doNextAnim:flip1];
    
    flip2 = [[AAMFlipAnimationView alloc]initWithFrame:CGRectMake(25, 252, 75, 75)];
    flip2.duration = 1;
    flip2.delegate = self;
    flip2.hideAfterAnimation = NO;
    [self.view addSubview:flip2];
    [flip2 updateFirstImage:[UIImage imageNamed:@"tiltshift-generator"]];
    [self performSelector:@selector(doNextAnim:) withObject:flip2 afterDelay:0.5f];
    
    flip3 = [[AAMFlipAnimationView alloc]initWithFrame:CGRectMake(25, 352, 75, 75)];
    flip3.duration = 1;
    flip3.delegate = self;
    flip3.hideAfterAnimation = NO;
    [self.view addSubview:flip3];
    [flip3 updateFirstImage:[UIImage imageNamed:@"tiltshift-generator"]];
    [self performSelector:@selector(doNextAnim:) withObject:flip3 afterDelay:1.0f];
}

#pragma mark - delegate

-(void)flipAnimationDidComplete:(id)sender
{
    [self performSelector:@selector(doNextAnim:) withObject:sender afterDelay:0.5f];
}

@end
