//
//  ProductVO.h
//  OneStoreMain
//
//  Created by Aimy on 8/29/14.
//  Copyright (c) 2014 OneStore. All rights reserved.
//
#import <OTSKit/OTSKit.h>
//#import "PromotionGift.h"
//#import "MerchantInfoVO.h"
//#import "RateCommentarVO.h"
//#import "ProductRatingVO.h"
//#import "SeriesColorVO.h"
//#import "OTSBigPromotionTagInfoVo.h"
//#import "FlashBuyMerchantRateCommentary.h"
@protocol SeriesProductVO;
@class SeriesProductVO;
@class ProductDetailVO;

@protocol ProductVO <NSObject>

@end

@interface ProductVO : OTSModel

//base
@property(nonatomic, copy) NSString *cnName;//商品中文名称
@property(nonatomic, copy) NSString *enName;//商品英文名称
@property(nonatomic, strong) NSNumber *canBuy;//商品是否可购买，true/false
@property(nonatomic, copy) NSString *description;//商品描述
@property(nonatomic, strong) NSNumber *mobileProductType;//商品类型 1表示为1起摇商品,2表示为主系列商品
@property(nonatomic, strong) NSNumber *pmId;//加入购物车需要的id字段
@property(nonatomic, strong) NSNumber *productId;//商品id
@property(nonatomic, copy) NSString *code;//商品编码
@property(nonatomic, strong) NSNumber *productSaleNumber;//近期销量
@property(nonatomic, strong) NSNumber *productSaleType;
@property(nonatomic, strong) NSNumber *productType;//商品类型 0：普通产品 1：主系列产品 2：子系列产品 3：捆绑产品 4：实体礼品卡 5: 虚拟商品 6:增值服务 7:电子礼品卡
@property(nonatomic, strong) NSNumber *ruleType;//团购=2
@property(nonatomic, strong) NSNumber *shoppingCount;//最低购买数
@property(nonatomic, strong) NSNumber *specialType;
@property(nonatomic, strong) NSNumber *hasBought;//已购商品标志：0.否；1.是
@property(nonatomic, strong) NSNumber *buyCount;//用户购买次数
@property(nonatomic, strong) NSNumber *isIntoCart;//是否进购物车，0或1，团购预热中2为一键购
@property(nonatomic, copy) NSString *subCnName;//商品二级标题，interface version>1.3.1  app version> 3.1.1 存在,可能为空
@property(nonatomic, copy) NSString *tag;//图片左上标记，interface version>1.3.1  app version> 3.1.1 存在,可能为空
@property(nonatomic, copy) NSString *tags;
@property(nonatomic, strong) NSNumber *orderBuyProductCount;
@property(nonatomic, copy) NSString *barcodeKeyword;//推荐热词
@property(nonatomic, strong) NSNumber *moreMerchantsNum; // 一品多商的数量
@property(nonatomic, strong) NSNumber *normativeProductId; // 标品id
@property(nonatomic, strong) NSNumber *toDetail;// 是否直接去详情

//生鲜
@property(nonatomic, strong) NSNumber *isFresh;//是否是生鲜商品

//折扣
@property(nonatomic, strong) NSNumber *discount;

//1点通
@property(nonatomic, strong) NSNumber *isAdProduct;//一点通广告标识： 0-否；1-是
@property(nonatomic, copy) NSString *landingPage;//一点通广告landingPage

//沃尔玛
@property(nonatomic, strong) NSNumber *isWalMartPrice;//沃尔玛省心价商品：0.否；1.是

//1号海购
@property(nonatomic, strong) NSNumber *isOverseaShopping;//1号海购商品：0.否；1.是

//1贵就赔
@property(nonatomic, strong) NSNumber *isLowestPrice;//一贵就赔商品：0.否；1.是

//收藏
@property(nonatomic, strong) NSNumber *favoriteNum;//收藏数

//品牌
@property(nonatomic, copy) NSString *brandName;//品牌名称
@property(nonatomic, copy) NSString *brandCode;//品牌code

