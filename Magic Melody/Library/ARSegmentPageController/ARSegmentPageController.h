//
//  ARSegmentPageController.h
//  ARSegmentPager
//
//  Created by August on 15/3/28.
//  Copyright (c) 2015年 August. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARSegmentControllerDelegate.h"
#import "ARSegmentPageHeader.h"
#import "ARSegmentPageControllerHeaderProtocol.h"

@interface ARSegmentPageController : UIViewController

@property (nonatomic, assign) CGFloat segmentHeight;
@property (nonatomic, assign) CGFloat headerHeight;
@property (nonatomic, assign) CGFloat segmentMiniTopInset;

@property (nonatomic, assign, readonly) CGFloat segmentToInset;

@property (nonatomic, strong, readonly) UIView<ARSegmentPageControllerHeaderProtocol> *headerView;

-(instancetype)initWithControllers:(UIViewController<ARSegmentControllerDelegate> *)controller,... NS_DESIGNATED_INITIALIZER NS_REQUIRES_NIL_TERMINATION;

//override this method to custom your own header view
-(UIView<ARSegmentPageControllerHeaderProtocol> *)customHeaderView;

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com