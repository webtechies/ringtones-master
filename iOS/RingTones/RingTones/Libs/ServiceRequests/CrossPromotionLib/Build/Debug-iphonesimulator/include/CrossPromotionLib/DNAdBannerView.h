//
//  DNAdBannerView.h
//  Demo
//
//  Created by Duc Nguyen on 9/14/13.
//  Copyright (c) 2013 DPigpen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DNAdSize.h"
#import "DNAdsRequestError.h"
#import "DNAdViewDelegate.h"
#import "DNAdRequest.h"

@class DNAdSizeObject;

@interface DNAdBannerView : UIView


#pragma mark Initialization

-(id) initWithAdSize:(DNAdSize) size origin:(CGPoint) origin;


-(id) initWithAdSize:(DNAdSize) size;


#pragma mark Pre-Request

@property (nonatomic, copy) NSString *adUnitId;

@property (nonatomic, assign) UIViewController *rootViewController;

@property (nonatomic) DNAdSize adSize;

@property (nonatomic, assign) NSObject<DNAdViewDelegate> *delegate;

#pragma mark Making an Ad Request

-(void) loadRequest;



@end
