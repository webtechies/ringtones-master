//
//  FTCustomButton.h
//  CrossPromotionLib
//
//  Created by Duc Nguyen on 9/12/13.
//  Copyright (c) 2013 DPigpen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>


@interface FTCustomButton : UIButton
{
@private
    NSMutableDictionary *backgroundStates;
@public
}

- (void) setBackgroundColor:(UIColor *) _backgroundColor forState:(UIControlState) _state;
- (UIColor*) backgroundColorForState:(UIControlState) _state;

@end
