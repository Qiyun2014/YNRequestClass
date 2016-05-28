//
//  YNRequesClass.m
//  YNRequestClass
//
//  Created by qiyun on 16/5/28.
//  Copyright © 2016年 qiyun. All rights reserved.
//

#import "YNRequesClass.h"
#import <AFNetworking/AFHTTPSessionManager.h>

#define kServersPost @"192.168.0.10:8081"

@interface _YNNetworkingRequest : AFHTTPSessionManager

+ (instancetype)shareInstance;

- (void)postRequestWithUrlString:(NSString *)urlString
                       paramters:(NSDictionary *)parameters
                  responseObject:(void (^) (id success))success
                        progress:(void (^) (CGFloat progress))progress
                    requestFaild:(void (^) (id faild))faild
                requestAvailable:(void (^) (BOOL available))available;

@end

@implementation _YNNetworkingRequest

static  _YNNetworkingRequest *networkingRequest = nil;
+ (instancetype)shareInstance;{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        networkingRequest = [[_YNNetworkingRequest alloc] initWithBaseURL:[NSURL URLWithString:kServersPost]];
        networkingRequest.requestSerializer.timeoutInterval = 10.0f;
        networkingRequest.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalAndRemoteCacheData;
    });
    return networkingRequest;
}

- (void)postRequestWithUrlString:(NSString *)urlString
                       paramters:(NSDictionary *)parameters
                  responseObject:(void (^) (id success))success
                        progress:(void (^) (CGFloat progress))progress
                    requestFaild:(void (^) (id faild))faild
                requestAvailable:(void (^) (BOOL available))available{
    
    if ([AFNetworkReachabilityManager sharedManager].isReachable){
        
        [[_YNNetworkingRequest shareInstance] POST:urlString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
            
            progress(uploadProgress.completedUnitCount/uploadProgress.totalUnitCount);
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            success(responseObject);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            faild(error);
        }];
        
    }else  available(YES);
}

@end



@implementation YNReques{
    
    
}

- (void)networkingWithResponseResult:(netwokingResponse)response{
    
    _reponseObject = response;
}

- (id)responseSuccess{
    
    if (!_reponseObject) return nil;
    
    return _reponseObject = ^(id response, BOOL success, BOOL networkAvailable){
        
        return response;
    };
}


@end


@implementation YNRequesClass

static  YNRequesClass *requestClass = nil;
+ (instancetype)requestShareInstance{
 
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        requestClass = [[YNRequesClass alloc] init];
    });
    return requestClass;
}

- (void)requestUrlstring:(NSString *)urlString parameters:(NSDictionary *)parameters{
    
    [[_YNNetworkingRequest shareInstance] postRequestWithUrlString:urlString
                                                         paramters:parameters
                                                    responseObject:^(id success) {
                                                        
                                                        self.reponseObject(success, NO, NO);

                                                    } progress:^(CGFloat progress) {
                                                        
                                                    } requestFaild:^(id faild) {
                                                        
                                                        self.reponseObject(nil, YES, NO);

                                                    } requestAvailable:^(BOOL available) {
                                                        
                                                        self.reponseObject(nil, NO, YES);

                                                    }];
}

@end
