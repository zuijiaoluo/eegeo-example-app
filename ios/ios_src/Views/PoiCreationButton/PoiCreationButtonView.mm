// Copyright eeGeo Ltd (2012-2014), All Rights Reserved

#include "PoiCreationButtonView.h"
#include "MathFunc.h"
#include "UIColors.h"
#include "ImageHelpers.h"

@implementation PoiCreationButtonView

- (id) initWithParams:(PoiCreationButtonViewController*)controller :(float)width :(float)height :(float)pixelScale
{
    if(self = [super init])
    {
        m_pController = controller;
        m_stateChangeAnimationTimeSeconds = 0.2f;
        m_pixelScale = 1.f;
        m_screenWidth = width/pixelScale;
        m_screenHeight = height/pixelScale;
        
        m_width = 64 * m_pixelScale;
        m_height = m_width;
        m_yPosBase = m_yPosActive = m_screenHeight - (16 * m_pixelScale) - m_height;;
        m_yPosActive = m_screenHeight - (16 * m_pixelScale) - m_height;
        m_yPosInactive = m_screenHeight + m_height;
        self.frame = CGRectMake(((m_screenWidth * 0.5f) - (m_width * 0.5f)), m_yPosActive, m_width, m_height);
        
        self.pPoiCreateButton = [[[UIButton alloc] initWithFrame: CGRectMake(0, 0, 0, 0)] autorelease];
        [self addSubview: self.pPoiCreateButton];
        
        [self.pPoiCreateButton setBackgroundImage:[UIImage imageNamed:@"button_create_poi.png"] forState:UIControlStateNormal];
        self.pPoiCreateButton.frame = CGRectMake(0.f, 0.f, m_width, m_height);
        [self.pPoiCreateButton addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return self;
}

- (void) onClick:(UIButton *)sender
{
    [m_pController setSelected:true];
}

- (void)dealloc
{
    [self.pPoiCreateButton removeFromSuperview];
    [self.pPoiCreateButton release];
    
    [super dealloc];
}

- (void)layoutSubviews
{
    
}

- (BOOL)consumesTouch:(UITouch *)touch
{
    CGPoint touchLocation = [touch locationInView:self];
    return CGRectContainsPoint(self.bounds, touchLocation);
}

- (void) setFullyOnScreen
{
    if(self.frame.origin.y == m_yPosActive)
    {
        return;
    }
    
    [self animateToY:m_yPosActive];
}

- (void) setFullyOffScreen
{
    if(self.frame.origin.y == m_yPosInactive)
    {
        return;
    }
    
    [self animateToY:m_yPosInactive];
}

- (void) setOnScreenStateToIntermediateValue:(float)onScreenState
{
    float newY = m_yPosInactive + (m_yPosActive - m_yPosInactive) * onScreenState;
    
    self.hidden = false;
    CGRect f = self.frame;
    f.origin.y = newY;
    self.frame = f;
}

- (void) animateToY:(float)y
{
    CGRect f = self.frame;
    f.origin.y = y;
    
    if(y != m_yPosInactive)
    {
        self.hidden = false;
    }
    
    [UIView animateWithDuration:m_stateChangeAnimationTimeSeconds
                     animations:^{
                         self.frame = f;
                     }
                     completion:^(BOOL finished){
                         self.hidden = (y == m_yPosInactive);
                     }
     ];
}

- (void) shouldOffsetButton:(bool)shouldOffset
{
    float offset = shouldOffset ? 36.f : 0;
    m_yPosActive = m_yPosBase - offset;
}

@end

