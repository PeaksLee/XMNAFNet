//  NSString+WMExtension.m
//  XMNAFNet
//
//  Created by  XMFraker on 2018/11/2
//  Copyright © XMFraker All rights reserved. (https://github.com/ws00801526)
//  @class      NSString_WMExtension
//  @version    <#class version#>
//  @abstract   <#class description#>

#import "NSString+WMExtension.h"

@implementation NSString (WMExtension)

- (CGSize)sizeToFitsSize:(CGSize)size font:(UIFont *)font {
    
    NSDictionary *attributes = @{ NSFontAttributeName : font ? : [UIFont systemFontOfSize:14.f] };
    CGRect frame = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    return frame.size;
}

@end
