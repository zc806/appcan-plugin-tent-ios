//
//  EUExTent.m
//  AppCan
//
//  Created by AppCan on 13-4-3.
//  Copyright (c) 2013年 AppCan. All rights reserved.
//

#import "EUExTent.h"
#import "EUtility.h"
#import "EUExBaseDefine.h"
@implementation EUExTent
@synthesize shareContent,shareImgDes,shareImgPath;

-(id)initWithBrwView:(EBrowserView *)eInBrwView{
    if (self=[super initWithBrwView:eInBrwView]) {
        
    }
    return self;
}
-(void)clean{
    self.shareContent = nil;
    self.shareImgDes = nil;
    self.shareImgPath = nil;
}
-(void)dealloc{
    self.shareContent = nil;
    self.shareImgDes = nil;
    self.shareImgPath = nil;
    [super dealloc];
}

#pragma mark - public js Fun
-(void)registerApp:(NSMutableArray*)inArguments{
    NSString *appKey = [inArguments objectAtIndex:0];
    NSString *appSecret = [inArguments objectAtIndex:1];
    NSString *registerUrl = [inArguments objectAtIndex:2];
    NSUserDefaults *ud =[NSUserDefaults standardUserDefaults];
    if (!appKey || !appSecret || !registerUrl) {
        return;
    }
    [ud setObject:appKey forKey:QQTentAppKey];
    [ud setObject:appSecret forKey:QQTentAppSecret];
    [ud setObject:registerUrl forKey:QQTentRedirectUri];
    BOOL status= [ud synchronize];
    if (status) {
        [self jsSuccessWithName:@"uexTent.cbRegisterApp" opId:0 dataType:UEX_CALLBACK_DATATYPE_INT intData:UEX_CSUCCESS];
    }
    else{
        [self jsSuccessWithName:@"uexTent.cbRegisterApp" opId:0 dataType:UEX_CALLBACK_DATATYPE_INT intData:UEX_CFALSE];
    }

}
-(void)logOut:(NSMutableArray*)inArguments{
    BOOL status=[TentShareController logOut];
    if (status) {
        [self jsSuccessWithName:@"uexTent.cbLogOut" opId:0 dataType:UEX_CALLBACK_DATATYPE_INT intData:UEX_CSUCCESS];
    }
    else{
        [self jsSuccessWithName:@"uexTent.cbLogOut" opId:0 dataType:UEX_CALLBACK_DATATYPE_INT intData:UEX_CFALSE];
    }
}
-(void)sendTextContent:(NSMutableArray*)inArguments{
    currentStatus = 1;
    NSString *content = [inArguments objectAtIndex:0];
    self.shareContent = content;
    
    if ([TentShareController isValid]) {
        TentShareController *tsc =[[TentShareController alloc] init];
        BOOL result = [tsc shareWithContent:content];
        if (result) {
            [self jsSuccessWithName:@"uexTent.cbShare" opId:0 dataType:UEX_CALLBACK_DATATYPE_INT intData:UEX_CSUCCESS];
        }
        else{
            [self jsSuccessWithName:@"uexTent.cbShare" opId:0 dataType:UEX_CALLBACK_DATATYPE_INT intData:UEX_CFALSE];
        }
        [tsc release];
    }else {
        TentShareController *tsc =[[TentShareController alloc] init];
        tsc.delegate =self;
        [tsc logIn];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:tsc];
        [EUtility brwView:meBrwView presentModalViewController:nav animated:YES];
        [tsc release];
        [nav release];
    }
}

