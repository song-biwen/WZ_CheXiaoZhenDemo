//
//  WZKeFuViewController.m
//  chexiaozhen
//
//  Created by songbiwen on 16/7/1.
//  Copyright © 2016年 songbiwen. All rights reserved.
//

#import "WZKeFuViewController.h"
#import "AppKeFuLib.h" //微客服


#define KWorkgroupName @"wgdemo"

@interface WZKeFuViewController ()

@end

@implementation WZKeFuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNotification];
}


- (void)addNotification {
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(kefuLoginSucceedNotification:) name:APPKEFU_LOGIN_SUCCEED_NOTIFICATION object:nil];
    [notificationCenter addObserver:self selector:@selector(kefuWorkgroupOnlineStatusNotification:) name:APPKEFU_WORKGROUP_ONLINESTATUS object:nil];
    [notificationCenter addObserver:self selector:@selector(kefuMessageNotification:) name:APPKEFU_NOTIFICATION_MESSAGE object:nil];
    [notificationCenter addObserver:self selector:@selector(kefuDisconnectWithErrorNotification:) name:APPKEFU_NOTIFICATION_DISCONNECT_WITH_ERROR object:nil];
}

//登录成功通知
- (void)kefuLoginSucceedNotification:(NSNotification *)notification {
    
    NSNumber *isConnected = [notification object];
    if ([isConnected boolValue])
    {
        //登录成功
        self.title = @"微客服3(登录成功)";
        
        //
        //查询工作组在线状态，需要将wgdemo替换为开发者自己的 “工作组名称”，请在官方管理后台申请，地址：http://appkefu.com/AppKeFu/admin
        [[AppKeFuLib sharedInstance] queryWorkgroupOnlineStatus:KWorkgroupName];
    }
    else
    {
        //登录失败
        self.title = @"微客服3(登录失败)";
        
    }
    
}

//客服工作组在线状态
- (void)kefuWorkgroupOnlineStatusNotification:(NSNotification *)notification {
    
    NSDictionary *dict = [notification userInfo];
    
    //客服工作组名称
    NSString *workgroupName = [dict objectForKey:@"workgroupname"];
    
    //客服工作组在线状态
    NSString *status   = [dict objectForKey:@"status"];
    
    NSLog(@"%s workgroupName:%@, status:%@", __PRETTY_FUNCTION__, workgroupName, status);
    
    //
    if ([workgroupName isEqualToString:KWorkgroupName]) {
        
        //客服工作组在线
        if ([status isEqualToString:@"online"])
        {
            NSLog(@"在线");
        }
        //客服工作组离线
        else
        {
            NSLog(@"离线");
        }
        
    }
    
}

//消息通知
- (void)kefuMessageNotification:(NSNotification *)notification {
    
    KFMessageItem *msgItem = [notification object];
    
    //接收到来自客服的消息
    if (!msgItem.isSendFromMe) {
        
        //
        NSLog(@"消息时间:%@, 工作组名称:%@, 发送消息用户名:%@",
              msgItem.timestamp,
              msgItem.workgroupName,
              msgItem.username);
        
        //文本消息
        if (KFMessageTypeText == msgItem.messageType) {
            
            NSLog(@"文本消息内容：%@", msgItem.messageContent);
        }
        //图片消息
        else if (KFMessageTypeImageHTTPURL == msgItem.messageType)
        {
            NSLog(@"图片消息内容：%@", msgItem.messageContent);
        }
        //语音消息
        else if (KFMessageTypeSoundHTTPURL == msgItem.messageType)
        {
            NSLog(@"语音消息内容：%@", msgItem.messageContent);
        }
    }

}


//无法连接服务器报错
- (void)kefuDisconnectWithErrorNotification:(NSNotification *)notification {
    self.title = @"微客服3(网络连接失败)";
}

//电商客服
- (IBAction)ecAction {
    
    [[AppKeFuLib sharedInstance] pushChatViewController:self.navigationController
                                      withWorkgroupName:KWorkgroupName
                                 hideRightBarButtonItem:NO
                             rightBarButtonItemCallback:nil
                                 showInputBarSwitchMenu:NO
                                  withLeftBarButtonItem:nil
                                          withTitleView:nil
                                 withRightBarButtonItem:nil
                                        withProductInfo:nil
                             withLeftBarButtonItemColor:nil
                               hidesBottomBarWhenPushed:FALSE
                                     showHistoryMessage:NO
                                           defaultRobot:FALSE
                                               mustRate:FALSE
                                    withKefuAvatarImage:[UIImage imageNamed:@"kefu_icon"]
                                    withUserAvatarImage:[UIImage imageNamed:@"user_icon"]
     
     //下面5个参数专为显示商品信息设置，具体含义可以参考AppKeFuLib.h文件里面对接口的介绍
                                    shouldShowGoodsInfo:TRUE
                                  withGoodsImageViewURL:@"http://appkefu.com/AppKeFu/images/dingyue.jpg"
                                   withGoodsTitleDetail:@"商品信息商品简介商品简介商品信息商品简介商品简介商品信息商品简介商品简介"
                                         withGoodsPrice:@"￥200000.00"
                                           withGoodsURL:@"http://appkefu.com"
                                    withGoodsCallbackID:@"goodsCallbackId"
                               goodsInfoClickedCallback:^(NSString *goodsCallbackId) {
                                   //点击商品详情区域会触发此回调函数
                                   NSLog(@"%s this is: %@", __PRETTY_FUNCTION__, goodsCallbackId);
                               }
     
                             httpLinkURLClickedCallBack:^(NSString *url) {
                                 
                                 NSLog(@"f点击了链接%@",url);
                             }
                         faqButtonTouchUpInsideCallback:^(){
                             
                             NSLog(@"faqButtonTouchUpInsideCallback, 自定义FAQ常见问题button回调，可在此打开自己的常见问题FAQ页面");
                             
                         }];
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
