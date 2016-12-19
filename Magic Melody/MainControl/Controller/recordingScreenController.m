//
//  recordingScreenController.m
//  Magic Melody
//
//  Created by Angela Tang on 2016-12-18.
//  Copyright © 2016 zixin. All rights reserved.
//

#import "recordingScreenController.h"
#define MaximumRecordTime 10

@interface recordingScreenController ()
{
    //for timer
    UILabel *progress;
    NSTimer *timer;
    int currSec;
    //======
}

@end

@implementation recordingScreenController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.view setBackgroundColor:[UIColor yellowColor]];
    
    progress=[[UILabel alloc] initWithFrame:CGRectMake(self.view.center.x-50, self.view.center.y -25, 100, 50)];
    progress.textColor=[UIColor blackColor];
    [progress setText:[NSString stringWithFormat:@"Time: %i", MaximumRecordTime]];
    [progress setTextAlignment:NSTextAlignmentCenter];
    [progress adjustsFontSizeToFitWidth];
    
    progress.backgroundColor=[UIColor clearColor];
    [self.view addSubview:progress];
    
    currSec= MaximumRecordTime;
    
    NSLog(@"Recording Screen Fired");
    [self start];
    
}

-(void)start
{
    timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
    
}
-(void)timerFired
{
    if(currSec>=0)
    {
        currSec -=1;
            [progress setText:[NSString stringWithFormat:@"%@%i", @"Time: ",currSec]];
    }
    else
    {
        [timer invalidate];
    }
}




-(void)viewWillDisappear:(BOOL)animated{
    NSLog(@"Recording Screen Ends");
    
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
