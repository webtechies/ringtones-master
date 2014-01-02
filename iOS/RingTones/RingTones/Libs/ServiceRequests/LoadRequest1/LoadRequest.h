//
//  LoadRequest.h
//  HeinikenLAC
//
//  Created by Vuong Nguyen on 5/27/13.
//  Copyright (c) 2013 Bizzon Limited Company. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "SBJson2.h"
#import "Common.h"
#import "Model.h"

//--Delegate call back when requesr didload
@protocol LoadRequestDelegate <NSObject>

@optional

//--Get Token
//--Post Register
-(void) finished_requestGetLoadMorePopular:(NSDictionary *) data;
-(void) failed_requestGetLoadMorePopular;






@end


/////////////////////////////////////////////////////
//--load data from internet

@interface LoadRequest : NSObject
{

    NSMutableArray *listRequest;
    
}
@property (nonatomic, assign) id delegate;
@property (nonatomic, strong) NSMutableArray *listRequest;



//--release LoadRequest
-(void) releaseLoadRequest;






// request Get Load More Popular
-(void) requestGetLoadMorePopular:(NSString *) url;


@end
