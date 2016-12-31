//
//  CroppingRecordVC.m
//  Magic Melody
//
//  Created by Angela Tang on 2016-12-21.
//  Copyright © 2016 zixin. All rights reserved.
//

#import "CroppingRecordVC.h"
#import "AppDelegate.h"

@interface CroppingRecordVC (){
    AppDelegate *global;
    float CropStartSec;
    float CropEndSec;
    
    AVAudioPlayer *SoundPlayer;
    UIButton *previewButton;
    UISlider *cropSlider;
    UILabel *sliderLabel;
    UIButton *cropButton;
    
}

@end

@implementation CroppingRecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    global = [[UIApplication sharedApplication]delegate];//reload the updated global everytime
    
    int screenWidth = self.view.frame.size.width;
    int screenHeight = self.view.frame.size.height;
    
    //=====================UI ==================
    // Setup audio session
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [session overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
    
    //set the audioplayer
    SoundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:global.RecordFileURL error:nil];
    [SoundPlayer setDelegate:self];

    
    NSLog(@"crop: %f",SoundPlayer.duration);
    
    previewButton = [[UIButton alloc] init];
    previewButton.frame = CGRectMake(0, 0, screenWidth/5, screenHeight/12);
    previewButton.frame = CGRectMake(screenWidth/2 - previewButton.frame.size.width/2, screenHeight/3, previewButton.frame.size.width, previewButton.frame.size.height);
    previewButton.backgroundColor=[UIColor yellowColor];
    [previewButton setTitle:@"Preview" forState:UIControlStateNormal];
    [previewButton addTarget:self
                   action:@selector(previewTapped)
         forControlEvents:UIControlEventTouchUpInside];
    
    cropButton = [[UIButton alloc] init];
    cropButton.frame = CGRectMake(0, 0, screenWidth/3, screenHeight/12);
    cropButton.frame = CGRectMake(screenWidth/4 - cropButton.frame.size.width/2, screenHeight/4, cropButton.frame.size.width, cropButton.frame.size.height);
    cropButton.backgroundColor=[UIColor redColor];
    [cropButton setTitle:@"Crop" forState:UIControlStateNormal];
    [cropButton addTarget:self
                     action:@selector(croppingSound)
           forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    cropSlider = [[UISlider alloc] init];
    cropSlider.frame = CGRectMake(0, 0, screenWidth/2, screenHeight/12);
    cropSlider.frame = CGRectMake(screenWidth/2 - cropSlider.frame.size.width/2, screenHeight*0.75, screenWidth/2, screenHeight/12);
    cropSlider.maximumValue = SoundPlayer.duration - 0.5;
    cropSlider.minimumValue = 0;
    //==========
    cropSlider.value = 0;
    cropSlider.backgroundColor = [UIColor grayColor];
    
    [cropSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    sliderLabel = [[UILabel alloc]init];
    sliderLabel.frame = CGRectMake(0, 0, screenWidth/2, screenHeight/12);
    sliderLabel.frame = CGRectMake(screenWidth/2 - sliderLabel.frame.size.width/2, screenHeight*0.65, screenWidth/1.5, screenHeight/12);
    
    
    CropStartSec = 0;
    CropEndSec = 0.5;
    sliderLabel.text = [NSString stringWithFormat:@"Time: %.2f - %.2f", CropStartSec, CropEndSec];

    
    
    
    //adding subviews
    [self.view addSubview:previewButton];
    [self.view addSubview:cropButton];
    [self.view addSubview:cropSlider];
    [self.view addSubview:sliderLabel];

}
-(void)previewTapped {
    if (!SoundPlayer.playing){
        [self playAtTime:CropStartSec withDuration:0.5];//play for 0.5 seconds
        
    }
    //=====just to try the trim function
   // bool trimSuccess = [self trimAudio];
    //NSLog(@"%i", trimSuccess);
}




- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)success{//delegate to finish playing
    
    NSLog(@"Finished Playing");
}


