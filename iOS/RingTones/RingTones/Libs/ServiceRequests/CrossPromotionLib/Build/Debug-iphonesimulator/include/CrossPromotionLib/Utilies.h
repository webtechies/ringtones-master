//
//  Utilies.h
//  CrossPromotionLib
//
//  Created by Duc Nguyen on 9/2/13.
//  Copyright (c) 2013 DPigpen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


typedef enum {
    
    kPlatformiPhone = 0x1,
    kPlatformiPhone5,
    kPlatformiPad,
    
} Platform;


//typedef NSString* (^getNibNameCompleteionBlock) (NSString* nameNib);

@interface Utilies : NSObject
{
   
}



/** 
 Defaults nibNameOriginal is normally name iPhone
 You can use block to get your name nib for each platform
**/
+ (NSString *) getNibName:(NSString *) nibNameOriginal;
+ (NSString *) getNibName:(NSString *) nibNameOriginal completion:(NSString* (^) (NSString *)) block;


+ (Platform) currentPlatform;


+ (BOOL) isConnectToInternet;







@end
