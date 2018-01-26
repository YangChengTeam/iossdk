//
//  IAPManager.h
//  IAPurchaseManager
//


#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@protocol IAPManagerDelegate <NSObject>

@optional

- (void)receiveProduct:(SKProduct *)product;

- (void)successedWithReceipt:(NSData *)transactionReceipt;

- (void)failedPurchaseWithError:(NSString *)errorDescripiton;

- (void)canceledPurchaseWithError:(NSString *)errorDescripiton;


@end


@interface IAPManager : NSObject

@property (nonatomic, assign)id<IAPManagerDelegate> delegate;


+ (instancetype)sharedManager;

- (BOOL)requestProductWithId:(NSString *)productId;
- (BOOL)purchaseProduct:(SKProduct *)skProduct;
- (BOOL)restorePurchase;
- (void)refreshReceipt;
- (void)finishTransaction;

@end




