//
//  RageIAPHelper.h
//  In App Rage
//
//  Created by Ray Wenderlich on 9/5/12.
//  Copyright (c) 2012 Razeware LLC. All rights reserved.
//

#import "IAPHelper.h"


static  NSString* const productIAP = @"com.emngok.app.DemoInApp.removeads";

@interface RageIAPHelper : IAPHelper


+ (RageIAPHelper *)sharedInstance;


@end
