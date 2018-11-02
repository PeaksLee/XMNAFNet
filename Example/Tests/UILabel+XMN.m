//  UILabel+XMN.m
//  XMNAFNet
//
//  Created by  XMFraker on 2018/11/2
//  Copyright © XMFraker All rights reserved. (https://github.com/ws00801526)
//  @class      UILabel_XMN
//  @version    <#class version#>
//  @abstract   <#class description#>

#import "UILabel+XMN.h"

@implementation UILabel (XMN)

- (CGFloat)calculateHeightToFitsWidth {

    CGFloat height = self.frame.size.height;
    CGSize size = CGSizeMake(self.frame.size.width, CGFLOAT_MAX);
    if (self.attributedText.length > 0) {
        height = [self.attributedText boundingRectWithSize:size options:NSStringDrawingUsesFontLeading context:nil].size.height;
    } else if (self.text.length > 0) {
        NSDictionary *attributes = @{ NSFontAttributeName : self.font };
        CGRect frame = [self.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
        height = frame.size.height;
    }
    return height;
}

@end