//精品推荐
@property(nonatomic, copy) NSString *productTag;//商品右下角标示
@property(nonatomic, strong) NSNumber *addType;//加入购物车标志
@property(nonatomic, strong) NSNumber *dxxPriceDifference;//DXX低价格
@property(nonatomic, strong) NSNumber *isNotice;//是否勾选到货提醒
@property(nonatomic, strong) NSNumber *recommendType;//推荐的类型（要客户端自己去包装）
@property(nonatomic, strong) NSNumber *promotionLevel;
@property(nonatomic, strong) NSNumber *opType;

//类目
@property (nonatomic, strong) NSNumber *cateId;//类目Id
@property (nonatomic, copy) NSString *cateName;//类目名

//bi
@property (nonatomic, copy) NSString *tc;
@property (nonatomic, copy) NSString *tce;// tc扩展字段
@property (nonatomic, copy) NSString *tcCode;
@property (nonatomic, copy) NSString *tceCode;// tc扩展字段
@property (nonatomic, copy) NSString *tc_e;// tc扩展字段
@property (nonatomic, copy) NSString *trackerUrl;// 广告付费URL字段
@property (nonatomic, copy) NSString *tcExt;// tce

@property (nonatomic) BOOL canShowCart;//是否可显示购物车： true= 显示， false= 不显示  S47加入
#pragma mark - 金牌卖家
@property (nonatomic, strong) NSNumber *isGoldMerchant;

#pragma mark - 热门推荐
@property (nonatomic, copy) NSString *productName;//商品名
@property (nonatomic, copy) NSString *productPicUrl;//图片链接

//库存
@property(nonatomic, copy) NSString *stockDesc;//库存信息
@property(nonatomic, strong) NSNumber *stockNumber;//商品库存
@property(nonatomic, assign) BOOL isStockUnusual;//是否库存异常

//merchant
@property(nonatomic, strong) NSNumber *isYihaodian;//是否是1号店，0:否 1:是
@property(nonatomic, strong) NSNumber *merchantId;//商家id
@property(nonatomic, strong) NSString *merchantName;//迭代36 新加入字段
@property(nonatomic, strong) NSArray *merchantIds;//商家序列id，list<java.lang.Long>
//@property(nonatomic, retain) MerchantInfoVO *merchantInfoVO;//商家信息
//@property(nonatomic, retain) RateCommentarVO *rateCommentarVO;//店铺评分
@property(nonatomic, retain) NSNumber *salesVolume;//近期销量(店铺列表使用)

//pic
@property(nonatomic, copy) NSString *productDetailUrl;//产品详情页url，目前提供出去，给app分享出去用
@property(nonatomic, copy) NSString *hotProductUrl;
@property(nonatomic, copy) NSString *hotProductUrlForWinSys;//（添加购物车url，首页接口为了少修改复用的）
@property(nonatomic, copy) NSString *miniDefaultProductUrl;//商品小图地址
@property(nonatomic, copy) NSString *midleDefaultProductUrl;//商品图片地址
@property(nonatomic, strong) NSMutableArray *midleProductUrl;//String[]类型
@property(nonatomic, strong) NSMutableArray *largeProductUrl;//String[]类型
@property(nonatomic, strong) NSNumber *midleDefaultProductUrlPicHeight;//商品默认图片的高度
@property(nonatomic, strong) NSNumber *midleDefaultProductUrlPicWidth;//商品默认图片的宽度
@property(nonatomic, strong) NSMutableArray *product1000x1000Url;
@property(nonatomic, strong) NSMutableArray *product600x600Url;
@property(nonatomic, strong) NSMutableArray *product450x450Url;
@property(nonatomic, strong) NSArray *product380x380Url;
@property(nonatomic, strong) NSArray *product80x80Url;

//促销
@property(nonatomic, copy) NSString *promotionId;//商品促销id信息
@property(nonatomic, strong) NSNumber *promotionSalePercent;//促销已售百分比=已销售数量/促销限制数量
@property(nonatomic, strong) NSNumber *isDiscount;//折扣促销活动标志：0.否；1.是
@property(nonatomic, strong) NSNumber *promStartTime;//商品促销开始时间
@property(nonatomic, strong) NSNumber *promEndTime;//商品促销结束时间
@property(nonatomic, strong) NSNumber *selected;//促销中被选中，true/false
@property(nonatomic, copy) NSString *advertisement;//广告促销链接
@property(nonatomic, strong) NSNumber *lpPromotionId;//landingPage促销id

