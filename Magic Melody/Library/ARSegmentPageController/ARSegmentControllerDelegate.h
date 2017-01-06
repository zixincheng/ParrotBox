//
//  ARSegmentControllerDelegate.h
//  ARSegmentPager
//
//  Created by August on 15/3/29.
//  Copyright (c) 2015年 August. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ARSegmentControllerDelegate <NSObject>

-(NSString *)segmentTitle;

@optional
-(UIScrollView *)streachScrollView;

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com