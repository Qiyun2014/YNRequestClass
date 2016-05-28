//
//  YNRequesClass.h
//  YNRequestClass
//
//  Created by qiyun on 16/5/28.
//  Copyright © 2016年 qiyun. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef id (^netwokingResponse) (id response, BOOL faild, BOOL networkAvailable);

@interface YNReques : NSObject

@property (nonatomic, copy) netwokingResponse reponseObject;    /* 服务端返回的请求结果 */
@property (nonatomic, copy, readonly) id responseSuccess;       /* 只返回成功的数据 */

- (void)networkingWithResponseResult:(netwokingResponse)response;

@end

@interface YNRequesClass : YNReques

+ (instancetype)requestShareInstance;

- (void)requestUrlstring:(NSString *)urlString parameters:(NSDictionary *)parameters;

@end


