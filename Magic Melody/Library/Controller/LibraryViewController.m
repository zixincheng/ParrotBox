//
//  LibraryViewController.m
//  Magic Melody
//
//  Created by zixin cheng on 2016-12-05.
//  Copyright © 2016 zixin. All rights reserved.
//

#import "LibraryViewController.h"
#import "ARSegmentPageController.h"
#import "RecordingTableViewController.h"
#import "SoundTableViewController.h"
#import "ComposeTableViewController.h"
@interface LibraryViewController () <ARSegmentControllerDelegate>
@property (nonatomic, strong) ARSegmentPageController *pager;
@end

@implementation LibraryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    RecordingTableViewController *recordingTable = [[RecordingTableViewController alloc] init];
    SoundTableViewController *soundTable = [[SoundTableViewController alloc] init];
    ComposeTableViewController *composeTable = [[ComposeTableViewController alloc] init];
    ARSegmentPageController *pager = [[ARSegmentPageController alloc] initWithControllers:recordingTable,soundTable,composeTable,nil];
    self.pager = pager;
   // [self.pager addObserver:self forKeyPath:@"segmentToInset" options:NSKeyValueObservingOptionNew context:NULL];

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
