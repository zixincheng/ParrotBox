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
    
}

@end

@implementation CroppingRecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


-(void)viewWillAppear:(BOOL)animated{
    
    global = [[UIApplication sharedApplication]delegate];
    
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
