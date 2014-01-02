//
//  RageIAPHelper.m
//  In App Rage
//
//  Created by Ray Wenderlich on 9/5/12.
//  Copyright (c) 2012 Razeware LLC. All rights reserved.
//

#import "RageIAPHelper.h"
#import "FileManager.h"


@implementation RageIAPHelper

+ (RageIAPHelper *)sharedInstance {
    static dispatch_once_t once;
    static RageIAPHelper * sharedInstance;
    
    __block NSString *productid_load = @"";
    __block NSMutableSet *setProducts = [NSMutableSet set];
    
    [FileManager readFileName:@"data_pagesetting" isMakeObject:NO completionBlock:^(NSArray *dataRead){
        //NSLog(@"data: %@", dataRead);

        [dataRead enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
           
            for (NSDictionary *dictionary in obj)
            {            
                NSString *type = [dictionary valueForKey:@"type_setting"];
                if ([type isEqualToString:@"ads"])
                {
                    productid_load = [dictionary valueForKey:@"productid"];
                    productid_load = [productid_load stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                    
                    if ([productid_load rangeOfString:@","].location  != NSNotFound)
                    {
                        NSArray *listproducts = [productid_load componentsSeparatedByString:@","];
                        
                        for (NSString *product  in listproducts)
                        {
                            [setProducts addObject:product];
                        }
                    }
                
                    break;
                }

            }
            
        }];
    }];

    
    dispatch_once(&once, ^{
        
        NSSet * productIdentifiers = [NSSet setWithObjects:
                                      productid_load,
                                      nil];
        if (setProducts.count > 0 )
            productIdentifiers = setProducts;
        
        sharedInstance = [[self alloc] initWithProductIdentifiers:productIdentifiers];
    });
    return sharedInstance;
}

@end
