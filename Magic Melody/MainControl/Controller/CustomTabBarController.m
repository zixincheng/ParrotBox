//
//  CustomTabBarController.m
//  Magic Melody
//
//  Created by zixin cheng on 2016-11-24.
//  Copyright © 2016 zixin. All rights reserved.
//
#include <AudioToolbox/AudioToolbox.h>
//=====recorder
#import "AppDelegate.h"
#import "recordingScreenController.h"
#import "CroppingRecordVC.h"



#import "CustomTabBarController.h"
#import "CustomNavigationController.h"
#import "SettingViewController.h"
#import "ComposeViewController.h"
#import "LibraryViewController.h"
#import "HomePageViewController.h"

#import "ARSegmentPageController.h"
#import "RecordingTableViewController.h"
#import "SoundTableViewController.h"
#import "ComposeTableViewController.h"




#import "CustomTabBar.h"
#import "UIImage+Image.h"



#define MaximumRecordTime 10.0 //define max record time
@interface CustomTabBarController ()<CustomTabBarDelegate, ARSegmentControllerDelegate>{
    
    
    //essentials to record and normal play back and mechanism
    
    AppDelegate *global;
    
    AVAudioPlayer *SoundPlayer;
    AVAudioRecorder *SoundRecorder;
    NSArray *RecordPathComponents;
    NSURL *RecordOutputFileURL;
    
    AVAudioRecorder *saveSoundRecorder;//sound recorder foe saving
    
    NSMutableDictionary *recordSetting;
    //============
    
    //essentials for record screen
    recordingScreenController *recordScreenVC;
    
    //essential for cropping screen
    CroppingRecordVC *croppingVC;
    
    
}

@end

@implementation CustomTabBarController