//赠品
@property(nonatomic, strong) NSNumber *isGift;//商品是否为赠品，1表示为赠品，0表示否，主要用于在订单中标识是否为赠品
@property(nonatomic, strong) NSNumber *hasGift;//是否有赠品，0没有，1有
@property(nonatomic, strong) NSNumber *quantity;//赠品的赠送数量
@property(nonatomic, strong) NSNumber *isSoldOut;//赠品是否已售完
@property(nonatomic, copy) NSString *giftName;//赠品活动的标题
@property(nonatomic, copy) NSString *totalQuantityLimit;//商品的限制数量(赠品的限制数量)，根据限制类型来设置，若赠品类型为-1，则返回"限量当前库存xx个"，若为2则返回"每日限量xx个"，若为1则返回"限量xx个"

//换购
@property(nonatomic, assign) BOOL isRedemption;//是换购商品
@property(nonatomic, strong) NSNumber *hasRedemption;//是否参加换购活动  0-否；1-是

//满减满折
@property(nonatomic, copy) NSString *hasCash;//满减活动名称  ""或者NULL表示没有满减活动其他表示满减活动的名称
@property(nonatomic, copy) NSString *hasDiscount;//折扣活动名称  ""或者NULL表示没有折扣活动其他表示折扣活动的名称

//n元n件
@property(nonatomic, copy) NSString *offerName;//n元n件活动名称 ""或者NULL表示没有n元n件活动其他表示n元n件活动的名称

//1起摇
@property(nonatomic, strong) NSNumber *rockJoinPeopleNum;//该商品的1起摇参加人数

//无线专享
@property(nonatomic, strong) NSNumber *channelId;//无线专享价标志： 102.无线专享价
@property(nonatomic, strong) NSNumber *priceDiff;//无线专享价差价

//大促
@property(nonatomic, strong) NSNumber *isBigPromotion;//是否是大促 0.否；1.是
@property(nonatomic, copy) NSString *bigPromotionIconUrl;//大促图片
//@property (strong, nonatomic) NSArray<OTSBigPromotionTagInfoVo> *effectBigPromotionTag; //1-狂欢价 2-无限冲锋日 3-真五折

//评价
@property(nonatomic, strong) NSNumber *experienceCount;//商品的评价人数
@property(nonatomic, strong) NSNumber *exprienceScore;//商品的评价星级
//@property(nonatomic, retain) ProductRatingVO *rating;
@property(nonatomic, strong) NSNumber *positiveRate;//好评率数字

//品牌
@property(nonatomic, retain) NSNumber *productBrandId;
#pragma mark - 海购商品
@property (nonatomic, assign) NSInteger businessType;//商家类型：1-海外直邮商家，2-国内商家（默认）,3-保税区商家
@property (nonatomic, assign) CGFloat taxAmt;//进口税预计
@property (nonatomic, assign) NSInteger taxFreeAmt;//进口税少于这个免税
/**
 *  海购最大购买件数
 */
@property (nonatomic, assign) NSInteger seaBuyMaxLimit;

/**
 *  是不是海购
 */
@property (nonatomic, assign, getter=isSeaBuyProduct) BOOL seaBuyProduct;

#pragma mark - 每日惠
@property(nonatomic, strong) NSNumber *landingTotalStock;//每日惠商品总库存
@property(nonatomic, strong) NSNumber *diaryRemainTimes;//每日惠活动剩余时间
@property(nonatomic, strong) NSNumber *landingLimitNumPerUser;//每日惠商品每人限购数量,-1表示不限制数量
@property(nonatomic, strong) NSNumber *landingSaleProductLimit;//每日惠商品每单限购数量,-1表示不限制数量
@property(nonatomic, strong) NSDate *startTime;
@property(nonatomic, strong) NSDate *endTime;

//price
@property(nonatomic, strong) NSNumber *promotionPrice;//商品促销价格
@property(nonatomic, strong) NSNumber *maketPrice;//商品市场价格
@property(nonatomic, strong) NSNumber *yhdPrice;//商品一号店价格
@property(nonatomic, strong) NSNumber *price;//商品价格
@property(nonatomic, strong) NSNumber *currentPrice; //当前售价
@property(nonatomic, strong) NSNumber *lpPromNonMemberPrice;//landingPage活动价

