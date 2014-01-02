//
//  SimpleShare.m
//  CrossPromotionLib
//
//  Created by Duc Nguyen on 10/22/13.
//  Copyright (c) 2013 DPigpen. All rights reserved.
//

#import "SimpleShare.h"
#import "SHKFacebook.h"
#import "SHKTwitter.h"
#import "SHKInstagram.h"


@implementation SimpleShare


-(id) init
{
    self  = [super init];
    if (self)
    {
        
    }
    
    return self;
}


-(void) setShareKitController:(id) classShare
{
    [SHK setRootViewController:classShare];
}


- (void) shareInstagramWithImage:(UIImage *) img andTitle:(NSString*) title
{
    
    SHKItem *item = [SHKItem image:img title:@""];
    
    [NSClassFromString([NSString stringWithFormat:@"SHKInstagram"])
    performSelector:@selector(shareItem:) withObject:item];
}


- (void) shareFacebookWithText:(NSString *) text
{
    SHKItem *item;
    
    item = [SHKItem text:text];
    
    [NSClassFromString([NSString stringWithFormat:@"SHKFacebook"])
    performSelector:@selector(shareItem:) withObject:item];

}


- (void) shareTwitterWithText:(NSString *) text
{
    SHKItem *item;
    
    item = [SHKItem text:text];
    
    [NSClassFromString([NSString stringWithFormat:@"SHKTwitter"])
     performSelector:@selector(shareItem:) withObject:item];
}



+ (void) setShareKitController:(id) classShare
{
    [SHK setRootViewController:classShare];
}

+ (void) shareInstagramWithImage:(UIImage *) img andTitle:(NSString*) title
{
    SimpleShare *share = [[[self alloc] init] autorelease];
    [share shareInstagramWithImage:img andTitle:title];
}


+ (void) shareFacebookWithText:(NSString *) text
{
    SimpleShare *share = [[[self alloc] init] autorelease];
    [share shareFacebookWithText:text];
    
}


+ (void) shareTwitterWithText:(NSString *) text
{
    SimpleShare *share = [[[self alloc] init] autorelease];
    [share shareTwitterWithText:text];
}


@end
