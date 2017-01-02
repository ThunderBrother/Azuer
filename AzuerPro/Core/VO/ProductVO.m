//
//  ProductVO.m
//  OneStoreMain
//
//  Created by Aimy on 8/29/14.
//  Copyright (c) 2014 OneStore. All rights reserved.
//

#import "ProductVO.h"
#import "ProductDetailVO.h"
//#import "Promotion.h"
#import <OTSKit/OTSKit.h>

#import "SDImageCache.h"
#import "SDWebImageManager.h"

@implementation ProductVO

@synthesize description=_description;

+ (NSNumber *)promotionLevelIdWithPromotionId:(NSString *)aPromotionId
{
	NSArray *componentArray = [aPromotionId componentsSeparatedByString:@"_"];
	NSString *promotionLevelIdStr = [componentArray safeObjectAtIndex:1];
	NSNumber *promotionLevelId = nil;
	if (promotionLevelIdStr.integerValue) {
		promotionLevelId = @(promotionLevelIdStr.integerValue);
	}
	return promotionLevelId;
}

#pragma mark - ProductVO
- (NSMutableArray *)largeProductUrl
{
    if (_largeProductUrl == nil) {
        _largeProductUrl = [[NSMutableArray alloc] init];
    }
    if (_largeProductUrl.count <= 0) {
        [_largeProductUrl addObjectsFromArray:self.midleProductUrl];
    }
    return _largeProductUrl;
}

- (NSString *)midleDefaultProductUrl
{
    if (_midleDefaultProductUrl == nil) {
        _midleDefaultProductUrl = @"";
    }
    
    return _midleDefaultProductUrl;
}


- (NSString *)miniDefaultProductUrl
{
    if (_miniDefaultProductUrl == nil) {
        _miniDefaultProductUrl = self.midleDefaultProductUrl;
    }
    return _miniDefaultProductUrl;
}

- (NSMutableArray *)midleProductUrl
{
    if (_midleProductUrl == nil) {
        _midleProductUrl = [[NSMutableArray alloc] init];
    }
    if (_midleProductUrl.count <= 0) {
        if (self.midleDefaultProductUrl != nil) {
            [_midleProductUrl safeAddObject:self.midleDefaultProductUrl];
        }
    }
    return _midleProductUrl;
}

- (NSMutableArray *)product450x450Url
{
    if (_product450x450Url == nil) {
        _product450x450Url = [[NSMutableArray alloc] init];
    }
    if (_product450x450Url.count <= 0) {
        [_product450x450Url addObjectsFromArray:self.largeProductUrl];
    }
    return _product450x450Url;
}

- (NSMutableArray *)product600x600Url
{
    if (_product600x600Url == nil) {
        _product600x600Url = [[NSMutableArray alloc] init];
    }
    if (_product600x600Url.count <= 0) {
        [_product600x600Url addObjectsFromArray:self.product450x450Url];
    }
    return _product600x600Url;
}

- (NSMutableArray *)product1000x1000Url
{
    if (_product1000x1000Url == nil) {
        _product1000x1000Url = [[NSMutableArray alloc] init];
    }
    if (_product1000x1000Url.count <= 0) {
        [_product1000x1000Url addObjectsFromArray:self.product600x600Url];
    }
    return _product1000x1000Url;
}

- (NSNumber *)shoppingCount
{
    if (_shoppingCount.integerValue <= 0) {
        _shoppingCount = @(1);
    }
    if ([self isLandingPage]) {
        _shoppingCount = @(1);
    }
    return _shoppingCount;
}

+ (NSNumber *)langePageIdWithPromotionId:(NSString *)aPromotionId
{
    if (!aPromotionId) {
        return nil;
    }
    aPromotionId = [aPromotionId lowercaseString];
    NSRange range = [aPromotionId safeRangeOfString:@"landingpage"];
    if (range.location == NSNotFound) {
        return nil;
    }
    return [self nummberIdWithPromotionId:aPromotionId];
}

