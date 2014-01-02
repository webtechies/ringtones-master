//
//  FTCustomButton.m
//  CrossPromotionLib
//
//  Created by Duc Nguyen on 9/12/13.
//  Copyright (c) 2013 DPigpen. All rights reserved.
//

#import "FTCustomButton.h"

@implementation FTCustomButton

#pragma mark Settings

- (void) setBackgroundColor:(UIColor *) _backgroundColor forState:(UIControlState) _state {
    if (backgroundStates == nil)
        backgroundStates = [[NSMutableDictionary alloc] init];
    
    [backgroundStates setObject:_backgroundColor forKey:[NSNumber numberWithInt:_state]];
    
    if (self.backgroundColor == nil)
        [self setBackgroundColor:_backgroundColor];
}

- (UIColor*) backgroundColorForState:(UIControlState) _state {
    return [backgroundStates objectForKey:[NSNumber numberWithInt:_state]];
}

#pragma mark -
#pragma mark Touches

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[super touchesBegan:touches withEvent:event];
    
    UIColor *selectedColor = [backgroundStates objectForKey:[NSNumber numberWithInt:UIControlStateHighlighted]];
    if (selectedColor) {
        CATransition *animation = [CATransition animation];
        [animation setType:kCATransitionFade];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [self.layer addAnimation:animation forKey:@"EaseOut"];
        self.backgroundColor = selectedColor;
    }
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	[super touchesCancelled:touches withEvent:event];
    
    UIColor *normalColor = [backgroundStates objectForKey:[NSNumber numberWithInt:UIControlStateNormal]];
    if (normalColor) {
        CATransition *animation = [CATransition animation];
        [animation setType:kCATransitionFade];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [self.layer addAnimation:animation forKey:@"EaseOut"];
        self.backgroundColor = normalColor;
    }
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    
    UIColor *normalColor = [backgroundStates objectForKey:[NSNumber numberWithInt:UIControlStateNormal]];
    if (normalColor) {
        CATransition *animation = [CATransition animation];
        [animation setType:kCATransitionFade];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [self.layer addAnimation:animation forKey:@"EaseOut"];
        self.backgroundColor = normalColor;
    }
}

- (void) dealloc {
    [backgroundStates release];
    [super dealloc];
}

@end
