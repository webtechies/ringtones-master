//
//  SimpleShare.h
//  CrossPromotionLib
//
//  Created by Duc Nguyen on 10/22/13.
//  Copyright (c) 2013 DPigpen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SimpleShare : NSObject


+ (void) shareFacebookWithText:(NSString *) text;
+ (void) shareTwitterWithText:(NSString *) text;
+ (void) shareInstagramWithImage:(UIImage *) img andTitle:(NSString*) title;

+ (void) setShareKitController:(id) classShare;


@end