//退换货
@property(nonatomic, strong) NSNumber *canBeReturn;//表示是否支持退换1支持，0不支持
@property(nonatomic, strong) NSNumber *returnDay;//显示包退换的天数
@property(nonatomic, strong) NSNumber *returnDaysReasonless;//无理由退货天数 0：不支持无理由退货， 7：支持7天无理由退货，15：支持15天无理由退货..等等 （团购）

//im
@property (nonatomic, strong) NSNumber *IMMerchantId;//对于自营商品，getProductDetail 接口返回的 merchantId = 1，但这不是IM那边要的。。。对于自营商品，show_im_app 接口会返回一个 supplierId，从商详页进入在线客服的时候取该值作为 merchantId；对于商城商品，还是用 getProductDetail 接口返回的 merchantId；该属性目前仅限 IM 使用
@property (nonatomic, assign) BOOL hasOnlineService;//是否支持在线客服。商城商品都支持在线客服，自营商品通过接口决定。

#pragma mark - 闪购
@property(nonatomic, strong) NSNumber *isFlashSales;//是否是闪购商品
@property(nonatomic, strong) NSNumber *isOnekeySales;//是否是一键购商品
@property(nonatomic, strong) NSNumber *isOneKeyGo;//一键购商品：0.否；1.是
@property(nonatomic, copy) NSString *afterSaleInfo;//售后服务描述
@property(nonatomic, strong) NSNumber *promStatus;//0 表示未开始    1表示进行中   2表示已结束
@property(nonatomic, strong) NSNumber *promRemainNumber;//闪购库存
@property(nonatomic, retain) NSNumber *categoryId;
@property(nonatomic, copy) NSString *categorySearchName;

//闪购详情添加
@property(nonatomic, strong) NSNumber *productCanBeReturn;//是否支持退换1支持，0不支持
@property(nonatomic, strong) NSNumber *productReturnDay;//包退换的天数
@property(nonatomic, strong) NSNumber *priceChangeRemind;//价格防呆 0不需要 1需要
@property(nonatomic, strong) NSString *labelName;
@property(nonatomic, strong) NSString *bondedAreaName;//保税区名称
@property(nonatomic, strong) NSString *departurePlace;//保税区名称

@property(nonatomic, strong) NSString *countryName; //海购商品生产国
@property(nonatomic, assign) NSInteger bondedArea;//闪购海购保税区
@property(nonatomic, assign) NSInteger deliveryType;//1表示直邮  2表示保税区
@property(nonatomic, strong) NSString * nationalFlagUrl;//进口国国旗

@property(nonatomic, strong) NSString *samIntroductURL;//了解sam Url
@property (nonatomic, strong) NSNumber *currentPriceWithoutBadge;//sam非会员价
@property (nonatomic, strong) NSNumber *badgeDiscountRate;//闪购根据该值判断当前用户是否是sam会员且是否登录，若该商品是sam商品且badgeDiscountRate<100则说明当前用户登录了且是sam会员）。
@property (strong, nonatomic) NSString *samCardPmId;//山姆卡的pmid



/**
 *	当前商品是否是序列自品
 */
@property(nonatomic, assign)BOOL isSubSeriesProduct;
@property(nonatomic, strong) NSNumber *addToCartCount;//已经添加了多少个


#pragma mark - 积分兑换
@property(nonatomic, strong) NSNumber *pointProduct;//积分换购商品标志：0.否；1.是
@property(nonatomic, strong) NSNumber *activitypoint; //活动积分
@property(nonatomic, strong) NSNumber *cmsPointProduct;//CMS积分兑换商品 1-是、0-不是
@property(nonatomic, strong) NSNumber *isPointProduct;//标识此商品是否是积分换购商品//商品列表才返回
@property(nonatomic, strong) NSNumber *pointPrice;//积分换购RMB价格
@property(nonatomic, strong) NSNumber *promotionPoint;//积分换购积分价格
@property(nonatomic, strong) NSNumber *currentPoint;//换购所需积分

#pragma mark - 系列商品
//@property(nonatomic, strong) NSArray<SeriesColorVO> *colorList;//系列产品所有尺寸属性集合，list<SeriesColorVO>
@property(nonatomic, strong) NSNumber *seriseProduct;//系列商品标志：0.普通商品；1.系列商品虚码；2.系列商品子码
@property(nonatomic, strong) NSArray <SeriesProductVO> *seriesProductVOList;//系列商品集合，list<SeriesProductVO>
@property(nonatomic, strong) NSArray *sizeList;//系列商品集合，list<string>
@property(nonatomic, strong) NSNumber *mainProductId;//主品id
@property(nonatomic, strong) NSMutableDictionary *selectAttributeVOList;//已选择的属性

