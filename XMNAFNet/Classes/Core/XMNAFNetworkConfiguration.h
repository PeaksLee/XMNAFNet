//
//  XMNAFNetworkConfiguration.h
//  XMNAFNetworkDemo
//
//  Created by XMFraker on 16/4/22.
//  Copyright © 2016年 XMFraker. All rights reserved.
//

#ifndef XMNAFNetworkConfiguration_h
#define XMNAFNetworkConfiguration_h

FOUNDATION_EXTERN NSString * _Nullable XMNAF_MD5(NSString * _Nonnull str);
FOUNDATION_EXTERN NSError * _Nonnull kXMNAFNetworkError(NSInteger code, NSString * __nullable message);
FOUNDATION_EXPORT NSString *__nonnull const kXMNAFNetworkErrorDomain;

FOUNDATION_EXPORT NSString *__nonnull const kXMNAFNetworkDidCompletedNotification;

#endif /* XMNAFNetworkConfiguration_h */