+ (NSNumber *)nummberIdWithPromotionId:(NSString *)aPromotionId
{
    NSArray *componentArray = [aPromotionId componentsSeparatedByString:@"_"];
    NSString *promotionIdStr = [componentArray safeObjectAtIndex:0];
    
    if (!promotionIdStr) {
        promotionIdStr = aPromotionId;
    }
    NSNumber *nummberPromotionId = nil;
    if (promotionIdStr.integerValue) {
        nummberPromotionId = @(promotionIdStr.integerValue);
    }
    return nummberPromotionId;
}

- (NSNumber *)nummberPromotionId
{
    if ([self isInPromotion]) {
        _nummberPromotionId = [[self class] nummberIdWithPromotionId:self.promotionId];
    }
    return _nummberPromotionId;
}

- (NSNumber *)promotionLevelId
{
    if ([self isInPromotion]) {
        NSArray *componentArray = [self.promotionId componentsSeparatedByString:@"_"];
        NSString *promotionLevelIdStr = [componentArray safeObjectAtIndex:1];
        if (promotionLevelIdStr.integerValue) {
            _promotionLevelId = @(promotionLevelIdStr.integerValue);
        }
    }
    return _promotionLevelId;
}

- (NSNumber *)merchantId
{
    if (_merchantId == nil) {
        _merchantId = @(1);
    }
    return _merchantId;
}

#pragma mark- Public Interface
- (BOOL)isExceedLimitCount
{
    if(fabs(self.price.floatValue - self.yhdPrice.floatValue) < 1.0E-10){
        return YES;
    }
    return NO;
}
/**
 *  功能:此商品是否是限购商品
 *
 *  @return
 */
- (BOOL)isLimitBuy
{
    if (self.promotionType >= 2
        && self.promotionType <=5
        && [self realLimitNumber].integerValue > 0) {
        return YES;
    }
    return NO;
}

/**
 *  雷购商品的限购数量
 *
 *  @return
 */
- (NSNumber *)realLimitNumber
{
    //订单列表的商品
    if (self.isOrderType) {
        if (self.promotionType == 2) {
            return self.remainPromotionStock;
        }else if (self.promotionType == 3){
            return self.limitNumberPerUser;
        }else if (self.promotionType == 4){
            if (self.remainPromotionStock.integerValue < self.limitNumberPerUser.integerValue) {
                return self.remainPromotionStock;
            }
        }else if (self.promotionType == 5){
            return self.remainPromotionStock;
        }
        return self.limitNumberPerUser;
    }
    
    if (self.promotionType == 4) {
        if (self.remainPromotionStock.integerValue < self.limitNumberPerUser.integerValue) {
            return self.remainPromotionStock;
        }
    }
    return self.limitNumberPerUser;
}

- (BOOL)isSeriseProduct
{
    return  (self.seriseProduct.boolValue) || (self.seriesProductVOList.count > 0);
}

/**
 * 判断是否有服务标签
 *
 */
- (BOOL)isHaveTags {
    if (self.isFlashReturnProduct) {
        return YES;
    }
    if (self.businessType == 3 && self.bondedArea == 2) {
        return YES;
    }
    if (self.bondedAreaName.length >0 || self.countryName.length >0) {
        return YES;
    }
       return NO;
}

- (BOOL)isIntergralBuy
{
    if (self.cmsPointProduct.boolValue
        && self.isLandingPage
        && (self.activitypoint.integerValue > 0)) {
        return YES;
    }
    return NO;
}

- (BOOL)isIntegralExchange
{
    if (!self.isLandingPage
        && self.pointPrice
        && (self.promotionPoint.integerValue > 0)) {
        return YES;
    }
    return NO;
}

- (BOOL)isReturnGrouponProduct
{
    return (self.returnDaysReasonless.integerValue > 0);
}

