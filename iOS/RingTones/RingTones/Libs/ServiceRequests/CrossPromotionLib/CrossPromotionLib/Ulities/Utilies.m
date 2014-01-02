//
//  Utilies.m
//  CrossPromotionLib
//
//  Created by Duc Nguyen on 9/2/13.
//  Copyright (c) 2013 DPigpen. All rights reserved.
//

#import "Utilies.h"
#import "Reachability.h"


@implementation Utilies


+ (BOOL) isConnectToInternet
{
    Reachability *r = [Reachability reachabilityWithHostName:@"www.google.com.vn"];
    NetworkStatus intenetStatus = [r currentReachabilityStatus];
    
    if ((intenetStatus != ReachableViaWiFi) && (intenetStatus != ReachableViaWWAN))
    {
        return NO;
    }
    return YES;
}



+ (NSString *) getNibName:(NSString *) nibNameOriginal
{
    Platform currentPlatfrom = [self currentPlatform];
    
    switch (currentPlatfrom) {
        case kPlatformiPhone:
            nibNameOriginal = nibNameOriginal;
            break;
        case kPlatformiPhone5:
            nibNameOriginal = [NSString stringWithFormat:@"iPhone5%@", nibNameOriginal];
            break;
        
       case kPlatformiPad:
             nibNameOriginal = [NSString stringWithFormat:@"iPad%@", nibNameOriginal];
            break;
        default:
            break;
    }
   
    
    return nibNameOriginal;
}


+ (NSString *) getNibName:(NSString *) nibNameOriginal completion:(NSString *(^)(NSString *))block
{
    NSString *newName = [self getNibName:nibNameOriginal];
    
    newName = block(newName);
    return newName;
}


+ (Platform) currentPlatform
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        
        CGRect mainScren = [[UIScreen mainScreen] bounds];
        if (mainScren.size.height >= 568.0f)
            return kPlatformiPhone5;
        return kPlatformiPhone;
    }
    
    return kPlatformiPad;
}


-(void) dealloc
{

    [super dealloc];
}



@end
