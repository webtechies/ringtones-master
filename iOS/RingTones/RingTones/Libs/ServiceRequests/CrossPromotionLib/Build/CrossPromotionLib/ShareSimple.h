//
//  ShareSimple.h
//  CrossPromotionLib
//
//  Created by Duc Nguyen on 9/8/13.
//  Copyright (c) 2013 DPigpen. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ShareSimple : NSObject


+ (ShareSimple *) simpleSharing;

+ (void) simpleSharingBecomeActive;

+ (void) simpleSharingTerminal;

+ (BOOL) simpleSharingOpenURL:(NSURL *)url
            sourceApplication:(NSString *)sourceApplication
                   annotation:(id)annotation;

@end
