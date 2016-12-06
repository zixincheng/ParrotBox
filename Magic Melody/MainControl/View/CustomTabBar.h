//
//  CustomTabBar.h
//  Magic Melody
//
//  Created by zixin cheng on 2016-11-24.
//  Copyright © 2016 zixin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomTabBar;

@protocol CustomTabBarDelegate <NSObject>
@optional
- (void)tabBarPlusBtnClick:(CustomTabBar *)tabBar;
@end


@interface CustomTabBar : UITabBar

/** tabbar的代理 */
@property (nonatomic, weak) id<CustomTabBarDelegate> myDelegate ;

@end