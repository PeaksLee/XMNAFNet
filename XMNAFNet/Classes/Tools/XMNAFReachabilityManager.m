//
//  XMNAFReachabilityManager.m
//  XMNAFNetworkDemo
//
//  Created by XMFraker on 16/7/13.
//  Copyright © 2016年 XMFraker. All rights reserved.
//

#import "XMNAFReachabilityManager.h"
#import <RealReachability/RealReachability.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import "XMNAFNetworkConfiguration.h"

NSString *kXMNAFReachabilityStatusChangedNotification = @"com.XMFraker.XMNAFNetwork.kXMNAFReachabilityStatusChangedNotification";
NSString *kXMNAFReachabilityStatusKey = @"com.XMFraker.XMNAFNetwork.kXMNAFReachabilityStatusKey";
NSString *kXMNAFReachabilityStatusStringKey = @"com.XMFraker.XMNAFNetwork.kXMNAFReachabilityStatusStringKey";

@interface XMNAFReachabilityManager ()

@property (nonatomic,strong) RealReachability *reachability;

@property (nonatomic, assign) XMNAFReachablityStatus lastStatus;
/** 是否正在监听 */
@property (nonatomic,assign, getter=isMonitoring) BOOL monitoring;

@end

@implementation XMNAFReachabilityManager

#pragma mark - Life

+ (instancetype)sharedManager {
    static id manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[[self class] alloc] init];
    });
    return manager;
}

- (void)dealloc { [self stopMonitoring]; }

#pragma mark - Methods

- (void)startMonitoring {

    [self startMonitoringWithURL:nil delegate:nil handler:nil];
}

- (void)startMonitoringWithURL:(NSURL *)URL {

    [self startMonitoringWithURL:URL delegate:nil handler:nil];
}

- (void)startMonitoringWithURL:(NSURL *)URL handler:(XMNAFReachabilityStatusChangedHandler)handler {
    
    [self startMonitoringWithURL:URL delegate:nil handler:handler];
}

- (void)startMonitoringWithURL:(NSURL *)URL delegate:(id<XMNAFReachabilityDelegate>)delegate {
    
    [self startMonitoringWithURL:URL delegate:delegate handler:nil];
}

- (void)startMonitoringWithURL:(NSURL *)URL
                      delegate:(id<XMNAFReachabilityDelegate>)delegate
                       handler:(XMNAFReachabilityStatusChangedHandler)handler {
    
    
    if (self.isMonitoring) { [self stopMonitoring]; }
    
    self.delegate = delegate;
    self.statusDidChangedBlock = handler;
    self.reachability = [[RealReachability alloc] init];
    self.reachability.hostForPing = URL.host ? : @"www.baidu.com";
    self.reachability.hostForCheck = URL.host ? : @"www.baidu.com";
    /** 注册监听函数 */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleStatusChanged:) name:kRealReachabilityChangedNotification object:nil];
    [self.reachability startNotifier];
    self.lastStatus = self.status;
    self.monitoring = YES;
}

- (void)stopMonitoring {
    
    if (!self.isMonitoring) { return; }
    
    /** 移除监听函数 */
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kRealReachabilityChangedNotification object:nil];
    [self.reachability stopNotifier];
    self.reachability = nil;
    self.monitoring = NO;
}

#pragma mark - Notification Events

- (void)handleStatusChanged:(NSNotification *)notification {

    if (self.lastStatus != self.status) {
        //使用代理回调
        if (self.delegate && [self.delegate respondsToSelector:@selector(statusDidChanged:)]) {
            [self.delegate statusDidChanged:self.status];
        }
        
        //如果状态发生变化,发送通知
        NSDictionary *userInfo = @{ kXMNAFReachabilityStatusKey:@(self.status), kXMNAFReachabilityStatusStringKey:self.statusString };
        [[NSNotificationCenter defaultCenter] postNotificationName:kXMNAFReachabilityStatusChangedNotification object:self userInfo:userInfo];
        
        /** block回调 */
        self.statusDidChangedBlock ? self.statusDidChangedBlock(self.status) : nil;
        
        /** 修改上次的状态 */
        self.lastStatus = self.status;
    }
}

#pragma mark - Getters

- (XMNAFReachablityStatus)status {
    
    XMNAFReachablityStatus status = (ReachabilityStatus)[self.reachability currentReachabilityStatus];
    if (status == RealStatusViaWWAN) {
        switch (self.reachability.currentWWANtype) {
            case WWANType4G: return XMNAFReachablityStatus4G;
            case WWANType3G: return XMNAFReachablityStatus3G;
            case WWANType2G: return XMNAFReachablityStatus2G;
            default: return XMNAFReachablityStatusWWAN;
        }
    } else if (status == RealStatusViaWiFi) {
        return XMNAFReachablityStatusWifi;
    } else {
        return XMNAFReachablityStatusUnknown;
    }
}

- (NSString *)statusString {
    
    switch (self.status) {
        case XMNAFReachablityStatus2G:
            return @"2G";
        case XMNAFReachablityStatus3G:
            return @"3G";
        case XMNAFReachablityStatus4G:
            return @"4G";
        case XMNAFReachablityStatusWifi:
            return @"WiFi";
        case XMNAFReachablityStatusWWAN:
            return @"WWAN";
        default:
            return @"unknown";
    }
}

/**
 *  @brief 是否正在监听中
 *
 */
- (BOOL)isMonitoring { return _monitoring; }

- (BOOL)isWifiEnable { return self.status == XMNAFReachablityStatusWifi; }

- (BOOL)isNetworkEnable { return self.status != XMNAFReachablityStatusUnknown; }

- (BOOL)isHighSpeedNetwork {
    return self.status == XMNAFReachablityStatus4G || self.status == XMNAFReachablityStatusWifi || self.status == XMNAFReachablityStatus3G;
}

#pragma mark - Class Methods

/**
 *  @brief wifi是否可用
 */
+ (BOOL)isWifiEnable { return [XMNAFReachabilityManager sharedManager].isWifiEnable; }

/**
 *  @brief 网络是否可用
 */
+ (BOOL)isNetworkEnable { return [XMNAFReachabilityManager sharedManager].isNetworkEnable; }

/**
 *  @brief 是否有告诉网络可用
 */
+ (BOOL)isHighSpeedNetwork { return [XMNAFReachabilityManager sharedManager].isHighSpeedNetwork; }

@end
