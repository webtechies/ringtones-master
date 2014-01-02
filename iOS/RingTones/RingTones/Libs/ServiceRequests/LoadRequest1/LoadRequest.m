//
//  LoadRequest.m
//  HeinikenLAC
//
//  Created by Vuong Nguyen on 5/27/13.
//  Copyright (c) 2013 Bizzon Limited Company. All rights reserved.
//

#import "LoadRequest.h"

#define kTimeOutSeconds 180

#define kLinkServices @"http://socialapps.vn/vff/api/services/"
//#define kLinkServices @"http://192.168.1.254/vff/api/services"


@implementation LoadRequest
@synthesize listRequest;


// Tag of Request
enum
{
    TAG_MorePopular = 0,
    TAG_MoreDetail = 1,


};


@synthesize delegate;



- (id)init {
    self = [super init];
    if (self) {
        if (!listRequest)
        {
            listRequest = [[NSMutableArray alloc] init];
        }
        
        
    }
    return self;
}


-(void) releaseLoadRequest
{
    
    for (ASIFormDataRequest *request in listRequest)
    {
        [request cancel];
        [request clearDelegatesAndCancel];
    }
}


//------------------------------------------------
-(NSDictionary *) parsejSonStringFromRequest:(ASIHTTPRequest *) request
{
    // Error if can not submit to server
    NSError *error = [request error];
    if (error)
    {
        
        return nil;
    }
    
    // PARSE DATA
    NSString *responseString = [request responseString];
    NSDictionary *json = [responseString JSONValue];
#ifdef DEBUG
     //NSLog(@"jSon: %@", responseString);
   // NSLog(@"request: %@", request.url.absoluteString);
#endif
    if(!json)
    {
        //--NSLog(@"Can not parse response string from login request");
        return nil;
    }
    
    return json;
}



// request Get Load More Popular
-(void) requestGetLoadMorePopular:(NSString *) url
{
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request setRequestMethod:@"POST"];
    [request setTag:TAG_MorePopular];
    [request setDelegate:self];
    [request setTimeOutSeconds:kTimeOutSeconds];
    [request startAsynchronous];
}


// Request Finished
- (void)requestFinished:(ASIHTTPRequest *)request
{
    
    if (!self.delegate) return;
    if (request) {
        [listRequest removeObject:request];
    }
    
    NSDictionary *dic = nil;
    dic = [self parsejSonStringFromRequest:request];
    //--NSLog(@"dic %@",dic);
    @try
    {
        switch (request.tag)
        {
            case TAG_MorePopular:
            {
                int status = [(NSString *) [dic valueForKey:@"ok"] integerValue];
                //NSLog(@"dic %@",dic);
                
                if (dic) // successed
                {
                    if (status == 1)
                    {
                        [self.delegate finished_requestGetLoadMorePopular:dic];
                        break;
                    }
                    else{
                        [self.delegate failed_requestGetLoadMorePopular]; 
                    }
                    
                }
                else // failed
                {
                    [self.delegate failed_requestGetLoadMorePopular];
                }
                
                break;

            }
                
         
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"exception.description = %@", exception.description);
    }
    @finally
    {
        
    }
    
    
}


-(void) requestFailed:(ASIHTTPRequest *) request
{
    if (request) {
        [listRequest removeObject:request];
    }
    NSDictionary *dic = nil;
    dic = [self parsejSonStringFromRequest:request];
    
#if DEBUG
    NSLog(@"dic %@",dic);
#endif
    switch (request.tag)
    { 
            // Get Top Comic Online
        case TAG_MorePopular:
        {
             [self.delegate failed_requestGetLoadMorePopular];
            break;
        }
    
            
    }
}


@end