#pragma mark - 秒杀
@property(nonatomic, strong) NSNumber *canSecKill;//商品是否能够秒杀，true/false
@property(nonatomic, strong) NSNumber *isSecKill;//商品是否是秒杀商品，true/false

#pragma mark - 名品特卖
@property(nonatomic, strong) NSNumber *famousSalePrice;//名品特卖价格
@property(nonatomic, strong) NSNumber *mingPinRemainTimes;
@property(nonatomic, strong) NSNumber *isMingPin;

#pragma mark- 雷购
@property(nonatomic, assign) NSInteger promotionType;//0:不促销；1:无数量限制促销 2:限制每个订单购买数量 3:限制每个会员购买数量 4:限制商品总共购买数量（限总量+限用户） 5.限每个订单购买数量，超过原价也不能购买
@property(nonatomic, strong) NSNumber *limitNumberPerUser;
@property(nonatomic, strong) NSNumber *remainPromotionStock;
@property(nonatomic, assign) BOOL isOrderType;//订单列表的雷购商品
@property(nonatomic, assign) NSInteger buyNumber;//雷购，此商品用户购买数量
@property(nonatomic, assign) NSInteger buyTotalNumber;//此商品用户购买的总数量(包括限购和非限购)
@property(nonatomic, strong) NSNumber *hasBuyNum;//限购商品已购买数量
//special
@property(nonatomic, strong) NSNumber *specialInfo;//低xx 多少元
@property(nonatomic, strong) NSNumber *specialTag;//1团购：2预售，促销；3新品；4进口食品；5热卖；8独家；10超值12低xx；13名品特卖；14特色中国


#pragma mark - 客户端字段
@property(nonatomic, assign) BOOL remind;//是否有本地提醒
@property(nonatomic, assign) BOOL isFaved;
@property(nonatomic, strong) NSNumber *promotionLevelId;//通过promotionId解析出来的promotionLevelId
@property(nonatomic, strong) NSNumber *nummberPromotionId;//通过promotionId传解析出来的数字类型的nummberPromotionId
@property(nonatomic, strong) NSNumber *favoriteId;//收藏id
@property(nonatomic, assign) BOOL isUsedPointsPay;//是否使用积分购


@property(nonatomic, assign) NSInteger cateExtType; //用于区分产品是否属于流行百货类目，0非流百，1流百

@property (nonatomic, assign) NSInteger isReadSub; //切换子品时是否需要重新请求文描

