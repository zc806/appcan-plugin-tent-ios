//
//  TentShareController.m
//  AppCan
//
//  Created by AppCan on 12-9-14.
//  Copyright (c) 2012年 AppCan. All rights reserved.
//

#import "TentShareController.h"

@interface TentShareController ()

@end

@implementation TentShareController
@synthesize  delegate = _delegate;
#pragma mark -
#pragma mark lifeCircle
#pragma mark -
- (void)dealloc {
	//for view
    if (_webView) {
        [_webView removeFromSuperview];
        [_webView release];
        _webView = nil;
    }
	//for data
	if (_QQOpenApi) {
        [_QQOpenApi release];
        _QQOpenApi = nil;
    }
    if (_OpenSdkOauth) {
        [_OpenSdkOauth release];
        _OpenSdkOauth = nil;
    }
    [super dealloc];
}

- (void)viewDidUnload {
	[super viewDidUnload];
	//for view
	[_indicatorView release];
	_indicatorView = nil;
    if (_webView) {
        [_webView removeFromSuperview];
        [_webView release];
        _webView = nil;
    }
	//for data
    if (_QQOpenApi) {
        [_QQOpenApi release];
        _QQOpenApi = nil;
    }
    if (_OpenSdkOauth) {
        [_OpenSdkOauth release];
        _OpenSdkOauth = nil;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = @"腾讯微博";
	self.view.backgroundColor = [UIColor whiteColor];
	[self initData];
	[self initNavBtns];
	[self initViews];
	[self showIndicator:NO];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
// for views
#pragma mark -
#pragma mark for views
#pragma mark -
- (void)initNavBtns {
    self.navigationController.navigationBarHidden = NO;
    UIBarButtonItem *leftBar =[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonSystemItemCancel target:self action:@selector(leftNavBtnClicked)];
    self.navigationItem.leftBarButtonItem = leftBar;
}

- (void)initViews {	

}


- (void)showIndicator:(BOOL)show_ {
	if (show_) {
		if (!_indicatorView) {
			_indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
			_indicatorView.frame = CGRectMake(150, 190, 20, 20);
			[_indicatorView startAnimating];
		}
		[self.view addSubview:_indicatorView];
	}
	else {
		[_indicatorView removeFromSuperview];
	}	
}

#pragma mark -
#pragma mark for event
#pragma mark -
- (void)leftNavBtnClicked {
    if (_webView) {
        [_webView removeFromSuperview];
    }
    [self dismissModalViewControllerAnimated:YES];
    
}

- (void)rightNavBtnClicked {
}

- (void)titleNavBtnClicked {
}

#pragma mark -
#pragma mark for data
#pragma mark -
- (void)initData {
}

- (void)cleanData {
}
#pragma mark -
#pragma mark for QQ--share
#pragma mark -
-(void)webViewShow{
    CGRect bounds = [[UIScreen mainScreen] bounds];
    _webView = [[UIWebView alloc] initWithFrame:bounds];
    _webView.scalesPageToFit = YES;
    _webView.userInteractionEnabled = YES;
    _webView.delegate = self;
    _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_webView];
}
-(void)logIn{
    //授权模式
    if (!_OpenSdkOauth) {
        NSUserDefaults *ud =[NSUserDefaults standardUserDefaults];
        NSString *appKey =[ud objectForKey:QQTentAppKey];
        NSString *appSecret =[ud objectForKey:QQTentAppSecret];
        NSString *redirectUrl =[ud objectForKey:QQTentRedirectUri];
        _OpenSdkOauth = [[OpenSdkOauth alloc] initAppKey:appKey appSecret:appSecret redirectUri:redirectUrl];
        _OpenSdkOauth.oauthType = InWebView;
        //必须配置appkey,否则影响使用
        [self webViewShow];
    }
    [_OpenSdkOauth doWebViewAuthorize:_webView];
}
+(BOOL)isValid{
    NSUserDefaults *ud =[NSUserDefaults standardUserDefaults];
    id tokenkey = nil;
    id openid = nil;
    id expireDate = nil;
    tokenkey =[ud objectForKey:oauth2QQTokenKey];
    openid =[ud objectForKey:oauth2QQOpenidKey];
    expireDate =[ud objectForKey:oauth2QQExpireInKey];
    if (!tokenkey || !openid || !expireDate) {
        return NO;
    }
    NSDate *curDate = [NSDate date];
    NSDate *earlyDate =[curDate earlierDate:(NSDate*)expireDate];
    if ([earlyDate isEqualToDate:curDate]) {
        return YES;
    }
    return NO;
}
+(BOOL)logOut{
    NSUserDefaults *ud =[NSUserDefaults standardUserDefaults];
    [ud removeObjectForKey:oauth2QQTokenKey];
    [ud removeObjectForKey:oauth2QQOpenidKey];
    [ud removeObjectForKey:oauth2QQExpireInKey];
    return [ud synchronize];
}


-(BOOL)shareWithContent:(NSString*)inContent{
    NSString *content =[NSString stringWithString:inContent];
	float longitude = 0;
	float latitude = 0;
    
    //发表微博
    if (!_QQOpenApi) {
        NSUserDefaults *ud =[NSUserDefaults standardUserDefaults];
        id tokenkey = nil;
        id openid = nil;
        tokenkey =[ud objectForKey:oauth2QQTokenKey];
        openid =[ud objectForKey:oauth2QQOpenidKey];
        NSString *appKey =[ud objectForKey:QQTentAppKey];
        NSString *appSecret =[ud objectForKey:QQTentAppSecret];
        //NSString *redirectUrl =[ud objectForKey:QQTentRedirectUri];
        _QQOpenApi = [[QQOpenApi alloc] initForApi:appKey appSecret:appSecret accessToken:tokenkey accessSecret:nil openid:openid oauthType:InWebView];
    }
    BOOL shareOk = [_QQOpenApi publishWeibo:content jing:[NSString stringWithFormat:@"%f", longitude] wei:[NSString stringWithFormat:@"%f", latitude] format:@"json" clientip:@"221.122.61.18" syncflag:@"0"];
    
    return shareOk;
}

-(BOOL)shareWithImage:(NSString*)inPath andContent:(NSString*)inContent {
	NSString *path = [NSString stringWithString:inPath];
    NSString *content =[NSString stringWithString:inContent];
    //发表微博
    if (!_QQOpenApi) {
        NSUserDefaults *ud =[NSUserDefaults standardUserDefaults];
        id tokenkey = nil;
        id openid = nil;
        
        tokenkey =[ud objectForKey:oauth2QQTokenKey];
        openid =[ud objectForKey:oauth2QQOpenidKey];
        NSString *appKey =[ud objectForKey:QQTentAppKey];
        NSString *appSecret =[ud objectForKey:QQTentAppSecret];
        _QQOpenApi = [[QQOpenApi alloc] initForApi:appKey appSecret:appSecret accessToken:tokenkey accessSecret:nil openid:openid oauthType:InWebView];
    }  
    
	//BOOL result = [_QQOpenApi publishWeiboWithImage:path weiboContent:content jing:[NSString stringWithFormat:@"%f", longitude] wei:[NSString stringWithFormat:@"%f", latitude] format:@"json" clientip:@"221.122.61.18" syncflag:@"0"];
    BOOL result = [_QQOpenApi publishWeiboWithImage:path weiboContent:content jing:@"0" wei:@"0" format:@"json" clientip:@"221.122.61.18" syncflag:@"0"];
    return  result;
}


#pragma mark -
#pragma mark for delegate
#pragma mark -

#pragma mark for UIWebViewDelegate
/*
 * 当前网页视图被指示载入内容时得到通知，返回yes开始进行加载
 */
- (BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSURL *url = [request URL];
	NSRange start = [[url absoluteString] rangeOfString:oauth2TokenKey];
	if (start.location!=NSNotFound) {
		NSString *accessToken = [OpenSdkBase getStringFromUrl:[url absoluteString] needle:oauth2TokenKey];
        NSString *openid = [OpenSdkBase getStringFromUrl:[url absoluteString] needle:oauth2OpenidKey];
        // NSString *openkey = [OpenSdkBase getStringFromUrl:[url absoluteString] needle:oauth2OpenkeyKey];
		NSString *expireIn = [OpenSdkBase getStringFromUrl:[url absoluteString] needle:oauth2ExpireInKey];
		NSDate *expirationDate =nil;
		if (expireIn!=nil) {
			int expVal = [expireIn intValue];
			if (expVal==0) {
				expirationDate = [NSDate distantFuture];
			}else{
				expirationDate = [NSDate dateWithTimeIntervalSinceNow:expVal];
			}
			NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            [ud setObject:accessToken forKey:oauth2QQTokenKey];
            [ud setObject:openid forKey:oauth2QQOpenidKey];
            [ud setObject:expirationDate forKey:oauth2QQExpireInKey];

			[ud synchronize];
		}
        //分享登录成功
        [self dismissModalViewControllerAnimated:YES];
		if (_delegate && [_delegate respondsToSelector:@selector(QQLoginSuccess)] ) {
            [_delegate QQLoginSuccess];
        }
		
		return NO;
	}else {
		start = [[url absoluteString] rangeOfString:@"code="];
        if (start.location != NSNotFound) {
            [_OpenSdkOauth refuseOauth:url];
        }
	}
	return YES;
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
	[self showIndicator:YES];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView {
    [self showIndicator:NO];
    NSString *url = _webView.request.URL.absoluteString;
}

/*
 * 页面加载失败时得到通知，可根据不同的错误类型反馈给用户不同的信息
 */
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self showIndicator:NO];
    if (!([error.domain isEqualToString:@"WebKitErrorDomain"] && error.code == 102)) {
        [_OpenSdkOauth oauthDidFail:InWebView success:NO netNotWork:YES];
        [_webView removeFromSuperview];
        
	}
}

@end
