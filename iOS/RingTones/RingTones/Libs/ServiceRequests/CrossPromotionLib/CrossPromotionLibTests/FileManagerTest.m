//
//  FileManagerTest.m
//  CrossPromotionLib
//
//  Created by Duc Nguyen on 9/2/13.
//  Copyright (c) 2013 DPigpen. All rights reserved.
//

#import "FileManagerTest.h"
#import "FileManager.h"


@implementation FileManagerTest


- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testExample
{
    STFail(@"Unit tests are not implemented yet in CrossPromotionLibTests");
}


-(void) testReadFileManager
{
    [FileManager readFileName:@"abc" completionBlock:^(NSArray *data) {

    }];
    
    STFail(@"Unit tests are not implemented yet in CrossPromotionLibTests");
}

@end