#pragma mark - 第一次使用当前类的时候对设置UITabBarItem的主题
+ (void)initialize
{
    UITabBarItem *tabBarItem = [UITabBarItem appearanceWhenContainedInInstancesOfClasses:@[self]];
    
    NSMutableDictionary *dictNormal = [NSMutableDictionary dictionary];
    dictNormal[NSForegroundColorAttributeName] = [UIColor grayColor];
    dictNormal[NSFontAttributeName] = [UIFont systemFontOfSize:11];

    NSMutableDictionary *dictSelected = [NSMutableDictionary dictionary];
    dictSelected[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
    dictSelected[NSFontAttributeName] = [UIFont systemFontOfSize:11];

    [tabBarItem setTitleTextAttributes:dictNormal forState:UIControlStateNormal];
    [tabBarItem setTitleTextAttributes:dictSelected forState:UIControlStateSelected];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    [self setUpAllChildVc];

    //创建自己的tabbar，然后用kvc将自己的tabbar和系统的tabBar替换下
    CustomTabBar *tabbar = [[CustomTabBar alloc] init];
    tabbar.myDelegate = self;
    //kvc实质是修改了系统的_tabBar
    [self setValue:tabbar forKeyPath:@"tabBar"];
    
    
    //get current global info
    global = [[UIApplication sharedApplication]delegate];
    
    //==================recorder
    
    
    RecordPathComponents = [NSArray arrayWithObjects:
                            [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                            @"MyAudioMemo.aac",
                            nil];
    RecordOutputFileURL = [NSURL fileURLWithPathComponents:RecordPathComponents];
    
    // Setup audio session
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [session overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
    
    // Define the recorder setting
    recordSetting = [[NSMutableDictionary alloc] init];
    
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
    
    
    // Initiate and prepare the recorder
    SoundRecorder = [[AVAudioRecorder alloc] initWithURL:RecordOutputFileURL settings:recordSetting error:NULL];
    SoundRecorder.delegate = self;
    SoundRecorder.meteringEnabled = YES;
    [SoundRecorder prepareToRecord];
    NSLog(@"%@",RecordOutputFileURL);
    
    //======================end recorder
    
    //set the record URL to global for other view to access
    global.RecordFileURL = RecordOutputFileURL;
    [global saveContext];
    //the code above may need to move to viewwillappear
    
    

}


#pragma mark - ------------------------------------------------------------------
#pragma mark - 初始化tabBar上除了中间按钮之外所有的按钮

- (void)setUpAllChildVc
{

    
    HomePageViewController *HomeVC = [[HomePageViewController alloc] init];
    [self setUpOneChildVcWithVc:HomeVC Image:@"home_normal" selectedImage:@"home_highlight" title:@"Home"];
    
    RecordingTableViewController *recordingTable = [[RecordingTableViewController alloc] init];
    SoundTableViewController *soundTable = [[SoundTableViewController alloc] init];
    ComposeTableViewController *composeTable = [[ComposeTableViewController alloc] init];
    ARSegmentPageController *pager = [[ARSegmentPageController alloc] initWithControllers:recordingTable,soundTable,composeTable,nil];
    
     //LibraryViewController *LibVC = [[LibraryViewController alloc] init];
     [self setUpOneChildVcWithVc:pager Image:@"fish_normal" selectedImage:@"fish_highlight" title:@"Library"];
     [pager addObserver:self forKeyPath:@"segmentToInset" options:NSKeyValueObservingOptionNew context:NULL];
     
     ComposeViewController *ComposeVC = [[ComposeViewController alloc] init];
     [self setUpOneChildVcWithVc:ComposeVC Image:@"message_normal" selectedImage:@"message_highlight" title:@"Compose"];
     
     SettingViewController *SettingVC = [[SettingViewController alloc] init];
     [self setUpOneChildVcWithVc:SettingVC Image:@"account_normal" selectedImage:@"account_highlight" title:@"Setting"];
    


}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    CGFloat topInset = [change[NSKeyValueChangeNewKey] floatValue];
    NSLog(@"top inset is %f",topInset);
}
#pragma mark - 初始化设置tabBar上面单个按钮的方法

/**
 *  @author li bo, 16/05/10
 *
 *  设置单个tabBarButton
 *
 *  @param Vc            每一个按钮对应的控制器
 *  @param image         每一个按钮对应的普通状态下图片
 *  @param selectedImage 每一个按钮对应的选中状态下的图片
 *  @param title         每一个按钮对应的标题
 */
- (void)setUpOneChildVcWithVc:(UIViewController *)Vc Image:(NSString *)image selectedImage:(NSString *)selectedImage title:(NSString *)title
{
    CustomNavigationController *nav = [[CustomNavigationController alloc] initWithRootViewController:Vc];
    

    Vc.view.backgroundColor = [self randomColor];

    UIImage *myImage = [UIImage imageNamed:image];
    myImage = [myImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    //tabBarItem，是系统提供模型，专门负责tabbar上按钮的文字以及图片展示
    Vc.tabBarItem.image = myImage;

    UIImage *mySelectedImage = [UIImage imageNamed:selectedImage];
    mySelectedImage = [mySelectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    Vc.tabBarItem.selectedImage = mySelectedImage;

    Vc.tabBarItem.title = title;

    Vc.navigationItem.title = title;

    [self addChildViewController:nav];
    
}



#pragma mark - ------------------------------------------------------------------
#pragma mark - LBTabBarDelegate
//点击中间按钮的代理方法
- (void)tabBarPlusBtnClick:(CustomTabBar *)tabBar
{
    //record screen prepare
    recordScreenVC = [[recordingScreenController alloc] init];
    [self.view addSubview:recordScreenVC.view];
    [self.view bringSubviewToFront:self.tabBar];
    

    if (SoundPlayer.playing) {//stop any sound when record
        [SoundPlayer stop];
    }
    
    if (!SoundRecorder.recording) {
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setActive:YES error:nil];
        
        // Start recording
        
        [SoundRecorder record];
        
        [self performSelector:@selector(tabBarPlusBtnRelease:) withObject:self.tabBar afterDelay:MaximumRecordTime];
        //[ SoundRecorder recordForDuration:(NSTimeInterval) recordTime];
        
        
    }
    else {
        
    }

    
    /*
    LBpostViewController *plusVC = [[LBpostViewController alloc] init];
    plusVC.view.backgroundColor = [self randomColor];

    LBNavigationController *navVc = [[LBNavigationController alloc] initWithRootViewController:plusVC];

    [self presentViewController:navVc animated:YES completion:nil];
     */


}
- (void)tabBarPlusBtnRelease:(CustomTabBar *)tabBar
{
        //stop recorder when release the button
    [self.view bringSubviewToFront:self.tabBar];
    
    if(SoundRecorder.recording){//release
        [recordScreenVC.view removeFromSuperview];
        [SoundRecorder  stop];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(tabBarPlusBtnRelease:)object: self.tabBar];//cancel the performselector request previously
        
    }
    else{
        //exception cases: if button hold for <10 sec and execute this, there are something wrong
        //if == 10sec, correct
        //NSLog(@"Button held until end");
    }
    
    //Check if the record is long enough and pass to cropping
    //Idea: a fixed slider for 0.5 second. Value min:0 max: 9.5
    //eg, when 2 is selected, range of 2-2.5 is selected and ready to preview or crop
    //max is 9.5 to 10
    
    //check duration of th record
    SoundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:global.RecordFileURL error:nil];
    [SoundPlayer setDelegate:self];
    NSLog(@"%f", SoundPlayer.duration);
    
    if (SoundPlayer.duration >= 0.6){//minimum for cropping
        croppingVC = [[CroppingRecordVC alloc] init];
        [self.view addSubview:croppingVC.view];
    }
    else{//show error
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                        message:@"Records must be at least half of second long"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];

    }
    
    

}

- (UIColor *)randomColor
{
    CGFloat r = arc4random_uniform(256);
    CGFloat g = arc4random_uniform(256);
    CGFloat b = arc4random_uniform(256);
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];

}

-(NSString *)segmentTitle
{
    return @"common";
}

@end
