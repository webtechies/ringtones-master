//
//  MyStoreObserver.h
//  

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h> 
#import <StoreKit/SKPaymentTransaction.h>

@protocol MyStoreObserverDelegate;

@interface MyStoreObserver : NSObject <SKPaymentTransactionObserver> {
	id <MyStoreObserverDelegate> delegate;
}
@property (nonatomic, assign) id <MyStoreObserverDelegate> delegate;

@end

@protocol MyStoreObserverDelegate
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions;

@end
