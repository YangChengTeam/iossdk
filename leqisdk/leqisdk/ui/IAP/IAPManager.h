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
@property (nonatomic, assign) NSString* userId;
@property (nonatomic, assign) int count;
+ (instancetype)sharedManager;

- (BOOL)requestProductWithId:(NSString *)productId userId:(NSString *)userId count:(int)count;
- (BOOL)purchaseProduct:(SKProduct *)skProduct;
- (BOOL)restorePurchase;
- (void)refreshReceipt;
- (void)finishTransaction;

@end




