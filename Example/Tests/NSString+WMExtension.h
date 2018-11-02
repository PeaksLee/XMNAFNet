//  NSString+WMExtension.h
//  XMNAFNet
//
//  Created by  XMFraker on 2018/11/2
//  Copyright © XMFraker All rights reserved. (https://github.com/ws00801526)
//  @class      NSString_WMExtension
//  @version    <#class version#>
//  @abstract   <#class description#>

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (WMExtension)

- (CGSize)sizeToFitsSize:(CGSize)size font:(UIFont *)font;

@end

NS_ASSUME_NONNULL_END
