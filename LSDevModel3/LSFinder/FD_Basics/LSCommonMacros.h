//
//  LSCommonMacros.h
//  LSDevModel3
//
//  Created by Sen on 16/2/19.
//  Copyright © 2016年 sen. All rights reserved.
//

#ifndef LSCommonMacros_h
#define LSCommonMacros_h


#pragma mark - mark

#define kUrlScheme                      @"tsouXFJS"

//友盟
#define kUmKey          @"56f8a35267e58e941e001423"

//个推
#define kGtAppId        @"WAqvGGJmMb8GAZlBbo4PB5"   //测试-WAqvGGJmMb8GAZlBbo4PB5 正式-mCZSGFH4f9AmIXUfFfzOz2
#define kGtAppkey       @"I1ab8xLoCw5Wvu8rOsyCA1"   //测试-I1ab8xLoCw5Wvu8rOsyCA1 正式-6RfQC2rknf7epJtOTTmvz7
#define kGtAppSecret    @"X1VWrAW66GAr2K0kIHJhD9"   //测试-X1VWrAW66GAr2K0kIHJhD9 正式-tfQqoS8ew76WCTfxv3v7P3

#define kMark_currServer                @"CURRSERVER"           //
#define kMark_requestApis               @"REQUESTAPIS"          //

#define kMark_userCookie                @"ticket"          //登录凭证

#pragma mark - noti
#define kNoti_debugTool                 @"NOTI_debugtool"       //
#define kNoti_cebianSelect              @"NOTI_cebianSelect"    //
#define kNoti_userlogin                 @"NOTI_userlogin"       //
#define kNoti_userlogout                @"NOTI_userlogout"      //

#pragma mark - app相关

//app名称
#define kApp_name           [kLSBundle infoDictionary][@"CFBundleName"]
#define kApp_downUrl        @"http://app.1035.mobi/kViJkz"
#define kApp_detail         @"iOS轻量级开发框架是一款具备主流App功能，如网络请求、导航风格、分享、推送、支付等，和常用开发小技巧，适合初级开发者使用。"

#pragma mark - 尺寸

#define kHeight_statusBar   20
#define kHeight_navBar      64
#define kHeight_tabBar      48

#define kSCREEN_RECT        ([UIScreen mainScreen].bounds)
#define kSCREEN_WIDTH       ([UIScreen mainScreen].bounds.size.width)
#define kSCREEN_HEIGHT      ([UIScreen mainScreen].bounds.size.height)

//欢迎页
#define kMark_firstWelcome    @"firstWelcom"

#pragma mark - 状态栏 & 导航栏

//状态栏文字黑色
#define kStatusBarStyleDefault          [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault

//状态栏文字白色
#define kStatusBarStyleLightContent     [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent

#pragma mark - Path

//当前服务器
#define kHOST_main                      [[NSUserDefaults standardUserDefaults] objectForKey:kMark_currServer]
#define kHOST_and(A)                    [NSString stringWithFormat:@"%@%@",kHOST_main,A]

#pragma mark - 其他

//内容背景颜色
#define kColor_contentView                [UIColor colorWithRed:0.976 green:0.976 blue:0.980 alpha:1]

//导航栏背景颜色
#define kColor_navBar(A)                  [self.navigationController.navigationBar setBarTintColor:A]

//渐变颜色
#define kColor_navBar1(A,B)               [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithPatternImage:[LSFactory fc_backgroundImageFromColor:A toColor:B frame:self.navigationController.navigationBar.bounds]]]

//line 颜色
#define kColor_line                     [UIColor colorWithRed:0.902 green:0.902 blue:0.902 alpha:1]

//app主题色
#define kColor_themeWithAlpha(A)        [UIColor colorWithRed:0.345 green:0.400 blue:1.000 alpha:A]

//价格颜色
#define kColor_price                    [UIColor colorWithRed:0.988 green:0.376 blue:0.141 alpha:1]

//导航栏标题颜色
#define kColor_navbarTitle(A)           [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18],NSForegroundColorAttributeName:A}]

//导航栏按钮颜色
#define kColor_navbarTintColor(A)       [self.navigationController.navigationBar setTintColor:A]

//占位图
#define kImage_placeHolder              [UIImage imageNamed:@"placeholderimage.png"]

//NotFound
#define kNotFoundObj(A)                 [NSString stringWithFormat:@"未指定(%@)",A]

//动画时间
#define kAnimationDurationTime          0.35

//NSUserDefaults
#define kLSUserDefaults                 [NSUserDefaults standardUserDefaults]

//NSBundle
#define kLSBundle                       [NSBundle mainBundle]


#pragma mark - 设备系统

//设备系统
#define kDevice_sysVersion              ([[UIDevice currentDevice] systemVersion])

#pragma mark - 输出

#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DLog(...)
#endif


#define kAPI_userGetRegCode             @"app/user/sendRegCode.do"  //获取验证码
#define kAPI_userLogin                  @"app/user/login.do"    //登录
#define kAPI_userInfo                   @"app/user/getUserInfo.do"  //获取个人信息
#define kAPI_userLogout                 @"app/user/logout.do"   //登出

#define kAPI_userRegister               @"app/user/userRegister.do" //注册

#define kAPI_funcUploadPic              @"app/user/saveAvatar.do"   //上传图片

#define kAPI_userEditInfo               @"app/user/editUserInfo.do"         //个人信息修改

#define kAPI_userEditPsw                @"app/user/editPassword.do"         //修改密码
#define kAPI_userFindPsw                @"app/user/retrievePassword.do"     //找回密码

#define kAPI_userFankui                 @"app/appcenter/commitFeedback.do"  //意见反馈
#define kAPI_adboutApp                  @"app/appcenter/baseinfo.do"        //关于我们