- (BOOL)isReturnProduct
{
    return (self.canBeReturn.boolValue && self.returnDay.integerValue);
}

- (BOOL)isFlashReturnProduct
{
    return (self.productCanBeReturn.boolValue && self.productReturnDay.integerValue);
}


- (BOOL)isPayByPoint
{
    return self.isUsedPointsPay;
}

- (BOOL)isGroup
{
    if (self.ruleType && self.ruleType.integerValue==2) {
        return YES;
    }
    return NO;
}

- (BOOL)isGiftCardProduct
{
    if (self.productType.integerValue == 7) {
        return YES;
    }
    return NO;
}

- (BOOL)isInPromotion
{
    return _promotionId && [_promotionId length] > 0;
}

- (BOOL)isLandingPage
{
    if ([self isInPromotion]) {
        NSRange range = [_promotionId rangeOfString:@"landingpage" options:NSCaseInsensitiveSearch];
        if (range.location != NSNotFound) {
            return YES;
        }
    }
    
    return NO;
}

- (BOOL)isNormalPromotion
{
    if ([self isInPromotion]) {
        NSRange range = [_promotionId safeRangeOfString:@"normal"];
        if (range.location != NSNotFound) {
            return YES;
        }
    }
    
    return NO;
}

// 返回市场价
- (NSNumber *)costPrice
{
    float costPrice = self.maketPrice.doubleValue;
    if (-0.0001 <costPrice && costPrice < 0.0001) {
        return nil;
    }
    
    return self.maketPrice;
}

- (NSNumber *)realPrice
{
    NSNumber *realPrice = self.price;
    if ([self isInPromotion] && self.promotionPrice) {
        realPrice = self.promotionPrice;
    }
    if (self.isGift.boolValue) {
        realPrice = @(0.0);
    }
    return realPrice;
}

- (BOOL)isCanBuy
{
    if (self.canBuy && !self.canBuy.boolValue) {
        return NO;
    }
    return YES;
}

- (BOOL)isJoinCash
{
    return self.hasCash && self.hasCash.length>0;
}

- (BOOL)isJoinDiscount
{
    return self.hasDiscount && self.hasDiscount.length>0;
}

- (BOOL)isJoinGift
{
    return self.hasGift && self.hasGift.boolValue;
}

- (BOOL)isGiftProduct
{
    return self.isGift && self.isGift.boolValue;
}

- (BOOL)isJoinRedemption
{
    return self.hasRedemption && self.hasRedemption.boolValue;
}

- (BOOL)isJoinOffer
{
    return self.offerName && self.offerName.length>0;
}

- (BOOL)isProductSoldOut
{
    return self.stockNumber.intValue <= 0;
}

- (BOOL)isFreshProduct
{
    return self.isFresh && self.isFresh.boolValue;
}

- (BOOL)canSecKillProduct
{
    return self.canSecKill.boolValue;
}

- (BOOL)isSeckillProduct
{
    return self.isSecKill.boolValue;
}

- (BOOL)isYihaodianProduct
{
    if (!self.isYihaodian) {//默认是1号店商品
        return YES;
    }
    return self.isYihaodian.boolValue;
}

- (BOOL)isVendibilityInLocal
{
    if (self.productId.integerValue>0 || self.pmId.integerValue>0) {
        return YES;
    }
    return NO;
}

- (NSNumber *)isSoldOut
{
    if (_isSoldOut) {
        return _isSoldOut;
    }
    _isSoldOut = @1;
    return _isSoldOut;
}

/**
 *  功能:转换成PromotionGift类型
 */
//- (PromotionGift *)toGift
//{
//    PromotionGift *promotionGift = [[PromotionGift alloc] init];
//    promotionGift.promotion = [[Promotion alloc] init];
//    
//    promotionGift.promotion.promotionId = self.nummberPromotionId;
//    promotionGift.promotion.promotionLevelId = self.promotionLevelId;
//    promotionGift.merchantId = @(self.merchantId.intValue);
//    promotionGift.pmId = @(self.pmId.longValue);
//    
//    return promotionGift;
//}

