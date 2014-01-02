//
//  RemoteService.m
//  Snooty
//
//  Created by Tran Thien Khiem on 12/12/12.
//  Copyright (c) 2012 Phan Xuan Quang. All rights reserved.
//

#import "RemoteService.h"
#import "ASIFormDataRequest.h"
#import "SBJson2.h"


@implementation RemoteService

NSString *sessionId = NULL;

+ (void) registerSession:(NSString *)sessionId_
{
    NSUserDefaults *preference = [NSUserDefaults standardUserDefaults];
    if (sessionId_)
    {
        sessionId = [NSString stringWithString:sessionId_];
        [preference setValue:sessionId forKey:@"sessionId"];
        [preference synchronize];
    }
    else
    {
        sessionId = nil;
        [preference removeObjectForKey:@"sessionId"];
        [preference synchronize];
    }
}

// Initialize
- (id) init
{
    [super init];
    if (self)
    {
        self.serviceName = NSStringFromClass([self class]);
        self.serviceName = [self.serviceName substringToIndex:[self.serviceName length] - 7];
        
    }
    return self;
}

- (id) initWithName:(NSString *) name
{
    [super init];
    if (self)
    {
        self.serviceName = name;
    }
    return self;
}

// invoke method
- (void) invokeMethod:(NSString *)methodName params:(NSArray *)arguments
{
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:GATEWAY]];
    [request setDelegate:self];
    [request setPostValue:APP forKey:@"app"];
    [request setPostValue:self.serviceName forKey:@"service"];
    [request setPostValue:methodName forKey:@"action"];
    [request setPostValue:[arguments JSONRepresentation] forKey:@"json_arguments"];
    
    if ([DEBUG_SERVICES isEqualToString:@"1"])
    NSLog(@"JSON Data sent: %@", [arguments JSONRepresentation]);
    
    [request setPostValue:@"true" forKey:@"json"];
    [request setTimeOutSeconds:30];
    
    if (self.attachedFile)
    {
        [request addFile:self.attachedFile forKey:@"file"];
    }
    
    if (sessionId)
    {
        [request setPostValue:sessionId forKey:@"session_id"];
    }
    
    [request startAsynchronous];
}

// request finished
- (void) requestFinished:(ASIHTTPRequest *) request
{
  if ([DEBUG_SERVICES isEqualToString:@"1"])
    NSLog(@"Response: %@", request.responseString);

    NSDictionary *responseData = [request.responseString JSONValue];
    
    if ([responseData objectForKey:@"ok"])
    {
        NSString *actionName = [NSString stringWithFormat:@"%@Finished:", [responseData objectForKey:@"action"] ];
        SEL selector = NSSelectorFromString(actionName);
        id data = [responseData objectForKey:@"data"];
        
        if (data != NULL && [data respondsToSelector:@selector(objectForKey:)])
        {
            if ([data objectForKey:@"session"])
            {
                [RemoteService registerSession:[data objectForKey:@"session"]];
            }
        }
        
        if (self.delegate && [self.delegate respondsToSelector:selector])
        {
            [self.delegate performSelector:selector withObject:data];
        }
    }
    else
    {
        NSString *actionName = [NSString stringWithFormat:@"%@Failed:", [responseData objectForKey:@"action"] ];
        SEL selector = NSSelectorFromString(actionName);
        if (self.delegate && [self.delegate respondsToSelector:selector])
        {
            [self.delegate performSelector:selector withObject:[responseData objectForKey:@"error"]];
        }
    }
}


// request failed
- (void) requestFailed:(ASIHTTPRequest *) request
{
  if ([DEBUG_SERVICES isEqualToString:@"1"])
    NSLog(@"Request Failed: %@", request.error);
}

@end
