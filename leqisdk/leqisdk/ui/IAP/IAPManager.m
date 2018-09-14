//
//  IAPManager.m
//  IAPurchaseManager
//


#import "IAPManager.h"
#import "LeqiSDK.h"

@interface IAPManager() <SKProductsRequestDelegate, SKPaymentTransactionObserver> {
    SKProduct *myProduct;
}

@property (nonatomic, strong) SKPaymentTransaction *currentTransaction;

@end

@implementation IAPManager

#pragma mark - ================ Singleton ================= 

+ (instancetype)sharedManager {
    
    static IAPManager *iapManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        iapManager = [IAPManager new];
    });
    
    return iapManager;
}

#pragma mark - ================ Public Methods =================

#pragma mark ==== 请求商品
- (BOOL)requestProductWithId:(NSString *)productId userId:(NSString *)userId count:(int)count {
    self.userId = userId;
    self.count = count;
    if(count < 1){
        self.count = 1;
    }
    if (productId.length > 0) {
        NSLog(@"leqisdk:请求商品%@", productId);
        SKProductsRequest *productRequest = [[SKProductsRequest alloc]initWithProductIdentifiers:[NSSet setWithObject:productId]];
        productRequest.delegate = self;
        [productRequest start];
        return YES;
    }
    return NO;
}


#pragma mark ==== 购买商品
- (BOOL)purchaseProduct:(SKProduct *)skProduct {
    
    if (skProduct != nil) {
        if ([SKPaymentQueue canMakePayments]) {
            SKMutablePayment *payment = [SKMutablePayment paymentWithProduct:skProduct];
            payment.applicationUsername = self.userId;
            payment.quantity = self.count;
            [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
            [[SKPaymentQueue defaultQueue] addPayment:payment];
            return YES;
        } 
    }
    return NO;
}

#pragma mark ==== 商品恢复
- (BOOL)restorePurchase {
    if ([SKPaymentQueue canMakePayments]) {
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
        return YES;
    }
    return NO;
}

#pragma mark ==== 结束这笔交易
- (void)finishTransaction {
	[[SKPaymentQueue defaultQueue] finishTransaction:self.currentTransaction];
}


#pragma mark ====  刷新凭证
- (void)refreshReceipt {
    SKReceiptRefreshRequest *request = [[SKReceiptRefreshRequest alloc] init];
    request.delegate = self;
    [request start];
}

#pragma mark - ================ SKRequestDelegate =================

- (void)requestDidFinish:(SKRequest *)request {
    if ([request isKindOfClass:[SKReceiptRefreshRequest class]]) {
        NSURL *receiptUrl = [[NSBundle mainBundle] appStoreReceiptURL];
        NSData *receiptData = [NSData dataWithContentsOfURL:receiptUrl];
        [_delegate successedWithReceipt:receiptData];
    }
}


#pragma mark - ================ SKProductsRequest Delegate =================

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    NSArray *myProductArray = response.products;
    if (myProductArray.count > 0) {
        myProduct = [myProductArray objectAtIndex:0];
        [_delegate receiveProduct:myProduct];
    } else {
        [_delegate receiveProduct:myProduct];
    }
}

#pragma mark - ================ SKPaymentTransactionObserver Delegate =================

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions {
    
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchasing: //商品添加进列表
                NSLog(@"leqisdk:商品%@被添加进购买列表",myProduct.localizedTitle);
                break;
            case SKPaymentTransactionStatePurchased://交易成功
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed://交易失败
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored://已购买过该商品
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            default:
                
                break;
        }
    }
}

#pragma mark - ================ Private Methods =================
- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    NSURL *receiptUrl = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receiptData = [NSData dataWithContentsOfURL:receiptUrl];
    self.currentTransaction = transaction;
    if(_delegate){
        [_delegate successedWithReceipt:receiptData];
    }
}


- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    
    if (transaction.error.code != SKErrorPaymentCancelled && transaction.error.code != SKErrorUnknown) {
        [_delegate failedPurchaseWithError:transaction.error.localizedDescription];
    }
    
    if(transaction.error.code == SKErrorPaymentCancelled && transaction.error.code != SKErrorUnknown){
        [_delegate canceledPurchaseWithError:transaction.error.localizedDescription];
    }
    

    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    self.currentTransaction = transaction;
}

@end