#pragma mark - ProductVO

- (NSNumber *)promStatus
{
    if (([self.promStartTime longLongValue]/1000 <= [[NSDate date] timeIntervalSince1970]) && _promStatus.integerValue==0) {
        return @(1);
    } else {
        return _promStatus;
    }
}

/**
 *  promstatus ==0 即将开始
 *  promstatus ==1 && isSoldOut ==1 已抢光
 *  promstatus ==1 && isSoldOut ==0 &&promRemainNumber=0 已抢光
 *  promstatus ==1 && isSoldOut ==0 &&0<promRemainNumber<10 剩余X件
 *  promstatus ==1 && isSoldOut ==0 &&promRemainNumber>=10 正常销售
 *  promstatus == other 已售完
 *
 *  @return
 */
- (FBProductStatus)productStatus
{
    if (self.promStatus.integerValue == 0) {
        return FBProductStatusCommingSoon;
    } else if (self.promStatus.integerValue == 1) {
        if (self.isSoldOut.boolValue) {
            return FBProductStatusSoldOut;
        } else {
            if (self.promRemainNumber.integerValue <= 0) {
                return FBProductStatusSoldOut;
            } else if (self.promRemainNumber.integerValue>0 && self.promRemainNumber.integerValue<10) {
                return FBProductStatusRemain;
            } else {
                return FBProductStatusSell;
            }
        }
    } else {
        return FBProductStatusEnd;
    }
}

//是否显示商铺信息
- (BOOL)ShowStoreDSR
{
    return ![self isYihaodianProduct];
}

- (NSInteger)thirdCategoryId
{
    NSInteger thirdId = 0;
    if (self.categorySearchName) {
        NSArray *components = [self.categorySearchName componentsSeparatedByString:@":"];
        NSString *categoryStr = [components firstObject];
        NSArray *categories = [categoryStr componentsSeparatedByString:@"-"];
        if (categories.count >= 4) {
            thirdId = [categories[3] integerValue];
        }
    }
    return thirdId;
}

- (NSInteger)topCategoryId
{
    NSInteger topId = 0;
    if (self.categorySearchName) {
        NSArray *components = [self.categorySearchName componentsSeparatedByString:@":"];
        NSString *categoryStr = [components firstObject];
        NSArray *categories = [categoryStr componentsSeparatedByString:@"-"];
        if (categories.count >= 4) {
            topId = [categories[1] integerValue];
        }
    }
    return topId;
}

#pragma mark - ProductVO
/**
 *	返回商品是否还有库存
 *
 *	@return
 */
- (BOOL)isHaveStock
{
    return (self.stockNumber.integerValue > 0);
}

- (BOOL)isSeaBuyProduct
{
    if (self.businessType == 1 || self.businessType == 3) {
        return YES;
    }else{
        return NO;
    }
}

- (NSInteger)seaBuyMaxLimit
{
    if (self.taxAmt == 0) {
        return 0;
    }
    return self.taxFreeAmt / self.taxAmt;
}


- (void)setTcExt:(NSString *)tcExt{
    if (tcExt.length>0) {
        self.tce = tcExt;
    }
}

//sam入口
- (BOOL)isShowSamsEntry{
    //山姆商详在 用户未登录 和 已登录但不是山姆会员 情况下显示 (该商品是sam商品且badgeDiscountRate<100则说明当前用户登录了且是sam会员)
    if (self.samMemberPrice) {
        if (self.badgeDiscountRate.integerValue <100) {
            return NO;
        } else {
            return YES;
        }
    }else {
        return NO;
    }
}

- (BOOL)isOnSale {
    return [self.ruleType isEqualToNumber:@2];
}

- (BOOL)isPromotion {
    return self.hasCash.length || self.offerName.length || self.hasGift.boolValue || self.isDiscount.boolValue;
}

@end
