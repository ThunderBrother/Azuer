//
//  AZKit.h
//  AZKit
//
//  Created by zhangzuming on 12/30/16.
//  Copyright © 2016 Azuer. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for AZKit.
FOUNDATION_EXPORT double AZKitVersionNumber;

//! Project version string for AZKit.
FOUNDATION_EXPORT const unsigned char AZKitVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <AZKit/PublicHeader.h>


//VO
#import "ProvinceVO.h"

//Router
#import "OTSIntent.h"
#import "OTSHandler.h"
#import "OTSRouter.h"
#import "OTSIntentContext.h"
#import "OTSAction.h"
#import "OTSIntentModel.h"

//Safe
#import "NSArray+safe.h"
#import "NSDictionary+safe.h"
#import "NSMutableArray+safe.h"
#import "NSMutableDictionary+safe.h"
#import "NSMutableString+safe.h"
#import "NSNumber+safe.h"
#import "NSString+safe.h"
#import "NSObject+Safe.h"
#import "UICollectionView+safe.h"

//Utilities
#import "OTSFuncDefine.h"
#import "OTSNotificationDefine.h"
#import "NSObject+JSONToVO.h"
#import "NSObject+Notification.h"
#import "NSObject+PerformBlock.h"
#import "NSObject+Runtime.h"
#import "NSString+ConvertType.h"
#import "NSString+MD5.h"
#import "UIDevice+IdentifierAddition.h"
#import "UIView+Frame.h"
#import "UIColor+Utility.h"
#import "UIView+Border.h"
#import "NSNumber+Format.h"
#import "UIImage+Utility.h"
#import "UIView+Loading.h"
#import "UIViewController+Loading.h"
#import "NSDate+Utility.h"
#import "NSString+Attributed.h"
#import "UIFont+Utility.h"
#import "UIImageView+Network.h"
#import "UIViewController+BackActionHandler.h"
#import "UIViewController+RefreshAction.h"
#import "UIView+BadgedNumber.h"
#import "UIButton+EnlargeArea.h"
#import "UIViewController+Switch.h"
#import "UIButton+Position.h"
#import "NSString+Frame.h"

//View
#import "OTSFPSLabel.h"
#import "OTSAlertView.h"
#import "OTSCollectionReusableView.h"
#import "OTSCollectionViewCell.h"
#import "OTSTableViewCell.h"
#import "OTSTableViewHeaderFooterView.h"
#import "OTSCyclePageView.h"
#import "OTSPageControl.h"
#import "OTSPaddingLabel.h"
#import "OTSPlaceHolderImageView.h"
#import "OTSRegionInputView.h"
#import "OTSArrayPickerInputView.h"
#import "OTSMultiLeavesPickerInputView.h"
#import "UIScrollView+PullRefresh.h"
#import "OTSImageCollectionView.h"
#import "OTSTextPageControl.h"
#import "OTSScoreGroupView.h"
#import "OTSPropertyListView.h"
#import "OTSCircleProgressView.h"
#import "OTSCircleLoadingView.h"
#import "OTSSimpleShape.h"
#import "OTSCameraMaskView.h"
#import "OTSBadgedBarButtonItem.h"

//DataCache
#import "OTSArchiveData.h"
#import "OTSCoreDataManager.h"
#import "OTSManagedObject.h"
#import "OTSFileManager.h"
#import "OTSKeychain.h"
#import "OTSKeychainDefine.h"
#import "OTSUserDefault.h"
#import "OTSUserDefaultDefine.h"

//Network
#import "OTSNetworkManager.h"
#import "OTSOperationManager.h"
#import "OTSOperationParam.h"
#import "OTSNetworkError.h"
#import "OTSNetworkLog.h"
#import "OTSReachability.h"
#import "OTSNetworkEnvironment.h"

//Objects
#import "OTSLog.h"
#import "OTSGlobalValue.h"
#import "OTSModel.h"
#import "OTSClientInfo.h"
#import "OTSUserDefault.h"
