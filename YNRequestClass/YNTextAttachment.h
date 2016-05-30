//
//  YNTextAttachment.h
//  YNRequestClass
//
//  Created by qiyun on 16/5/30.
//  Copyright © 2016年 qiyun. All rights reserved.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YNTextAttachment : NSTextAttachment


- (id)initWithImage:(UIImage *)image;

- (CGRect)attachmentBoundsForTextContainer:(nullable NSTextContainer *)textContainer
                      proposedLineFragment:(CGRect)lineFrag
                             glyphPosition:(CGPoint)position
                            characterIndex:(NSUInteger)charIndex NS_AVAILABLE(10_11, 7_0);

@end

NS_ASSUME_NONNULL_END