#pragma mark 一点通VO
@property (nonatomic, strong) NSNumber *adCampaignId;
@property (nonatomic, strong) NSNumber *adId;
@property (nonatomic, strong) NSNumber *adIdeaId;
@property (nonatomic, strong) NSNumber *adPrdId;
@property (nonatomic, strong) NSNumber *adSourceType;// 广告来源类型
@property (nonatomic, strong) NSNumber *adType;// 广告类型
@property (nonatomic, strong) NSNumber *advertiseId;// 广告ID
@property (nonatomic, strong) NSString *appLandingPage;// 大促链接
@property (nonatomic, strong) NSNumber *biddingAdType;// 竞标类型
@property (nonatomic, strong) NSNumber *biddingPrice;// 竞标价格
@property (nonatomic, strong) NSNumber *commentCount;// 评论数
@property (nonatomic, strong) NSString *commonScreenImgUrl;// 普通图片链接
@property (nonatomic, strong) NSNumber *curSiteType;
@property (nonatomic, strong) NSNumber *currentPage;
@property (nonatomic, strong) NSNumber *discountPrice;// 折扣价格
@property (nonatomic, strong) NSNumber *districId;
@property (nonatomic, assign) BOOL freeDelivery;// 是否包邮
@property (nonatomic, assign) BOOL grouponProduct;// 是否团购商品
@property (nonatomic, assign) BOOL hotProduct;// 热门商品
@property (nonatomic, strong) NSString *imgAdTips;
@property (nonatomic, strong) NSNumber *index;
@property (nonatomic, strong) NSNumber *isRecordTracker;
@property (nonatomic, strong) NSNumber *marketPrice;// 市场价
@property (nonatomic, strong) NSNumber *mcSiteId;
@property (nonatomic, strong) NSNumber *merchantType;
//@property (nonatomic, strong) NSString *theNewProduct;// 是否是新品
@property (nonatomic, assign) BOOL newProduct;// 是否新品
@property (nonatomic, strong) NSNumber *nextBlockStartIndex;
@property (nonatomic, strong) NSString *originalImgUrl;
@property (nonatomic, strong) NSString *originalPrice;
@property (nonatomic, strong) NSNumber *pageSize;
@property (nonatomic, strong) NSNumber *parentPmInfoId;
@property (nonatomic, strong) NSNumber *parentProductId;
@property (nonatomic, strong) NSNumber *planId;
@property (nonatomic, strong) NSNumber *pmInfoId;
@property (nonatomic, strong) NSNumber *prodCategoryId;
@property (nonatomic, strong) NSNumber *productFeatures;
@property (nonatomic, strong) NSNumber *provinceId;
@property (nonatomic, strong) NSString *redirectParams;// 统计相关数据集合
@property (nonatomic, strong) NSString *ref;// 统计数据
@property (nonatomic, strong) NSNumber *regionId;
@property (nonatomic, strong) NSNumber *screenType;
@property (nonatomic, strong) NSString *shopName;
@property (nonatomic, strong) NSNumber *showIndex;
@property (nonatomic, strong) NSNumber *siteType;
@property (nonatomic, strong) NSString *tc_ext;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *textAdTips;
@property (nonatomic, strong) NSNumber *transStatCycle;
@property (nonatomic, strong) NSString *wideScreenImgUrl;// 大图图片链接

#pragma mark - 首页精准化智能促销专题
@property (nonatomic, assign) BOOL zhuanTiType;
@property (nonatomic, copy) NSString *detailUrl; //进促销详情的 URL
@property (nonatomic, copy) NSString *topicImageUrl; // 促销图片
@property (nonatomic, copy) NSString *topicName; //促销文案
@property (nonatomic, copy) NSString *displayContent;

#pragma mark - sam会员卡打标
@property (nonatomic, strong) NSNumber *isSamMerchantProd;// 是否为sam商品 0 不是 1是
@property (nonatomic, strong) NSNumber *samMemberPrice;// sam商品的会员价

#pragma mark - 预售字段
@property (nonatomic, strong) NSNumber *isReserveProduct;

#pragma mark - 首页剁手价sam字段
@property (nonatomic, strong) NSNumber *isSam;//是否为sam商品 0 不是 1是
@property (nonatomic, strong) NSNumber *activityId;

#pragma mark - 搜索列表热卖推荐商品标识
@property (nonatomic, strong) NSNumber *onePointTongHotRecommended; // 1表示为一点通热卖推荐商品

#pragma mark- Interface
/**
 *	功能:通过promotionIdStr转换promotinIdLevelId
 *
 *	@param aPromotionId
 *
 *	@return
 */
+ (NSNumber *)promotionLevelIdWithPromotionId:(NSString *)aPromotionId;

#pragma mark - ProductVO
/**
 *  功能:此商品是否是限购商品
 *
 *  @return
 */
- (BOOL)isLimitBuy;

/**
 *  雷购商品的限购数量
 *
 *  @return
 */
- (NSNumber *)realLimitNumber;

/**
 *  此雷购商品，是否是因为超过限购数量的非促销商品
 *
 *  @return
 */
- (BOOL)isExceedLimitCount;

/**
 *	功能:字符串的促销id，转换成langePage类型的促销id。
 *
 *	@param aPromotionId
 *
 *	@return 如果不是langePageId 就返回nil
 */
+ (NSNumber *)langePageIdWithPromotionId:(NSString *)aPromotionId;

/**
 *	功能:字符串的促销id，转换成long类型的促销id。
 *  促销id的格式可能是 id_levelId_descInfo
 *	@param aPromotionId
 *
 *	@return
 */
+ (NSNumber *)nummberIdWithPromotionId:(NSString *)aPromotionId;
/**
 *	功能:是否是序列商品
 *
 *	@return
 */
