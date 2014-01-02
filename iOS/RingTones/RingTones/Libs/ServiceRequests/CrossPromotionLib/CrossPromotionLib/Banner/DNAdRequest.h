//
//  DNAdRequest.h
//  Demo
//
//  Created by Duc Nguyen on 9/14/13.
//  Copyright (c) 2013 DPigpen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import "DNAdSize.h"

@class DNAdsRequestError;


typedef void (^RequestBannerCompletionHandler) (BOOL  success, NSArray *listImages, DNAdsRequestError *error) ;

@interface DNAdRequest : NSObject


- (void) requestWithUnitId:(NSString *) adUnitId typeSize:(DNAdSize) sizeBanner completionHandler:(RequestBannerCompletionHandler) completionBlock;




@end
