//
//  ShareSimple.m
//  CrossPromotionLib
//
//  Created by Duc Nguyen on 9/8/13.
//  Copyright (c) 2013 DPigpen. All rights reserved.
//

#import "ShareSimple.h"

#import "SHKFacebook.h"
#import "SHKConfiguration.h"
#import "ShareKitDemoConfigurator.h"


static ShareSimple *shareInstance =  nil;

@implementation ShareSimple


-(id) init
{
    self = [super init];
    if (self)
    {
        //Here you load ShareKit submodule with app specific configuration
        DefaultSHKConfigurator *configurator = [[ShareKitDemoConfigurator alloc] init];
        [SHKConfiguration sharedInstanceWithConfigurator:configurator];

    }
    
    return self;
    
}



+ (ShareSimple *) simpleSharing
{
    @synchronized(self)
    {
		if (shareInstance != nil) {
			[NSException raise:@"IllegalStateException" format:@"SHKConfiguration has already been configured with a delegate."];
		}
		shareInstance = [[ShareSimple alloc] init];
    }
    return shareInstance;

}

+ (void) simpleSharingBecomeActive
{
    [SHKFacebook handleDidBecomeActive];
}


+(void) simpleSharingTerminal
{
    
    // Save data if appropriate
	[SHKFacebook handleWillTerminate];
}



+ (BOOL) simpleSharingOpenURL:(NSURL *)url
             sourceApplication:(NSString *)sourceApplication
                    annotation:(id)annotation
{
    NSString* scheme = [url scheme];
    
    if ([scheme hasPrefix:[NSString stringWithFormat:@"fb%@", SHKCONFIG(facebookAppId)]]) {
        return [SHKFacebook handleOpenURL:url];
    }
    
    return YES;

}



@end