- (BOOL)isSeriseProduct;

/**
 *	功能:是否是积分购买商品
 *
 *	@return
 */
- (BOOL)isIntergralBuy;

/**
 *	功能:是否是积分兑换商品
 *
 *	@return
 */
- (BOOL)isIntegralExchange;

/**
 *	功能:团购商品是否支持退换货
 *
 *	@return
 */
- (BOOL)isReturnGrouponProduct;
/**
 *	功能:是否支持退换货
 *
 *	@return
 */
- (BOOL)isReturnProduct;

/**
 *	功能:是否使用积分兑换商品
 *
 *	@return
 */
- (BOOL)isPayByPoint;

/**
 *	功能:是否是礼品卡商品
 *
 *	@return
 */
- (BOOL)isGiftCardProduct;
/**
 *	功能:是否是团购商品
 *
 *	@return
 */
- (BOOL)isGroup;

/**
 *	功能:判断此商品是否是促销商品
 *
 *	@return
 */
- (BOOL)isInPromotion;
/**
 *	功能:判断此商品是否可购买
 */
- (BOOL)isCanBuy;

/**
 *	功能:判断此商品是否参加满减活动
 *
 */
- (BOOL)isJoinCash;

/**
 *	功能:判断此商品能否参加满折活动
 *
 *	@return
 */
- (BOOL)isJoinDiscount;

/**
 *	功能:判断此商品是否有送赠品活动
 *
 *	@return
 */
- (BOOL)isJoinGift;

/**
 *	判断此商品是否参加换购活动
 *
 *	@return
 */
- (BOOL)isJoinRedemption;

/**
 *	判断此商品是否是N元N件活动商品
 */
- (BOOL)isJoinOffer;

/**
 *	功能:判断此商品是否是赠品
 *
 */
- (BOOL)isGiftProduct;

/**
 *	判断此商品是否已经售完
 *
 *	@return
 */
- (BOOL)isProductSoldOut;

/**
 *	判断此商品是否是生鲜商品
 *
 *	@return
 */
- (BOOL)isFreshProduct;

/**
 *	功能:判断此商品能否秒杀
 *
 *	@return	BOOL:表明是否可参加
 */
- (BOOL)canSecKillProduct;

/**
 *	功能:判断此商品是否是秒杀商品
 *
 *	@return
 */
- (BOOL)isSeckillProduct;

/**
 *	功能:判断是否是landingPage的商品
 *
 *	@return
 */
- (BOOL)isLandingPage;

/**
 *  功能:是否是normal promotion
 */
- (BOOL)isNormalPromotion;

/**
 *	功能:商品原价
 *
 *	@return
 */
- (NSNumber *)costPrice;
/**
 *	功能:商品的真实价格
 *       促销商品时为促销价
 *
 *	@return
 */
- (NSNumber *)realPrice;

/**
 *	功能:是否是一号店商品，判断是商城商品还是1号店商品
 *
 *	@return
 */
- (BOOL)isYihaodianProduct;
/**
 *	功能:判断在商品当前地区是否有效
 *      是否存在
 *
 *	@return
 */
- (BOOL)isVendibilityInLocal;

/**
 *  功能:转换成PromotionGift类型
 */
//- (PromotionGift *)toGift;

/**
 *  功能:判断闪购商品是否支持退换货
 */
- (BOOL)isFlashReturnProduct;

/**
 * 判断是否有服务标签
 *
 */
- (BOOL)isHaveTags;

#pragma mark - ProductVO
typedef NS_ENUM(NSUInteger, FBProductStatus) {
    /**
     *  即将开始
     */
    FBProductStatusCommingSoon,
    /**
     *  正常销售
     */
    FBProductStatusSell,
    /**
     *  剩余x件
     */
    FBProductStatusRemain,
    /**
     *  已售完
     */
    FBProductStatusSoldOut,
    /**
     *  已结束
     */
    FBProductStatusEnd
};

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
- (FBProductStatus)productStatus;


//是否显示商铺信息
- (BOOL)ShowStoreDSR;

- (NSInteger)thirdCategoryId;

- (NSInteger)topCategoryId;

#pragma mark - ProductVO
- (BOOL)isHaveStock;

- (BOOL)isShowSamsEntry;

- (BOOL)isOnSale;

- (BOOL)isPromotion;

@end