#define kAPI_ads                        @"app/ad/getAds"                    //获取广告

#define kAPI_spActiv                    @"app/promotions/getSpecialActiv.do"    //特殊活动商品列表
#define kAPI_spActivDetail              @"app/promotions/getActGoodsDetail.do"  //详情


#define kAPI_tuangouGoods               @"app/groupon/getGoodsList.do"      //团购商品
#define kAPI_tuangouItem                @"app/groupon/classifySec.do"       //团购分类
#define kAPI_tuangouDetail              @"app/groupon/getGoodsDetail.do"    //团购详情
#define kAPI_tuangouCom                 @"app/groupon/getCommentList.do"    //团购评论列表

#define kAPI_shopItem                   @"app/goods/classifyFirst.do"       //商城一级栏目
#define kAPI_shopSecItem
#define kAPI_shopGoodList               @"app/goods/goodsList.do"           //分类下的商品
#define kAPI_goodDetail                 @"app/goods/goodsDetailBase.do"     //商品资料
#define kAPI_goodWebDetail              @"app/goods/goodsDetailIntro.do"     //商品富文本介绍
#define kAPI_goodCom                    @"app/goods/goodsDetailComment.do"  //商品评论

#define kAPI_giftWebUrl                 @"app/lottery/turntable.do?ticket="         //每日抽奖

#define kAPI_tools                      @"app/tools/listTools.do"       //便民工具

#define kAPI_zixunSecItem               @"app/article/listArtClassifys.do"  //资讯一级分类
#define kAPI_zixunArticleList           @"app/article/listArticle.do"       //分类下的资讯列表
#define kAPI_articleDetail              @"app/article/articleDetail.do"     //资讯详情
#define kAPI_articleCom                 @"app/comment/getComment.do"    //资讯评论
#define kAPI_articleAddCom              @"app/comment/publishComment.do"     //资讯添加评论

#define kAPI_PzixunSecItem              @"app/specialArticle/specialClassifySec.do"     //特殊资讯一级分类
#define kAPI_PzixunArticleList          @"app/specialArticle/listSpecialArticle.do"     //资讯列表
#define kAPI_ParticleDetail             @"app/specialArticle/specialArticleDetail.do"   //详情

#define kAPI_collectAdd                 @"app/collection/collect.do"    //添加收藏
#define kAPI_collectList                @"app/collection/getCollectionList.do"  //收藏列表
#define kAPI_collectDelete              @"app/collection/removeCollection.do"   //删除收藏

#define kAPI_userComList                @"app/comment/getMyComment.do"  //用户评论列表

#define kAPI_carList                    @"app/shopping/myCart.do"   //购物车列表
#define kAPI_carAdd                     @"app/shopping/addcart.do"  //加入购物车
#define kAPI_carDelete                  @"app/shopping/delcart.do"  //删除购物车的东西


#define kAPI_orderZonMoney              @"app/order/getTotAmount.do"    //订单总价
#define kAPI_orderPay                   @"app/pay/payOrder.do"      //订单支付

#define kAPI_orderSubmit                @"app/order/submitOrder.do" //提交订单
#define kAPI_orderList                  @"app/order/myOrder.do"     //订单列表
#define kAPI_orderDetail                @"app/order/orderDetail.do" //订单详情
#define kAPI_orderCancel                @"app/order/cancleOrder.do" //订单取消
#define kAPI_orderDelete                @"app/order/removeMainOrder.do" //订单删除
#define kAPI_orderSure                  @"app/order/confirmReceipt.do"  //确认收货
#define kAPI_orderComment               @"app/order/orderComment.do"    //订单评价

#define kAPI_orderBackpay               @"app/order/applyRefund.do"     //申请退款
#define kAPI_orderBackpayCancel         @"app/order/cancleRefund.do"    //取消退款
#define kAPI_orderBackpayInfo           @"app/order/getRefundInfo.do"   //获取退款信息
#define kAPI_orderBackpayStuff          @"app/order/refundDelivery.do"  //准备退货，提交快递信息


#define kAPI_kuaidi                     @"app/express/getExpressCompany.do" //获取快递公司

#define kAPI_orderTuangouSubmit         @"app/groupon/takeOrder.do"         //团购订单提交
#define kAPI_orderTuangouList           @"app/groupon/myOrder.do"           //团购订单列表
#define kAPI_orderTuangouDetail         @"app/groupon/getOrderDetail.do"    //团购订单详情

#define kAPI_orderTuangouDelete         @"app/groupon/removeOrder.do"       //删除团购订单（即取消）
#define kAPI_orderTuangouBackpay        @"app/groupon/applyRefund.do"       //申请退款
#define kAPI_orderTuangouBackpayInfo    @"app/groupon/getRefund.do"         //获取退款信息
#define kAPI_orderTuangouBackpayCancel  @"app/groupon/cancelRefund.do"      //取消退款
#define kAPI_orderTuangouComment        @"app/groupon/commentGoods.do"      //评价

#define kAPI_addressList                @"app/address/userAddr.do"  //地址列表
#define kAPI_addressSave                @"app/address/saveAddress.do"   //修改/添加地址
#define kAPI_addressDelete              @"app/address/removeAddressById.do" //删除地址
#define kAPI_addressDefault             @"app/address/userDefaultAddr.do"   //获取默认收货地址

#define kAPI_voteList                   @"app/vote/voteList.do"     //投票列表
#define kAPI_voteDetail                 @"app/vote/voteDetail.do"   //投票内容
#define kAPI_voteAdd                    @"app/vote/addVote.do"      //提交投票


#define kAPI_weather                @"Weather/Weather" //天气
#define kAPI_area                   @"app/area/getArea.do"  //省市区




#endif /* LSCommonMacros_h */
