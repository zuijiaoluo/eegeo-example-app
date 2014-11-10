// Copyright eeGeo Ltd (2012-2014), All Rights Reserved

#pragma once

#import <UIKit/UIKit.h>
#include "FlattenButtonViewController.h"

@class FlattenButtonView;

@interface FlattenButtonView : UIButton
{
    __weak FlattenButtonViewController* m_pController;
    UIColor* m_pColour;
    
    float m_width;
    float m_height;
    
    float m_screenWidth;
    float m_screenHeight;
    float m_pixelScale;
    
    float m_xPosActive;
    float m_xPosInactive;
    
    float m_stateChangeAnimationTimeSeconds;
}

- (id) setController:(FlattenButtonViewController *)controller;

- (id) initWithDimensions:(float)width :(float)height :(float)pixelScale;

- (BOOL) consumesTouch:(UITouch *)touch;

- (void) setFullyOnScreen;

- (void) setFullyOffScreen;

- (void) setOnScreenStateToIntermediateValue:(float)openState;

- (void) animateToX:(float)x;

@end