-(void)viewWillAppear:(BOOL)animated{
    
    
}

- (IBAction)sliderValueChanged:(UISlider *)sender {
    if(sender == cropSlider){
        
        CropStartSec = cropSlider.value;
    }
    if (CropStartSec + 0.5 <= SoundPlayer.duration){
        CropEndSec = CropStartSec + 0.5;
    }

    
    
    sliderLabel.text = [NSString stringWithFormat:@"Time: %.2f - %.2f", CropStartSec, CropEndSec];
    
}

//====add a preview functions
- (void)playAtTime:(NSTimeInterval)time withDuration:(NSTimeInterval)duration {
    previewButton.enabled = NO;
    NSTimeInterval shortStartDelay = 0.0;
    SoundPlayer.currentTime = CropStartSec;
    NSTimeInterval now = SoundPlayer.deviceCurrentTime;
    
    [SoundPlayer playAtTime:now + shortStartDelay];
    [NSTimer scheduledTimerWithTimeInterval:shortStartDelay + duration
                                                      target:self
                                                    selector:@selector(stopPlaying:)
                                                    userInfo:nil
                                                     repeats:NO];
}

- (void)stopPlaying:(NSTimer *)theTimer {
    previewButton.enabled = YES;
    [SoundPlayer stop];
    SoundPlayer.currentTime = 0.0;
}
//ended preview function


-(void)croppingSound{//when crop button is pressed
    if ([self trimAudio]){
        [self.view removeFromSuperview];//exit
        
    }
    else{
        NSLog(@"Error at trimming audio");
    }
    
}


//--- trimming fuction
- (BOOL)trimAudio
{
    float vocalStartMarker = CropStartSec;
    float vocalEndMarker = CropEndSec;
    
    
    if(vocalEndMarker <=0 || vocalStartMarker >= vocalEndMarker || vocalEndMarker-vocalStartMarker< 0.5){
        return NO;// record not successful under the condition above
    }
    
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"ddMMyyyy_hhmmss";
    NSString *lastString = [[formatter stringFromDate:[NSDate date]] stringByAppendingString:@".m4a"];
    
    NSArray *pathComponents = [NSArray arrayWithObjects:
                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                               [NSString stringWithFormat:@"RecordTrimmed_%@",lastString],
                               nil];
    
    
    NSURL *audioFileInput = global.RecordFileURL;
    
    NSURL *audioFileOutput = [NSURL fileURLWithPathComponents:pathComponents];
    
    
    
    if (!audioFileInput || !audioFileOutput)
    {
        return NO;
    }
    
    [[NSFileManager defaultManager] removeItemAtURL:audioFileOutput error:NULL];
    AVAsset *asset = [AVAsset assetWithURL:audioFileInput];
    
    AVAssetExportSession *exportSession = [AVAssetExportSession exportSessionWithAsset:asset
                                                                            presetName:AVAssetExportPresetAppleM4A];
    
    if (exportSession == nil)
    {
        return NO;
    }
    
    CMTime startTime = CMTimeMake((int)(floor(vocalStartMarker * 100)), 100);
    CMTime stopTime = CMTimeMake((int)(ceil(vocalEndMarker * 100)), 100);
    CMTimeRange exportTimeRange = CMTimeRangeFromTimeToTime(startTime, stopTime);
    
    exportSession.outputURL = audioFileOutput;
    exportSession.outputFileType = AVFileTypeAppleM4A;
    exportSession.timeRange = exportTimeRange;
    
    [exportSession exportAsynchronouslyWithCompletionHandler:^
     {
         if (AVAssetExportSessionStatusCompleted == exportSession.status)
         {
             // It worked!
         }
         else if (AVAssetExportSessionStatusFailed == exportSession.status)
         {
             // It failed...
         }
     }];
    
    //save the NSURL when it is successful
    global.TrimmedRecordFileURL = audioFileOutput;
    
    return YES;
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
