//
//  MyStoreObserver.m
// 


#import "MyStoreObserver.h"
#import "Constants.h"

@implementation MyStoreObserver

@synthesize delegate;

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    if (self.delegate) {
		[self.delegate paymentQueue:queue updatedTransactions:transactions];
    }
	 
}

@end
