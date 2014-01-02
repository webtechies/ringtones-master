//
//  DNAdViewDelegate.h
//  Demo
//
//  Created by Duc Nguyen on 9/14/13.
//  Copyright (c) 2013 DPigpen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DNAdBannerView;
@class DNAdsRequestError;

@protocol DNAdViewDelegate <NSObject>


@optional

#pragma mark Ad Request Lifecycle Notifications

-(void) adViewDidReceiveAd:(DNAdBannerView *) view;

-(void) adView:(DNAdBannerView *) view didFailToReceiveAdWithError:(DNAdsRequestError *) error;


#pragma marl Click-Time Lifecycle Notifications



@end