- (void) sendImageContent:(NSMutableArray*)inArguments{
    currentStatus = 2;
    NSString *realImgPath = [self absPath:[inArguments objectAtIndex:0]];
    self.shareImgPath =realImgPath;
    if ([inArguments count]>1) {
        self.shareImgDes = [inArguments objectAtIndex:1];
    }else{
        self.shareImgDes = @"";
    }
    if ([TentShareController isValid]) {
        if ([self.shareImgPath hasPrefix:@"http"]) {
             [self jsSuccessWithName:@"uexTent.cbShare" opId:0 dataType:UEX_CALLBACK_DATATYPE_TEXT strData:@"本接口不支持http"];
        }else{
            BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:self.shareImgPath];
            if (!fileExists) {
                [self jsSuccessWithName:@"uexTent.cbShare" opId:0 dataType:UEX_CALLBACK_DATATYPE_TEXT strData:@"图片不存在"];
                return;
            }
            TentShareController *tsc =[[TentShareController alloc] init];
            BOOL result = [tsc shareWithImage:self.shareImgPath andContent: self.shareImgDes];
            if (result) {
                [self jsSuccessWithName:@"uexTent.cbShare" opId:0 dataType:UEX_CALLBACK_DATATYPE_INT intData:UEX_CSUCCESS];
            }
            else{
                [self jsSuccessWithName:@"uexTent.cbShare" opId:0 dataType:UEX_CALLBACK_DATATYPE_INT intData:UEX_CFALSE];
            }
            [tsc release];
        }
    }else {
        TentShareController *tsc =[[TentShareController alloc] init];
        tsc.delegate =self;
        [tsc logIn];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:tsc];
        [EUtility brwView:meBrwView presentModalViewController:nav animated:YES];
        [tsc release];
        [nav release];
    }
    
}

#pragma mark for delegate
#pragma mark -
#pragma mark  - ShareViewControllerDelegate
-(void)QQLoginSuccess{
    //[NSThread detachNewThreadSelector:@selector(attendAppCan) toTarget:self withObject:nil];
    if (currentStatus==1) {
        TentShareController *tsc =[[TentShareController alloc] init];
        BOOL result = [tsc shareWithContent:self.shareContent];
        if (result) {
            [self jsSuccessWithName:@"uexTent.cbShare" opId:0 dataType:UEX_CALLBACK_DATATYPE_INT intData:UEX_CSUCCESS];
        }
        else{
            [self jsSuccessWithName:@"uexTent.cbShare" opId:0 dataType:UEX_CALLBACK_DATATYPE_INT intData:UEX_CFALSE];
        }
        [tsc release];
        
    }else{
        if ([self.shareImgPath hasPrefix:@"http"]) {
            [self jsSuccessWithName:@"uexTent.cbShare" opId:0 dataType:UEX_CALLBACK_DATATYPE_TEXT strData:@"不支持http"];
        }else{
            BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:self.shareImgPath];
            if (!fileExists) {
                [self jsSuccessWithName:@"uexTent.cbShare" opId:0 dataType:UEX_CALLBACK_DATATYPE_TEXT strData:@"图片不存在"];
                return;
            }
            TentShareController *tsc =[[TentShareController alloc] init];
            BOOL result = [tsc shareWithImage:self.shareImgPath andContent: self.shareImgDes];
            if (result) {
                [self jsSuccessWithName:@"uexTent.cbShare" opId:0 dataType:UEX_CALLBACK_DATATYPE_INT intData:UEX_CSUCCESS];
            }
            else{
                [self jsSuccessWithName:@"uexTent.cbShare" opId:0 dataType:UEX_CALLBACK_DATATYPE_INT intData:UEX_CFALSE];
            }
            [tsc release];
        }
    }
}

-(void)attendAppCan{
    @autoreleasepool {
        NSString *attendUrl = @"https://open.t.qq.com/api/friends/addspecial";
        NSMutableString *paramsStr =[[[NSMutableString alloc] initWithString:@""] autorelease];
        NSUserDefaults *ud =[NSUserDefaults standardUserDefaults];
        NSString *accessToken = [ud objectForKey:oauth2QQTokenKey];
        NSString *openId = [ud objectForKey:oauth2QQOpenidKey];
        NSString *appId = [ud objectForKey:QQTentAppKey];
        [paramsStr appendFormat:@"format=json&name=zy0025&oauth_consumer_key=%@&access_token=%@&openid=%@&clientip=221.122.61.18&oauth_version=2.a&scope=xx",appId,accessToken,openId];
        NSError *error;
        NSURLResponse *theResponse;
        NSMutableURLRequest *request =[[[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:attendUrl]] autorelease];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:[paramsStr dataUsingEncoding:NSUTF8StringEncoding]];
        [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [NSURLConnection sendSynchronousRequest:request returningResponse:&theResponse error:&error];
        //if (error) {
        //    NSLog(@"error=%@",[error localizedDescription]);
        //}
        //NSHTTPURLResponse *rb = (NSHTTPURLResponse*)theResponse;
       // NSLog(@"rb=%d and header=%@",[rb statusCode],[rb allHeaderFields]);
    }
}
@end
