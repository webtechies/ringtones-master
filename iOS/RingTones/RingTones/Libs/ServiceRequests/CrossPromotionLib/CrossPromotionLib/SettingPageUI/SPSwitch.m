//
//  SPSwitch.m
//  CrossPromotionLib
//
//  Created by Duc Nguyen on 9/14/13.
//  Copyright (c) 2013 DPigpen. All rights reserved.
//

#import "SPSwitch.h"

@implementation SPSwitch

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(void) dealloc
{
    [_indexPath release];
    [super dealloc];
}



@end
