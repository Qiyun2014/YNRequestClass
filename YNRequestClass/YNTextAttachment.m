//
//  YNTextAttachment.m
//  YNRequestClass
//
//  Created by qiyun on 16/5/30.
//  Copyright © 2016年 qiyun. All rights reserved.
//

#import "YNTextAttachment.h"

@implementation YNTextAttachment

- (id)initWithImage:(UIImage *)image{
    
    if (self = [super init]) {
        
        self.image = image /*[self imageWithSize:CGSizeMake(120, 100) sourceImage:image]*/ ;
    }
    return self;
}


- (CGRect)attachmentBoundsForTextContainer:(nullable NSTextContainer *)textContainer
                      proposedLineFragment:(CGRect)lineFrag
                             glyphPosition:(CGPoint)position
                            characterIndex:(NSUInteger)charIndex NS_AVAILABLE(10_11, 7_0){
    
    CGFloat width = CGRectGetWidth(lineFrag) - textContainer.lineFragmentPadding * 2;
    
    return [self scaleImageSizeToWidth:width];
}


- (CGRect)scaleImageSizeToWidth:(CGFloat)width{
    
    CGFloat factor = width/self.image.size.width;
    return CGRectMake(0, 0, CGRectGetWidth([[[UIApplication sharedApplication] delegate] window].bounds) - 10, self.image.size.height * factor);
}

#pragma mark - 创建一个可自动调整大小的默认图片
- (UIImage *)imageWithSize:(CGSize)size sourceImage:(UIImage *)image
{
    UIView *bgView = [[UIView alloc] init];
    bgView.frame = CGRectMake(0, 0, size.width, size.height);
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    CGFloat maxSide = MAX(image.size.width, image.size.height);
    imageView.frame = CGRectMake(0,
                                 0,
                                 (size.width *1) * (image.size.width / maxSide),
                                 (size.width *1) * (image.size.height / maxSide));
    [bgView addSubview:imageView];
    imageView.center = bgView.center;
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [bgView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
