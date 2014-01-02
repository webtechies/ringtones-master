//
//  DNAdSize.h
//  Demo
//
//  Created by Duc Nguyen on 9/14/13.
//  Copyright (c) 2013 DPigpen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef struct DNAdSize {
    
    CGSize size;
    NSUInteger flags;
} DNAdSize;


#pragma mark Standard Sizes



// iPhone and iPod Touch ad size. Typically 320x45
extern DNAdSize const kDNAdSizeBanner;

// iPhone and iPod Touch ad size. Typically 768x75
extern DNAdSize const kDNAdSizeBanneriPad;

// iPhone full screen  ad size. Typically 320 x 480
extern DNAdSize const kDNAdSizeFullScreen;

//512 x 768
extern DNAdSize const kDNAdSizeFullScreeniPad;