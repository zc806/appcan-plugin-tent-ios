//
//  TentShareController.h
//  YanTaiBang
//
//  Created by AppCan on 12-9-14.
//  Copyright (c) 2012年 AppCan. All rights reserved.
//

#import <UIKit/UIKit.h>
//QQ
#import "OpenSdkOauth.h"
#import "QQOpenApi.h"
// QQ分享模式


#define QQTentAppKey			@"tentAppKey"
#define QQTentAppSecret         @"tentAppSecret"
#define QQTentRedirectUri		@"tentRedirectUrl" 

//ud存储 数据
#define oauth2QQTokenKey          @"QQ_access_token"
#define oauth2QQOpenidKey         @"QQ_openid"
#define oauth2QQExpireInKey       @"QQ_expires_in"

/*
 * 获取oauth2.0票据的key
 */

#define oauth2TokenKey          @"access_token="
#define oauth2OpenidKey         @"openid="
#define oauth2OpenkeyKey        @"openkey="
#define oauth2ExpireInKey       @"expires_in="


@protocol TentShareControllerDelegate <NSObject>
-(void)QQLoginSuccess;
@end

@interface TentShareController : UIViewController<UIWebViewDelegate>{
    UIActivityIndicatorView *_indicatorView;
    UIWebView *_webView;
    OpenSdkOauth *_OpenSdkOauth;
    QQOpenApi *_QQOpenApi;
}
-(void)logIn;
-(BOOL)shareWithContent:(NSString*)inContent;
-(BOOL)shareWithImage:(NSString*)inPath andContent:(NSString*)inContent;
+(BOOL)isValid;
+(BOOL)logOut;
@property (nonatomic, assign) id<TentShareControllerDelegate> delegate;
@end


