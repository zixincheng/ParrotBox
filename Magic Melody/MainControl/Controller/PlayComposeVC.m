//
//  PlayComposeVC.m
//  Magic Melody
//
//  Created by Angela Tang on 2017-01-04.
//  Copyright © 2017 zixin. All rights reserved.
//
#include <AudioToolbox/AudioToolbox.h>

#import "AppDelegate.h"
#import "PlayComposeVC.h"

//******** record 0.75s, 0.3s(require to load)
//******** (0.75-0.3)/0.7 = 0.6  at ~ 60% to release the next player
//******** <0.6 will have overlap like 0.5
//******** release the other player before it finishes to reduce lags
//so far 0.522 produce best quality
#define overlapRate 0.522

@interface PlayComposeVC (){
    
    AppDelegate *global;
    //essentials to record and normal play back and machinism
    AVAudioPlayer *SoundPlayer;
    AVAudioRecorder *SoundRecorder;
    NSArray *RecordPathComponents;
    NSURL *RecordOutputFileURL;
    
    AVAudioRecorder *saveSoundRecorder;
    
    NSMutableDictionary *recordSetting;
    
    //essential for display
    int screenWidth;
    int screenHeight;
    
    //UI
    UIButton *playButton;
    UIButton *recordButton;
    UIButton *stopButton;
    UIButton *composeButton;
    UIButton *pauseCompose;
    
    UIButton *saveSwitch;
    
    UISlider *pitchSlider;
    UISlider *rateSlider;
    UILabel *timePitchLabel;
    
    UIButton *cancelButton;
    
    //use semephore locks
    int safeIncrement;
    
    //========essentials for player1
    AVAudioPlayerNode *audioPlayerNode;
    AVAudioUnit *audioUnit;
    AVAudioEngine *audioEngine;
    AVAudioMixerNode *audioMixerNode;
    AVAudioUnitTimePitch *timePitch;
    AVAudioFile *audioFile;
    
    //=======essentials for player2
    AVAudioPlayer *SoundPlayer2;
    AVAudioPlayerNode *audioPlayerNode2;
    AVAudioEngine *audioEngine2;
    AVAudioMixerNode *audioMixerNode2;
    AVAudioUnitTimePitch *timePitch2;
    AVAudioFile *audioFile2;
    
    //trying player 3
    //=======essentials for player2
    AVAudioPlayer *SoundPlayer3;
    AVAudioPlayerNode *audioPlayerNode3;
    AVAudioEngine *audioEngine3;
    AVAudioMixerNode *audioMixerNode3;
    AVAudioUnitTimePitch *timePitch3;
    AVAudioFile *audioFile3;
    
    
    //-==============essentials for playback compose
    int pausePosition;
    
    int countTemp;
    int posTemp;
    int incrementTemp;
    
    //============essentials to manipulate the effects
    //detail about AVAudioEngine pitch and rate
    //pitch:    normal = 1.0 range -2400 to 2400;
    //rate:     normal = 1.0 range 1/32 to 32;
    
    float pitch;
    float rate;
    
    float pitchOffset;
    float rateOffset;
    
    float pitchMax;
    float pitchMin;
    float rateMax;
    float rateMin;
    
    
    int count;//count the array size
    
    float fileLength;//determin where to end (usin float to skip file saving)
    float fileLength2;
    float fileLength3;
    
    NSString* mutex;
    float recordTime;
    
    
    
    //===============essentials for storage
    //testing arrays
    NSMutableArray * PitchArray;//array for testing pitch and rate
    NSMutableArray * rateArray;
    
    //implement of real array with dictionary
    NSDictionary *music;
    NSMutableArray *MusicArray;
    
}


@end

@implementation PlayComposeVC



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    global = [[UIApplication sharedApplication]delegate];//reload the updated global everytime
    
    //**********************SETTING*****************
    //display preset
    screenWidth = self.view.frame.size.width;
    screenHeight = self.view.frame.size.height;
    
    
    //default pitch and rate
    pitch = 1.0;
    rate = 1;
    
    //set default offset
    pitchOffset = 0;
    rateOffset = 0;
    
    //Setting pitch/rate Max and Min Value so user can adjust
    //let user to add or minus one octet
    pitchMax = 1200;
    pitchMin = -1200;
    
    //or slow down the music
    rateMax = 0;
    rateMin = -0.5;
    
    //record time
    recordTime = 0.75;
    
    
    
    
    
    //*******************************************************
    //to count how many item in an array
    count = 0;
    pausePosition = 0;
    
    //determine the length of each player through PCM buffer
    //init
    fileLength = 0;
    fileLength2 = 0;
    fileLength3 = 0;
    
    //Mutex to decide which player should be playing (not working so far)
    mutex = [[NSString alloc]init];
    mutex = @"0";
    
    
    //init of music arrays
    PitchArray = [[NSMutableArray alloc]init];
    rateArray = [[NSMutableArray alloc]init];
    MusicArray = [[NSMutableArray alloc]init];
    
    
    //=================================
    //set the music array in the setArray function
    
    [self HBD];
    
    //[self TTLS];
    
    //[self Lullaby];
    
    //NSLog(@"%@",MusicArray);
    
    //=========new for parrobox
    // Setup audio session
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [session overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
    
    //set the audioplayer
    SoundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:global.TrimmedRecordFileURL error:nil];
    [SoundPlayer setDelegate:self];
    //==============
    
    
    
    /*/==================record player (old)
    RecordPathComponents = [NSArray arrayWithObjects:
                            [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                            @"MyAudioMemo.aac",
                            nil];
    RecordOutputFileURL = [NSURL fileURLWithPathComponents:RecordPathComponents];
    
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
    //======================*/
    
    //=====================UI ==================
    
    /*
    playButton = [[UIButton alloc] init];
    playButton.frame = CGRectMake(0, 0, screenWidth/5, screenHeight/12);
    playButton.frame = CGRectMake(screenWidth/2 - playButton.frame.size.width/2, screenHeight/3, playButton.frame.size.width, playButton.frame.size.height);
    playButton.backgroundColor=[UIColor redColor];
    [playButton setTitle:@"Play" forState:UIControlStateNormal];
    [playButton addTarget:self
                   action:@selector(playTapped)
         forControlEvents:UIControlEventTouchUpInside];
    
    recordButton = [[UIButton alloc] init];
    recordButton.frame = CGRectMake(0, 0, screenWidth/3, screenHeight/12);
    recordButton.frame = CGRectMake(screenWidth/4 - recordButton.frame.size.width/2, screenHeight/4, recordButton.frame.size.width, recordButton.frame.size.height);
    recordButton.backgroundColor=[UIColor redColor];
    [recordButton setTitle:@"Record" forState:UIControlStateNormal];
    [recordButton addTarget:self
                     action:@selector(recordPauseTapped)
           forControlEvents:UIControlEventTouchUpInside];
     */
    
    stopButton = [[UIButton alloc] init];
    stopButton.frame = CGRectMake(0, 0, screenWidth/3, screenHeight/12);
    stopButton.frame = CGRectMake(screenWidth/2 - stopButton.frame.size.width/2, screenHeight/2, stopButton.frame.size.width, stopButton.frame.size.height);
    stopButton.backgroundColor=[UIColor redColor];
    [stopButton setTitle:@"Stop" forState:UIControlStateNormal];
    [stopButton addTarget:self
                   action:@selector(stopTapped)
         forControlEvents:UIControlEventTouchUpInside];
    
    
    //add the sliders
    composeButton = [[UIButton alloc] init];
    composeButton.frame = CGRectMake(0, 0, screenWidth/3, screenHeight/12);
    composeButton.frame = CGRectMake(screenWidth/2 - composeButton.frame.size.width/2, screenHeight/6, composeButton.frame.size.width, composeButton.frame.size.height);
    composeButton.backgroundColor=[UIColor redColor];
    [composeButton setTitle:@"Compose" forState:UIControlStateNormal];
    [composeButton addTarget:self
                      action:@selector(ComposeAudio)
            forControlEvents:UIControlEventTouchUpInside];
    
    pauseCompose = [[UIButton alloc] init];
    pauseCompose.frame = CGRectMake(0, 0, screenWidth/3, screenHeight/12);
    pauseCompose.frame = CGRectMake(screenWidth/2 - pauseCompose.frame.size.width/2, screenHeight/4, pauseCompose.frame.size.width, pauseCompose.frame.size.height);
    pauseCompose.backgroundColor=[UIColor blueColor];
    [pauseCompose setTitle:@"Pause" forState:UIControlStateNormal];
    [pauseCompose addTarget:self
                     action:@selector(pausePlayCompose)
           forControlEvents:UIControlEventTouchUpInside];
    
    saveSwitch = [[UIButton alloc] init];
    saveSwitch.frame = CGRectMake(0, 0, screenWidth/3, screenHeight/12);
    saveSwitch.frame = CGRectMake(screenWidth/2 - saveSwitch.frame.size.width/2, stopButton.frame.origin.y + screenHeight/12, saveSwitch.frame.size.width, saveSwitch.frame.size.height);
    
    saveSwitch.backgroundColor=[UIColor blueColor];
    [saveSwitch setTitle:@"Saving is OFF" forState:UIControlStateNormal];
    [saveSwitch setTitle:@"Saving is ON" forState:UIControlStateSelected];
    [saveSwitch addTarget:self
                   action:@selector(savingSoundSwitch)
         forControlEvents:UIControlEventTouchUpInside];
    
    
    cancelButton = [[UIButton alloc] init];
    cancelButton.frame = CGRectMake(0, 0, screenWidth/3, screenHeight/12);
    cancelButton.frame = CGRectMake(screenWidth/2 - cancelButton.frame.size.width/2, saveSwitch.frame.origin.y + screenHeight/6, cancelButton.frame.size.width, cancelButton.frame.size.height);
    cancelButton.backgroundColor=[UIColor redColor];
    [cancelButton setTitle:@"Back" forState:UIControlStateNormal];
    [cancelButton addTarget:self
                     action:@selector(cancelPlay)
           forControlEvents:UIControlEventTouchUpInside];
    
    
    
    pitchSlider = [[UISlider alloc] init];
    pitchSlider.frame = CGRectMake(0, 0, screenWidth/2, screenHeight/12);
    pitchSlider.frame = CGRectMake(screenWidth/2 - pitchSlider.frame.size.width/2, screenHeight*0.75, screenWidth/2, screenHeight/12);
    //Pitch Max Min
    pitchSlider.maximumValue = pitchMax;
    pitchSlider.minimumValue = pitchMin;
    //==========
    pitchSlider.value=0;
    pitchSlider.backgroundColor = [UIColor grayColor];
    
    [pitchSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    
    rateSlider = [[UISlider alloc] init];
    rateSlider.frame = CGRectMake(0, 0, screenWidth/2, screenHeight/12);
    rateSlider.frame = CGRectMake(screenWidth/2 - rateSlider.frame.size.width/2, screenHeight*0.85, screenWidth/2, screenHeight/12);
    
    //Rate Max Min
    rateSlider.maximumValue = rateMax;
    rateSlider.minimumValue = rateMin;
    //======
    rateSlider.backgroundColor = [UIColor yellowColor];
    rateSlider.value=0;
    
    [rateSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    
    timePitchLabel = [[UILabel alloc]init];
    timePitchLabel.frame = CGRectMake(0, 0, screenWidth/2, screenHeight/12);
    timePitchLabel.frame = CGRectMake(screenWidth/2 - pitchSlider.frame.size.width/2, screenHeight*0.65, screenWidth/1.5, screenHeight/12);
    
    timePitchLabel.text = [NSString stringWithFormat:@"Pitch offset: %.2f . Rate offset: %.2f", pitchOffset, rateOffset];
    //===========================
    
    
    
    
    
    //adding views
    //[self.view addSubview:playButton];
    [self.view addSubview:stopButton];
    //[self.view addSubview:recordButton];
    [self.view addSubview:composeButton];
    [self.view addSubview:pauseCompose];
    [self.view addSubview:saveSwitch];
    
    [self.view addSubview:cancelButton];
    
    //[self.view addSubview:pitchSlider];
    //[self.view addSubview:rateSlider];
    //[self.view addSubview: timePitchLabel];
    
}

//change value after slided
- (IBAction)sliderValueChanged:(UISlider *)sender {
    if(sender == pitchSlider){
        float pitchTemp = sender.value;
        pitchTemp = (int)(sender.value/100);
        pitchTemp = pitchTemp*100;
        
        [pitchSlider setValue:pitchTemp];
        
        pitchOffset = pitchSlider.value;
    }
    else{
        rateOffset = sender.value;
    }
    timePitchLabel.text = [NSString stringWithFormat:@"Pitch: %.2f . Rate: %.4f", pitchOffset, rateOffset];
    
}




/*
-(void)recordPauseTapped {
    // Stop the audio player before recording
    if (SoundPlayer.playing) {
        [SoundPlayer stop];
    }
    
    if (!SoundRecorder.recording) {
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setActive:YES error:nil];
        
        // Start recording
        
        [ SoundRecorder recordForDuration:(NSTimeInterval) recordTime];
        //only record 0.75 second (do not change to lower) because 0.5*pitch may result<0.3.
        // quickest for pitch* duration is ~0.5sec because each audioengine takes 0.3 sec to get in/out
        // and if it set it to lower, it will flip a note
        
        [recordButton setTitle: @"Pause" forState:UIControlStateNormal];
        
    } else {
        
        // Pause recording
        [SoundRecorder pause];
        [recordButton setTitle:@"Record" forState:UIControlStateNormal];
    }
    
    [stopButton setEnabled:YES];
    [playButton setEnabled:NO];
}*/

-(void)cancelPlay{
    [self.view removeFromSuperview];//exit without doing anything
}

-(void)stopTapped {
    
    [SoundRecorder  stop];
    
    [saveSoundRecorder stop];
    
    //reset every thing
    
    fileLength =0;
    fileLength2 =0;
    fileLength3 = 0;
    
    count = 0;
    pausePosition = 0;
    safeIncrement= 0;
    
    [self reEnable];
    
    
    
    //============
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setActive:NO error:nil];
}


/*
-(void)playTapped {
    if (!SoundRecorder.recording){
        
        SoundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:SoundRecorder.url error:nil];
        [SoundPlayer setDelegate:self];
        //[SoundPlayer setEnableRate:YES];
        //[SoundPlayer setRate:rate];
        
        [SoundPlayer play];
    }
    //=====just to try the trim function
    bool trimSuccess = [self trimAudio];
    NSLog(@"%i", trimSuccess);
    
}*/




//===delegates
-(void) audioRecorderDidFinishRecording:(AVAudioRecorder *)avrecorder successfully:(BOOL)success{
    
    if (avrecorder == SoundRecorder){
        [recordButton setTitle:@"Record" forState:UIControlStateNormal];
        
        //[stopButton setEnabled:NO];
        [playButton setEnabled:YES];
        
       // NSLog(@"%@",SoundRecorder.url);
    }
    
}

- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)success{
    
    NSLog(@"Finished Playing");
}


-(void)ComposeAudio{
    composeButton.enabled=false;
    count = (int)[MusicArray count]  ;//cal the count
    
    //reset everything before it starts
    
    audioPlayerNode = [[AVAudioPlayerNode alloc]init];
    audioEngine = [[AVAudioEngine alloc] init];
    audioMixerNode = [[AVAudioMixerNode alloc]init];
    timePitch = [[AVAudioUnitTimePitch alloc] init];
    audioPlayerNode2 = [[AVAudioPlayerNode alloc]init];
    audioEngine2 = [[AVAudioEngine alloc] init];
    audioMixerNode2 = [[AVAudioMixerNode alloc]init];
    timePitch2 = [[AVAudioUnitTimePitch alloc] init];
    
    audioPlayerNode3 = [[AVAudioPlayerNode alloc]init];
    audioEngine3 = [[AVAudioEngine alloc] init];
    audioMixerNode3 = [[AVAudioMixerNode alloc]init];
    timePitch3 = [[AVAudioUnitTimePitch alloc] init];
    
    
    
    if (saveSwitch.selected){//record sound if user selected.
        if (!saveSoundRecorder.recording) {
            AVAudioSession *session = [AVAudioSession sharedInstance];
            [session setActive:YES error:nil];
            [saveSoundRecorder record];
        }
        
    }
    
    
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{//play in background
        NSError *error;
        //attach file to soundPlayer so audioengine can use its info later by both players
        SoundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:global.TrimmedRecordFileURL error:&error];
        
        //rate = rateSlider.value;//these will change pitch as it desire
        
        //pitch = pitchSlider.value;
        
        //safeIncrement = 0;
        
        //this method will be hard to syn the first 2 notes(attempts has been doing)
        //may need to skip the first 2 note or set it to silence
        
        //use infinite loop to wait for the player finished
        
        int j = 0;
        
        for (int i = pausePosition; i < count; j++){
            
            //NSLog(@"%i",j);
            
            while(i%3 == 0 && count>0 && ![audioPlayerNode isPlaying] ){
                // like number 0,3,6
                
                if (i < count){
                    
                    //pitch = [[PitchArray objectAtIndex:i]floatValue] + pitchOffset;
                    //rate = [[rateArray objectAtIndex:i]floatValue];
                    
                    pitch = [[[MusicArray objectAtIndex:i]objectForKey:@"pitch"]floatValue] + pitchOffset;
                    rate = [[[MusicArray objectAtIndex:i]objectForKey:@"rate"]floatValue];
                    
                    [self playSound:i];
                    
                    while (safeIncrement != 1 )//prevent overlap
                    {
                        //infinite loop to detect the ending of the players
                        if (count<= 0){
                            break;
                        }
                    }
                    i++;
                    pausePosition++;
                    NSLog(@"%i",i);
                    
                }
                
            }//end player 1
            
            //use first 2 pause method to sync the players
            
            //if(i == 1){//attempt to wait first player to finish by determine the duration with +0.2 sec
            
            //  sleep((recordTime/[[[MusicArray objectAtIndex:i]objectForKey:@"rate"]floatValue])+0.2);
            //it takes ~0.3 sec to get mem out from player1 to be ready again
            //}
            //
            while(i%3 == 1 && count>0&&  ![audioPlayerNode2 isPlaying]){
                //like 1,4,7..
                
                if (i < count){
                    
                    //pitch = [[PitchArray objectAtIndex:i]floatValue] + pitchOffset;
                    //rate = [[rateArray objectAtIndex:i]floatValue];
                    
                    pitch = [[[MusicArray objectAtIndex:i]objectForKey:@"pitch"]floatValue] + pitchOffset;
                    rate = [[[MusicArray objectAtIndex:i]objectForKey:@"rate"]floatValue];
                    
                    [self playSound2:i];
                    
                    while (safeIncrement != 2 )//prevent overlaps
                    {
                        if (count<= 0){
                            break;
                        }
                    }
                    
                    i++;
                    pausePosition++;
                    NSLog(@"%i",i);
                    
                }
                
            }///end player2
            
            while(i%3 == 2 && count>0&&  ![audioPlayerNode3 isPlaying]){
                //like 2,5,8..
                
                if (i < count){
                    
                    
                    pitch = [[[MusicArray objectAtIndex:i]objectForKey:@"pitch"]floatValue] + pitchOffset;
                    rate = [[[MusicArray objectAtIndex:i]objectForKey:@"rate"]floatValue];
                    
                    [self playSound3:i];
                    
                    while (safeIncrement != 0 )//prevent overlaps
                    {
                        if (count<= 0){
                            break;
                        }
                    }
                    i++;
                    pausePosition++;
                    NSLog(@"%i",i);
                    
                }
                
            }///end player3
            
            ///==========*********
        }//endfor ==========*************/
        
        
        //[PitchArray removeAllObjects];
        //[rateArray removeAllObjects];
        
        //try play with openAL=================(not working well)
        
        //Retrieve audio file
        //[OpenALHelper loadSoundNamed:@"MyAudioMemo" withPath:SoundRecorder.url];
        //[OpenALHelper setSoundPitch:pitch];
        //[OpenALHelper playSoundNamed:@"MyAudioMemo"];
        
    });//*/
    
    //[self performSelector:@selector(reEnable) withObject:nil afterDelay:recordTime*(count-2)];//will use more percise cal later
    
}//end change pitch button

//call this to reset the essentials
-(void)reEnable{
    pausePosition = 0;
    safeIncrement = 0;
    
    if ([audioPlayerNode isPlaying]){//audioengine is playing
        [audioMixerNode removeTapOnBus:0];
        [audioPlayerNode stop];
        [audioEngine stop];
        
        audioPlayerNode = [[AVAudioPlayerNode alloc]init];
        audioEngine = [[AVAudioEngine alloc] init];
        audioMixerNode = [[AVAudioMixerNode alloc]init];
        timePitch = [[AVAudioUnitTimePitch alloc] init];
    }
    if ([audioPlayerNode2 isPlaying]){//audioengine is playing
        [audioMixerNode2 removeTapOnBus:0];
        [audioPlayerNode2 stop];
        [audioEngine2 stop];
        
        audioPlayerNode2 = [[AVAudioPlayerNode alloc]init];
        audioEngine2 = [[AVAudioEngine alloc] init];
        audioMixerNode2 = [[AVAudioMixerNode alloc]init];
        timePitch2 = [[AVAudioUnitTimePitch alloc] init];
        
    }
    
    if ([audioPlayerNode3 isPlaying]){//audioengine is playing
        [audioMixerNode3 removeTapOnBus:0];
        [audioPlayerNode3 stop];
        [audioEngine3 stop];
        
        audioPlayerNode3 = [[AVAudioPlayerNode alloc]init];
        audioEngine3 = [[AVAudioEngine alloc] init];
        audioMixerNode3 = [[AVAudioMixerNode alloc]init];
        timePitch3 = [[AVAudioUnitTimePitch alloc] init];
        
    }
    
    
    if(audioPlayerNode != nil && audioPlayerNode2!= nil &&audioPlayerNode3 != nil){
        composeButton.enabled = true;
        audioPlayerNode = [[AVAudioPlayerNode alloc]init];
        audioPlayerNode2 = [[AVAudioPlayerNode alloc]init];
        audioPlayerNode3 = [[AVAudioPlayerNode alloc]init];
        
    }
    if (saveSoundRecorder.recording){//only if it is recording
        [saveSoundRecorder stop];
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setActive:NO error:nil];
        saveSwitch.selected = !saveSwitch.isSelected;
    }
    NSLog(@"reEnable");
}

//=====================

-(void)playSound: (int) i{
    
    audioPlayerNode = [[AVAudioPlayerNode alloc]init];
    audioEngine = [[AVAudioEngine alloc] init];
    audioMixerNode = [[AVAudioMixerNode alloc]init];
    timePitch = [[AVAudioUnitTimePitch alloc] init];
    
    
    NSError *error;
    if (!SoundRecorder.recording){
        
        NSLog(@"player1");
        
        
        //==========
        audioPlayerNode.volume = [[[MusicArray objectAtIndex:i]objectForKey:@"sound"] floatValue];
        //===============
        
        
        [audioEngine attachNode:audioPlayerNode];
        
        audioMixerNode = audioEngine.mainMixerNode;
        
        [timePitch setPitch:pitch];  // In cents. The default value is 1.0. The range of values is -2400 to 2400
        [timePitch setRate:rate];  //The default value is 1.0. The range of supported values is 1/32 to 32.0.
        [timePitch setOverlap:32];
        [audioEngine attachNode:timePitch];
        [audioEngine connect:audioPlayerNode to:timePitch format:[audioMixerNode outputFormatForBus:0]];
        [audioEngine connect:timePitch to:audioMixerNode format:[audioMixerNode outputFormatForBus:0]];
        
        audioFile = [[AVAudioFile alloc] initForReading:global.TrimmedRecordFileURL error:&error];
        
        [audioPlayerNode scheduleFile:audioFile atTime:0 completionHandler:nil];
        
        [audioEngine startAndReturnError:&error];
        
        
        if(!error){
            [audioPlayerNode play];
            
        }
        
        //[audioFile.length/audioFile.fileFormat.sampleRate/rate] //length in sec
        //NSLog(@"%f",audioFile.length/audioFile.fileFormat.sampleRate/rate);
        
        //== below code is to save the file for library use (IS SLOW)*****************************
        /*//prepare file path
         NSArray *pathComponents = [NSArray arrayWithObjects:
         //[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject], @"MyAudioEffect.caf", nil];
         [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],[NSString stringWithFormat:@"Myeffect-%i.caf",i], nil];//=========********* <--------- save every name with i
         
         NSURL *outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
         
         [pathArr addObject:outputFileURL];//add the path ready to combine
         
         AVAudioFile *CreateFile = [[AVAudioFile alloc] initForWriting:outputFileURL settings:[[audioMixerNode outputFormatForBus:0]settings]  error:&error];
         
         
         [audioMixerNode installTapOnBus:0 bufferSize:((AVAudioFrameCount)(SoundPlayer.duration))/rate format:[audioMixerNode outputFormatForBus:0] block:^(AVAudioPCMBuffer *buffer, AVAudioTime *when)
         {
         
         if ((CreateFile.length)< (audioFile.length)/rate){
         [CreateFile writeFromBuffer:buffer error:&error];//save the file
         }
         else{
         [audioMixerNode removeTapOnBus:0];
         fileLength = 0;
         [audioPlayerNode stop];
         [audioPlayerNode reset];//stop and reset the audioplayernode after it finished
         //so that the infinite loop picks up and start do next play
         [audioEngine reset];
         }
         }];
         //*//*****************************************************************/
        
        //tap pcm buffer
        
        [audioMixerNode installTapOnBus:0 bufferSize:(AVAudioFrameCount)(SoundPlayer.duration/rate) format:[audioMixerNode outputFormatForBus:0] block:^(AVAudioPCMBuffer *buffer, AVAudioTime *when)
         {
             //NSLog(@"writing to buffer");
             
             if(fileLength < (audioFile.length/rate)){//try to not using the file write, a lot quicker
                 
                 fileLength += buffer.frameLength;
                 
                 if(fileLength >= (audioFile.length/rate) *overlapRate ){//release it before it finished
                     safeIncrement = 1;
                 }
                 
             }
             else{
                 dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{//play in background
                     //another background thread to remove things to prevent race against main thread
                     [audioMixerNode removeTapOnBus:0];
                     if ([audioPlayerNode isPlaying]){
                         [audioPlayerNode pause];
                         [audioPlayerNode reset];//stop and reset the audioplayernode after it finished
                         //so that the infinite loop picks up and start do next play
                         
                     }
                     
                 });
                 
                 
                 fileLength = 0;
                 if(i >= count-1){//reEnable Compose button after play
                     [audioMixerNode removeTapOnBus:0];
                     [audioPlayerNode pause];
                     [audioPlayerNode reset];
                     [self reEnable];
                 }
                 
             }
             
         }];
        
        //============*/
        
    }//end if sound not recording
    
    
}//end playSound


-(void)playSound2: (int) i{
    NSLog(@"player2");
    audioPlayerNode2 = [[AVAudioPlayerNode alloc]init];
    audioEngine2 = [[AVAudioEngine alloc] init];
    audioMixerNode2 = [[AVAudioMixerNode alloc]init];
    timePitch2 = [[AVAudioUnitTimePitch alloc] init];
    NSError *error;
    //======= try silence
    audioPlayerNode2.volume = [[[MusicArray objectAtIndex:i]objectForKey:@"sound"] floatValue];
    //=======
    
    [audioEngine2 attachNode:audioPlayerNode2];
    
    audioMixerNode2 = audioEngine2.mainMixerNode;
    
    [timePitch2 setPitch:pitch];  // In cents. The default value is 1.0. The range of values is -2400 to 2400
    [timePitch2 setRate:rate];  //The default value is 1.0. The range of supported values is 1/32 to 32.0.
    [timePitch2 setOverlap:32];
    [audioEngine2 attachNode:timePitch2];
    [audioEngine2 connect:audioPlayerNode2 to:timePitch2 format:[audioMixerNode2 outputFormatForBus:0]];
    [audioEngine2 connect:timePitch2 to:audioMixerNode2 format:[audioMixerNode2 outputFormatForBus:0]];
    
    audioFile2 = [[AVAudioFile alloc] initForReading:global.TrimmedRecordFileURL error:&error];
    [audioPlayerNode2 scheduleFile:audioFile2 atTime:0 completionHandler:nil];
    
    [audioEngine2 startAndReturnError:&error];
    
    if(!error){
        //NSLog(@"count: %i",count);
        [audioPlayerNode2 play];
        
    }
    [audioMixerNode2 installTapOnBus:0 bufferSize:(AVAudioFrameCount)(SoundPlayer.duration/rate) format:[audioMixerNode2 outputFormatForBus:0] block:^(AVAudioPCMBuffer *buffer, AVAudioTime *when)
     {
         
         //NSLog(@"writing to buffer");
         
         if(fileLength2 < (audioFile2.length/rate) ){//try to not using the file write, a bit quicker
             fileLength2 += buffer.frameLength;
             
             if(fileLength2 >= (audioFile2.length/rate)*overlapRate){//release it before it finished
                 
                 
                 safeIncrement = 2;
             }
             
             
         }
         else{
             dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{//play in background
                 //another background thread to remove things to prevent race against main thread
                 [audioMixerNode2 removeTapOnBus:0];
                 
                 if([audioPlayerNode2 isPlaying]){
                     [audioPlayerNode2 pause];
                     [audioPlayerNode2 reset];//stop and reset the audioplayernode after it finished
                     //so that the infinite loop picks up and start do next play
                 }
             });
             
             
             fileLength2 = 0;
             if(i >= count-1){//reEnable Compose button after play
                 [audioMixerNode2 removeTapOnBus:0];
                 [audioPlayerNode2 pause];
                 [audioPlayerNode2 reset];
                 [self reEnable];
             }
         }
         
     }];
    
    
    
}//end playSound2

-(void)playSound3: (int) i{
    NSLog(@"player3");
    audioPlayerNode3 = [[AVAudioPlayerNode alloc]init];
    audioEngine3 = [[AVAudioEngine alloc] init];
    audioMixerNode3 = [[AVAudioMixerNode alloc]init];
    timePitch3 = [[AVAudioUnitTimePitch alloc] init];
    NSError *error;
    //======= try silence
    audioPlayerNode3.volume = [[[MusicArray objectAtIndex:i]objectForKey:@"sound"] floatValue];
    //=======
    
    [audioEngine3 attachNode:audioPlayerNode3];
    
    audioMixerNode3 = audioEngine3.mainMixerNode;
    
    [timePitch3 setPitch:pitch];  // In cents. The default value is 1.0. The range of values is -2400 to 2400
    [timePitch3 setRate:rate];  //The default value is 1.0. The range of supported values is 1/32 to 32.0.
    [timePitch3 setOverlap:32];
    [audioEngine3 attachNode:timePitch3];
    [audioEngine3 connect:audioPlayerNode3 to:timePitch3 format:[audioMixerNode3 outputFormatForBus:0]];
    [audioEngine3 connect:timePitch3 to:audioMixerNode3 format:[audioMixerNode3 outputFormatForBus:0]];
    
    audioFile3 = [[AVAudioFile alloc] initForReading:global.TrimmedRecordFileURL error:&error];
    [audioPlayerNode3 scheduleFile:audioFile3 atTime:0 completionHandler:nil];
    
    [audioEngine3 startAndReturnError:&error];
    
    if(!error){
        //NSLog(@"count: %i",count);
        [audioPlayerNode3 play];
        
    }
    [audioMixerNode3 installTapOnBus:0 bufferSize:(AVAudioFrameCount)(SoundPlayer.duration/rate) format:[audioMixerNode3 outputFormatForBus:0] block:^(AVAudioPCMBuffer *buffer, AVAudioTime *when)
     {
         
         //NSLog(@"writing to buffer");
         
         if(fileLength3 < (audioFile3.length/rate) ){//try to not using the file write, a bit quicker
             fileLength3 += buffer.frameLength;
             
             if(fileLength3 >= (audioFile3.length/rate)*overlapRate){//release it before it finished
                 
                 safeIncrement = 0;
             }
             
             
         }
         else{
             dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                 //another background thread to remove things to prevent race against main thread
                 [audioMixerNode3 removeTapOnBus:0];
                 
                 if([audioPlayerNode3 isPlaying]){
                     [audioPlayerNode3 pause];
                     [audioPlayerNode3 reset];//stop and reset the audioplayernode after it finished
                     //so that the infinite loop picks up and start do next play
                 }
             });
             
             fileLength3 = 0;
             if(i >= count-1){//reEnable Compose button after play
                 [audioMixerNode3 removeTapOnBus:0];
                 [audioPlayerNode3 pause];
                 [audioPlayerNode3 reset];
                 [self reEnable];
             }
         }
         
     }];
    
    
    
}//end playSound3







//compose song pause
-(void)pausePlayCompose{
    countTemp = count;
    posTemp = pausePosition - 3;
    incrementTemp = safeIncrement;
    [self stopTapped];
    [self performSelector:@selector(resetPosition) withObject:nil afterDelay:1.0];
    
    
}

-(void)resetPosition{
    //pauseposition become zero, need to set back
    NSLog(@"reset");
    if(pausePosition >= countTemp-3){
        pausePosition = 0;// it considers as finished playback
        safeIncrement = 0;
    }
    else{
        if(posTemp >= 0){
            pausePosition = posTemp;
            safeIncrement = pausePosition%3;
        }
    }
}



//This will save the song of the composition
-(void)savingSoundSwitch{
    saveSwitch.selected = !saveSwitch.selected;//switch the title and state
    
    if (saveSwitch.selected){//save is choosed, ready to record
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Note"
                                                        message:@"During the process, please make sure your surrounding is Quiet and Phone's volume is tune to Maximum for the best result"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        //==================record player
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"ddMMyyyy_hhmmss";
        NSString *lastString = [[formatter stringFromDate:[NSDate date]] stringByAppendingString:@".m4a"];
        
        NSArray *pathComponents = [NSArray arrayWithObjects:
                                   [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                                   [NSString stringWithFormat:@"MyComposedSong_%@",lastString],
                                   nil];
        NSURL *outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
        
        // Define the recorder setting
        NSMutableDictionary *songRecordSetting = [[NSMutableDictionary alloc] init];
        
        [songRecordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
        [songRecordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
        [songRecordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
        
        
        // Initiate and prepare the recorder
        saveSoundRecorder = [[AVAudioRecorder alloc] initWithURL:outputFileURL settings:songRecordSetting error:NULL];
        saveSoundRecorder.delegate = self;
        saveSoundRecorder.meteringEnabled = YES;
        [saveSoundRecorder prepareToRecord];
        //======================
        
        
    }
    else{//save is not selected
        
    }
    
}
//--- trimming fuction(working)
- (BOOL)trimAudio
{
    float vocalStartMarker = 7;
    float vocalEndMarker = 20;
    
    
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"ddMMyyyy_hhmmss";
    NSString *lastString = [[formatter stringFromDate:[NSDate date]] stringByAppendingString:@".m4a"];
    
    NSArray *pathComponents = [NSArray arrayWithObjects:
                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                               [NSString stringWithFormat:@"MyTrimmedSong_%@",lastString],
                               nil];
    
    NSArray *path2 = [NSArray arrayWithObjects:
                      [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                      [NSString stringWithFormat:@"MyComposedSong_06112016_063221.m4a"],
                      nil];
    
    
    NSURL *audioFileInput = [NSURL fileURLWithPathComponents:path2];
    
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
    
    return YES;
}


-(void)HBD{
    /**************************
     Propose Json format
     
     //Json format:
     -title: name of the song-
     
     each note/tone/sound consists 4 elements so far
     
     1) sound:  BOOL(0 or 1) : notify it is play or a pause 0 = no sound
     2) overlapRate: Float ~0.6 nd < 0.5 for overlapping to decide whether the overlap occurs with the next music note
     3) pitch: Float(-2400 to 2400) (will probably reduce to ~ -1000 to 1000?): notify the pitch of the sound when play
     4) rate: Float(1/32 to 32) (will reduce to ~ 1/5 to 5?): notify the rate of the sound when play
     
     **may be added later**
     5) fade: Float?? : tell the sound is fade in or out and where to have the effect
     6) effect: Float?? : tell the sound to be played in a music hall and other places
     
     
     *****************************/
    
    
    
    //************ NOTE ******************
    //First 2 notes for SYNC, use NO SOUND!!!!! (engine sync)
    //Last Note is also use for SYNC close, use NO sound!!!!!!! (save sound sync)
    
    //rate is the duration. (low long of the sound should be)
    //rate = 0.5 is longer, 2 is 2 times faster playback
    //duration is saved for other variable use
    
    
    //pause max for rate is 1.6 because 0.75/1.6 = 0.4. 0.4*2 ~ 0.8 = max amount for mem get in/out of audioPlayerNode
    
    
    //=============SYNC NOTE FOR MUSIC ENGINES===============
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             @"0", @"sound",
             @"0", @"overlapRate",
             @"1", @"pitch",
             @"1", @"rate",
             nil];
    
    [MusicArray addObject:music];
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             @"0", @"sound",
             @"0", @"overlapRate",
             @"1", @"pitch",
             @"1.75", @"rate",
             nil];
    
    [MusicArray addObject:music];
    //=========================
    //rate max: 1.75
    //rate min: 0.1
    
    
    
    //=======CONTENT START HERE=============
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             @"1", @"sound",
             @"0", @"overlapRate",
             @"1", @"pitch",
             @"1.2", @"rate",
             nil];
    
    [MusicArray addObject:music];
    
    ///========= copy format from above
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             @"1", @"sound",
             @"0", @"overlapRate",
             @"1", @"pitch",
             @"1.2", @"rate",
             nil];
    
    [MusicArray addObject:music];
    
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             @"1", @"sound",
             @"0", @"overlapRate",
             @"200", @"pitch",
             @"1.2", @"rate",
             nil];
    
    [MusicArray addObject:music];
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             @"1", @"sound",
             @"0", @"overlapRate",
             @"1", @"pitch",
             @"1.2", @"rate",
             nil];
    
    [MusicArray addObject:music];
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             @"1", @"sound",
             @"0", @"overlapRate",
             @"500", @"pitch",
             @"1.2", @"rate",
             nil];
    
    [MusicArray addObject:music];
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             @"1", @"sound",
             @"0", @"overlapRate",
             @"400", @"pitch",
             @"0.75", @"rate",
             nil];
    
    [MusicArray addObject:music];
    
    
    //=====try pause here
    
    //use rate to pause 0.75/1.75 = 0.42 sec pause(max)
    //sound set to silence when is = 0
    
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             @"0", @"sound",
             @"0", @"overlapRate",
             @"1", @"pitch",
             @"1", @"rate",
             nil];
    
    [MusicArray addObject:music];
    //=====*/
    
    
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             @"1", @"sound",
             @"0", @"overlapRate",
             @"1", @"pitch",
             @"1.2", @"rate",
             nil];
    
    [MusicArray addObject:music];
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             @"1", @"sound",
             @"0", @"overlapRate",
             @"1", @"pitch",
             @"1.2", @"rate",
             nil];
    
    [MusicArray addObject:music];
    
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             @"1", @"sound",
             @"0", @"overlapRate",
             @"200", @"pitch",
             @"1.2", @"rate",
             nil];
    
    [MusicArray addObject:music];
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             @"1", @"sound",
             @"0", @"overlapRate",
             @"1", @"pitch",
             @"1.2", @"rate",
             nil];
    
    [MusicArray addObject:music];
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             @"1", @"sound",
             @"0", @"overlapRate",
             @"600", @"pitch",
             @"1.2", @"rate",
             nil];
    
    [MusicArray addObject:music];
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             @"1", @"sound",
             @"0", @"overlapRate",
             @"400", @"pitch",
             @"0.75", @"rate",
             nil];
    
    [MusicArray addObject:music];
    //2ndline ended
    //pause
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             @"0", @"sound",
             @"0", @"overlapRate",
             @"1", @"pitch",
             @"1", @"rate",
             nil];
    
    [MusicArray addObject:music];
    
    
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             @"1", @"sound",
             @"0", @"overlapRate",
             @"1", @"pitch",
             @"1.2", @"rate",
             nil];
    
    [MusicArray addObject:music];
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             @"1", @"sound",
             @"0", @"overlapRate",
             @"1", @"pitch",
             @"1.2", @"rate",
             nil];
    
    [MusicArray addObject:music];
    
    
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             @"1", @"sound",
             @"0", @"overlapRate",
             @"800", @"pitch",
             @"1", @"rate",
             nil];
    
    [MusicArray addObject:music];
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             @"1", @"sound",
             @"0", @"overlapRate",
             @"500", @"pitch",
             @"1", @"rate",
             nil];
    
    [MusicArray addObject:music];
    
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             @"1", @"sound",
             @"0", @"overlapRate",
             @"200", @"pitch",
             @"1.75", @"rate",
             nil];
    
    [MusicArray addObject:music];
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             @"1", @"sound",
             @"0", @"overlapRate",
             @"200", @"pitch",
             @"1.75", @"rate",
             nil];
    
    [MusicArray addObject:music];
    
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             @"1", @"sound",
             @"0", @"overlapRate",
             @"100", @"pitch",
             @"1", @"rate",
             nil];
    
    [MusicArray addObject:music];
    
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             @"1", @"sound",
             @"0", @"overlapRate",
             @"1", @"pitch",
             @"0.75", @"rate",
             nil];
    
    [MusicArray addObject:music];
    
    //pause
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             @"0", @"sound",
             @"0", @"overlapRate",
             @"1", @"pitch",
             @"1", @"rate",
             nil];
    
    [MusicArray addObject:music];
    
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             @"1", @"sound",
             @"0", @"overlapRate",
             @"800", @"pitch",
             @"1.75", @"rate",
             nil];
    
    [MusicArray addObject:music];
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             @"1", @"sound",
             @"0", @"overlapRate",
             @"800", @"pitch",
             @"1.75", @"rate",
             nil];
    
    [MusicArray addObject:music];
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             @"1", @"sound",
             @"0", @"overlapRate",
             @"600", @"pitch",
             @"1", @"rate",
             nil];
    
    [MusicArray addObject:music];
    
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             @"1", @"sound",
             @"0", @"overlapRate",
             @"200", @"pitch",
             @"1", @"rate",
             nil];
    
    [MusicArray addObject:music];
    
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             @"1", @"sound",
             @"0", @"overlapRate",
             @"400", @"pitch",
             @"0.75", @"rate",
             nil];
    
    [MusicArray addObject:music];
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             @"1", @"sound",
             @"0", @"overlapRate",
             @"200", @"pitch",
             @"0.45", @"rate",
             nil];
    
    [MusicArray addObject:music];
    
    //============== CONTENT ENDS HERE ===============
    
    
    
    //==========Last Note for SYNC =============
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             @"0", @"sound",
             @"0", @"overlapRate",
             @"1", @"pitch",
             @"0.75", @"rate",
             nil];
    
    [MusicArray addObject:music];
    //==============ENDS======================
    
    // NSLog( @"%@",MusicArray);
}


-(void) TTLS{
    //=============SYNC NOTE FOR MUSIC ENGINES===============
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             @"0", @"sound",
             @"0", @"overlapRate",
             @"1", @"pitch",
             @"1", @"rate",
             nil];
    
    [MusicArray addObject:music];
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             @"0", @"sound",
             @"0", @"overlapRate",
             @"1", @"pitch",
             @"1", @"rate",
             nil];
    
    [MusicArray addObject:music];
    //=========================
    //rate max: 1.75
    //rate min: 0.1
    
    
    
    //=======CONTENT START HERE============
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             
             @"1", @"sound",
             
             @"-300", @"pitch",
             
             @"1.05", @"rate",
             
             nil];
    
    [MusicArray addObject:music];
    
    
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             
             @"1", @"sound",
             
             @"-300", @"pitch",
             
             @"1.05", @"rate",
             
             nil];
    
    [MusicArray addObject:music];
    
    
    
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             
             @"1", @"sound",
             
             @"400", @"pitch",
             
             @"1.05", @"rate",
             
             nil];
    
    [MusicArray addObject:music];
    
    
    
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             
             @"1", @"sound",
             
             @"400", @"pitch",
             
             @"1.05", @"rate",
             
             nil];
    
    [MusicArray addObject:music];
    
    
    
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             
             @"1", @"sound",
             
             @"600", @"pitch",
             
             @"1.05", @"rate",
             
             nil];
    
    [MusicArray addObject:music];
    
    
    
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             
             @"1", @"sound",
             
             @"600", @"pitch",
             
             @"1.05", @"rate",
             
             nil];
    
    [MusicArray addObject:music];
    
    
    
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             
             @"1", @"sound",
             
             @"400", @"pitch",
             
             @"0.75", @"rate",
             
             nil];
    
    [MusicArray addObject:music];
    
    
    
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             
             @"1", @"sound",
             
             @"200", @"pitch",
             
             @"1.05", @"rate",
             
             nil];
    
    [MusicArray addObject:music];
    
    
    
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             
             @"1", @"sound",
             
             @"200", @"pitch",
             
             @"1.05", @"rate",
             
             nil];
    
    [MusicArray addObject:music];
    
    
    
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             
             @"1", @"sound",
             
             @"100", @"pitch",
             
             @"1.05", @"rate",
             
             nil];
    
    [MusicArray addObject:music];
    
    
    
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             
             @"1", @"sound",
             
             @"100", @"pitch",
             
             @"1.05", @"rate",
             
             nil];
    
    [MusicArray addObject:music];
    
    
    
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             
             @"1", @"sound",
             
             @"-100", @"pitch",
             
             @"1.05", @"rate",
             
             nil];
    
    [MusicArray addObject:music];
    
    
    
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             
             @"1", @"sound",
             
             @"-100", @"pitch",
             
             @"1.05", @"rate",
             
             nil];
    
    [MusicArray addObject:music];
    
    
    
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             
             @"1", @"sound",
             
             @"-300", @"pitch",
             
             @"0.75", @"rate",
             
             nil];
    
    [MusicArray addObject:music];
    
    
    
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             
             @"1", @"sound",
             
             @"400", @"pitch",
             
             @"1.05", @"rate",
             
             nil];
    
    [MusicArray addObject:music];
    
    
    
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             
             @"1", @"sound",
             
             @"400", @"pitch",
             
             @"1.05", @"rate",
             
             nil];
    
    [MusicArray addObject:music];
    
    
    
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             
             @"1", @"sound",
             
             @"200", @"pitch",
             
             @"1.05", @"rate",
             
             nil];
    
    [MusicArray addObject:music];
    
    
    
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             
             @"1", @"sound",
             
             @"200", @"pitch",
             
             @"1.05", @"rate",
             
             nil];
    
    [MusicArray addObject:music];
    
    
    
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             
             @"1", @"sound",
             
             @"100", @"pitch",
             
             @"1.05", @"rate",
             
             nil];
    
    [MusicArray addObject:music];
    
    
    
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             
             @"1", @"sound",
             
             @"100", @"pitch",
             
             @"1.05", @"rate",
             
             nil];
    
    [MusicArray addObject:music];
    
    
    
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             
             @"1", @"sound",
             
             @"-100", @"pitch",
             
             @"0.75", @"rate",
             
             nil];
    
    [MusicArray addObject:music];
    
    
    
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             
             @"1", @"sound",
             
             @"400", @"pitch",
             
             @"1.05", @"rate",
             
             nil];
    
    [MusicArray addObject:music];
    
    
    
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             
             @"1", @"sound",
             
             @"400", @"pitch",
             
             @"1.05", @"rate",
             
             nil];
    
    [MusicArray addObject:music];
    
    
    
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             
             @"1", @"sound",
             
             @"200", @"pitch",
             
             @"1.05", @"rate",
             
             nil];
    
    [MusicArray addObject:music];
    
    
    
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             
             @"1", @"sound",
             
             @"200", @"pitch",
             
             @"1.05", @"rate",
             
             nil];
    
    [MusicArray addObject:music];
    
    
    
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             
             @"1", @"sound",
             
             @"100", @"pitch",
             
             @"1.05", @"rate",
             
             nil];
    
    [MusicArray addObject:music];
    
    
    
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             
             @"1", @"sound",
             
             @"100", @"pitch",
             
             @"1.05", @"rate",
             
             nil];
    
    [MusicArray addObject:music];
    
    
    
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             
             @"1", @"sound",
             
             @"-100", @"pitch",
             
             @"0.75", @"rate",
             
             nil];
    
    [MusicArray addObject:music];
    
    
    
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             
             @"1", @"sound",
             
             @"-300", @"pitch",
             
             @"1.05", @"rate",
             
             nil];
    
    [MusicArray addObject:music];
    
    
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             
             @"1", @"sound",
             
             @"-300", @"pitch",
             
             @"1.05", @"rate",
             
             nil];
    
    [MusicArray addObject:music];
    
    
    
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             
             @"1", @"sound",
             
             @"400", @"pitch",
             
             @"1.05", @"rate",
             
             nil];
    
    [MusicArray addObject:music];
    
    
    
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             
             @"1", @"sound",
             
             @"400", @"pitch",
             
             @"1.05", @"rate",
             
             nil];
    
    [MusicArray addObject:music];
    
    
    
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             
             @"1", @"sound",
             
             @"600", @"pitch",
             
             @"1.05", @"rate",
             
             nil];
    
    [MusicArray addObject:music];
    
    
    
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             
             @"1", @"sound",
             
             @"600", @"pitch",
             
             @"1.05", @"rate",
             
             nil];
    
    [MusicArray addObject:music];
    
    
    
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             
             @"1", @"sound",
             
             @"400", @"pitch",
             
             @"0.75", @"rate",
             
             nil];
    
    [MusicArray addObject:music];
    
    
    
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             
             @"1", @"sound",
             
             @"200", @"pitch",
             
             @"1.05", @"rate",
             
             nil];
    
    [MusicArray addObject:music];
    
    
    
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             
             @"1", @"sound",
             
             @"200", @"pitch",
             
             @"1.05", @"rate",
             
             nil];
    
    [MusicArray addObject:music];
    
    
    
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             
             @"1", @"sound",
             
             @"100", @"pitch",
             
             @"1.05", @"rate",
             
             nil];
    
    [MusicArray addObject:music];
    
    
    
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             
             @"1", @"sound",
             
             @"100", @"pitch",
             
             @"1.05", @"rate",
             
             nil];
    
    [MusicArray addObject:music];
    
    
    
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             
             @"1", @"sound",
             
             @"-100", @"pitch",
             
             @"1.05", @"rate",
             
             nil];
    
    [MusicArray addObject:music];
    
    
    
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             
             @"1", @"sound",
             
             @"-100", @"pitch",
             
             @"1.05", @"rate",
             
             nil];
    
    [MusicArray addObject:music];
    
    
    
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             
             @"1", @"sound",
             
             @"-300", @"pitch",
             
             @"0.75", @"rate",
             
             nil];
    
    [MusicArray addObject:music];
    //======
    
    
    //==========Last Note for SYNC =============
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             @"0", @"sound",
             @"0", @"overlapRate",
             @"1", @"pitch",
             @"0.75", @"rate",
             nil];
    
    [MusicArray addObject:music];
    //==============ENDS======================
    
    // NSLog( @"%@",MusicArray);
}

-(void) Lullaby{
    
    //=============SYNC NOTE FOR MUSIC ENGINES===============
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             @"0", @"sound",
             @"0", @"overlapRate",
             @"1", @"pitch",
             @"1", @"rate",
             nil];
    
    [MusicArray addObject:music];
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             @"0", @"sound",
             @"0", @"overlapRate",
             @"1", @"pitch",
             @"1", @"rate",
             nil];
    
    [MusicArray addObject:music];
    //=========================
    
    
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             
             
             @"1", @"sound",
             
             
             @"-600", @"pitch",
             
             
             @"1.0", @"rate",
             
             
             nil];
    
    
    [MusicArray addObject:music];
    
    
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             
             
             @"1", @"sound",
             
             
             @"-600", @"pitch",
             
             
             @"1.0", @"rate",
             
             
             nil];
    
    
    [MusicArray addObject:music];
    
    
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             
             
             @"1", @"sound",
             
             
             @"-300", @"pitch",
             
             
             @"0.7", @"rate",
             
             
             nil];
    
    
    [MusicArray addObject:music];
    
    
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             
             
             @"1", @"sound",
             
             
             @"-600", @"pitch",
             
             
             @"1.0", @"rate",
             
             
             nil];
    
    
    [MusicArray addObject:music];
    
    
    
    
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             
             
             @"1", @"sound",
             
             
             @"-600", @"pitch",
             
             
             @"0.8", @"rate",
             
             
             nil];
    
    
    [MusicArray addObject:music];
    
    
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             
             
             @"1", @"sound",
             
             
             @"-300", @"pitch",
             
             
             @"0.5", @"rate",
             
             
             nil];
    
    
    [MusicArray addObject:music];
    
    
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             
             
             @"1", @"sound",
             
             
             @"-600", @"pitch",
             
             
             @"1.0", @"rate",
             
             
             nil];
    
    
    [MusicArray addObject:music];
    
    
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             
             
             @"1", @"sound",
             
             
             @"-300", @"pitch",
             
             
             @"1.0", @"rate",
             
             
             nil];
    
    
    [MusicArray addObject:music];
    
    
    
    
    
    
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             
             
             @"1", @"sound",
             
             
             @"200", @"pitch",
             
             
             @"0.8", @"rate",
             
             
             nil];
    
    
    [MusicArray addObject:music];
    
    
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             
             
             @"1", @"sound",
             
             
             @"100", @"pitch",
             
             
             @"0.7", @"rate",
             
             
             nil];
    
    
    [MusicArray addObject:music];
    
    
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             
             
             @"1", @"sound",
             
             
             @"-100", @"pitch",
             
             
             @"1.0", @"rate",
             
             
             nil];
    
    
    [MusicArray addObject:music];
    
    
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             
             
             @"1", @"sound",
             
             
             @"-100", @"pitch",
             
             
             @"0.8", @"rate",
             
             
             nil];
    
    
    [MusicArray addObject:music];
    
    
    
    
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             
             
             @"1", @"sound",
             
             
             @"-300", @"pitch",
             
             
             @"0.8", @"rate",
             
             
             nil];
    
    
    [MusicArray addObject:music];
    
    
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             
             
             @"1", @"sound",
             
             
             @"-800", @"pitch",
             
             
             @"1.0", @"rate",
             
             
             nil];
    
    
    [MusicArray addObject:music];
    
    
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             
             
             @"1", @"sound",
             
             
             @"-600", @"pitch",
             
             
             @"1.0", @"rate",
             
             
             nil];
    
    
    [MusicArray addObject:music];
    
    
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             
             
             @"1", @"sound",
             
             
             @"-500", @"pitch",
             
             
             @"0.8", @"rate",
             
             
             nil];
    
    
    [MusicArray addObject:music];
    
    
    
    
    
    
    
    
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             
             
             @"1", @"sound",
             
             
             @"-800", @"pitch",
             
             
             @"0.8", @"rate",
             
             
             nil];
    
    
    [MusicArray addObject:music];
    
    
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             
             
             @"1", @"sound",
             
             
             @"-800", @"pitch",
             
             
             @"1.0", @"rate",
             
             
             nil];
    
    
    [MusicArray addObject:music];
    
    
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             
             
             @"1", @"sound",
             
             
             @"-600", @"pitch",
             
             
             @"1.0", @"rate",
             
             
             nil];
    
    
    [MusicArray addObject:music];
    
    
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             
             
             @"1", @"sound",
             
             
             @"-500", @"pitch",
             
             
             @"0.5", @"rate",
             
             
             nil];
    
    
    [MusicArray addObject:music];
    
    
    
    
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             
             
             @"1", @"sound",
             
             
             @"-800", @"pitch",
             
             
             @"1.0", @"rate",
             
             
             nil];
    
    
    [MusicArray addObject:music];
    
    
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             
             
             @"1", @"sound",
             
             
             @"-500", @"pitch",
             
             
             @"1.0", @"rate",
             
             
             nil];
    
    
    [MusicArray addObject:music];
    
    
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             
             
             @"1", @"sound",
             
             
             @"100", @"pitch",
             
             
             @"1.0", @"rate",
             
             
             nil];
    
    
    [MusicArray addObject:music];
    
    
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             
             
             @"1", @"sound",
             
             
             @"-100", @"pitch",
             
             
             @"1.0", @"rate",
             
             
             nil];
    
    
    [MusicArray addObject:music];
    
    
    
    
    
    
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             
             
             @"1", @"sound",
             
             
             @"-300", @"pitch",
             
             
             @"0.8", @"rate",
             
             
             nil];
    
    
    [MusicArray addObject:music];
    
    
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             
             
             @"1", @"sound",
             
             
             @"100", @"pitch",
             
             
             @"0.8", @"rate",
             
             
             nil];
    
    
    [MusicArray addObject:music];
    
    
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             
             
             @"1", @"sound",
             
             
             @"200", @"pitch",
             
             
             @"0.5", @"rate",
             
             
             nil];
    
    
    [MusicArray addObject:music];
    
    
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             
             
             @"1", @"sound",
             
             
             @"-1000", @"pitch",
             
             
             @"1.0", @"rate",
             
             
             nil];
    
    
    [MusicArray addObject:music];
    
    
    
    
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             
             
             @"1", @"sound",
             
             
             @"-1000", @"pitch",
             
             
             @"1.0", @"rate",
             
             
             nil];
    
    
    [MusicArray addObject:music];
    
    
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             
             
             @"1", @"sound",
             
             
             @"200", @"pitch",
             
             
             @"0.5", @"rate",
             
             
             nil];
    
    
    [MusicArray addObject:music];
    
    
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             
             
             @"1", @"sound",
             
             
             @"-100", @"pitch",
             
             
             @"1.0", @"rate",
             
             
             nil];
    
    
    [MusicArray addObject:music];
    
    
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             
             
             @"1", @"sound",
             
             
             @"-500", @"pitch",
             
             
             @"1.0", @"rate",
             
             
             nil];
    
    
    [MusicArray addObject:music];
    
    
    
    
    
    
    
    
    
    
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             
             
             @"1", @"sound",
             
             
             @"-300", @"pitch",
             
             
             @"0.5", @"rate",
             
             
             nil];
    
    
    [MusicArray addObject:music];
    
    
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             
             
             @"1", @"sound",
             
             
             @"-600", @"pitch",
             
             
             @"1.0", @"rate",
             
             
             nil];
    
    
    [MusicArray addObject:music];
    
    
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             
             
             @"1", @"sound",
             
             
             @"-1000", @"pitch",
             
             
             @"1.0", @"rate",
             
             
             nil];
    
    
    [MusicArray addObject:music];
    
    
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             
             
             @"1", @"sound",
             
             
             @"-500", @"pitch",
             
             
             @"0.8", @"rate",
             
             
             nil];
    
    
    [MusicArray addObject:music];
    
    
    
    
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             
             
             @"1", @"sound",
             
             
             @"-300", @"pitch",
             
             
             @"0.8", @"rate",
             
             
             nil];
    
    
    [MusicArray addObject:music];
    
    
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             
             
             @"1", @"sound",
             
             
             @"-100", @"pitch",
             
             
             @"0.8", @"rate",
             
             
             nil];
    
    
    [MusicArray addObject:music];
    
    
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             
             
             @"1", @"sound",
             
             
             @"-600", @"pitch",
             
             
             @"1.0", @"rate",
             
             
             nil];
    
    
    [MusicArray addObject:music];
    
    
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             
             
             @"1", @"sound",
             
             
             @"-300", @"pitch",
             
             
             @"0.7", @"rate",
             
             
             nil];
    
    
    [MusicArray addObject:music];
    
    
    
    
    
    
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             
             
             @"1", @"sound",
             
             
             @"-1000", @"pitch",
             
             
             @"1.0", @"rate",
             
             
             nil];
    
    
    [MusicArray addObject:music];
    
    
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             
             
             @"1", @"sound",
             
             
             @"-1000", @"pitch",
             
             
             @"1.0", @"rate",
             
             
             nil];
    
    
    [MusicArray addObject:music];
    
    
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             
             
             @"1", @"sound",
             
             
             @"200", @"pitch",
             
             
             @"0.5", @"rate",
             
             
             nil];
    
    
    [MusicArray addObject:music];
    
    
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             
             
             @"1", @"sound",
             
             
             @"-100", @"pitch",
             
             
             @"1.0", @"rate",
             
             
             nil];
    
    
    [MusicArray addObject:music];
    
    
    
    
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             
             
             @"1", @"sound",
             
             
             @"-500", @"pitch",
             
             
             @"1.0", @"rate",
             
             
             nil];
    
    
    [MusicArray addObject:music];
    
    
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             
             
             @"1", @"sound",
             
             
             @"-300", @"pitch",
             
             
             @"0.5", @"rate",
             
             
             nil];
    
    
    [MusicArray addObject:music];
    
    
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             
             
             @"1", @"sound",
             
             
             @"-600", @"pitch",
             
             
             @"1.0", @"rate",
             
             
             nil];
    
    
    [MusicArray addObject:music];
    
    
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             
             
             @"1", @"sound",
             
             
             @"-1000", @"pitch",
             
             
             @"1.0", @"rate",
             
             
             nil];
    
    
    [MusicArray addObject:music];
    
    
    
    
    
    
    
    
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             
             
             @"1", @"sound",
             
             
             @"-500", @"pitch",
             
             
             @"1.0", @"rate",
             
             
             nil];
    
    
    [MusicArray addObject:music];
    
    
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             
             
             @"1", @"sound",
             
             
             @"-300", @"pitch",
             
             
             @"1.6", @"rate",
             
             
             nil];
    
    
    [MusicArray addObject:music];
    
    
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             
             
             @"1", @"sound",
             
             
             @"-500", @"pitch",
             
             
             @"1.6", @"rate",
             
             
             nil];
    
    
    [MusicArray addObject:music];
    
    
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             
             
             @"1", @"sound",
             
             
             @"-600", @"pitch",
             
             
             @"0.8", @"rate",
             
             
             nil];
    
    
    [MusicArray addObject:music];
    
    
    
    
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             
             
             @"1", @"sound",
             
             
             @"-800", @"pitch",
             
             
             @"0.8", @"rate",
             
             
             nil];
    
    
    [MusicArray addObject:music];
    
    
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             
             
             @"1", @"sound",
             
             
             @"-1000", @"pitch",
             
             
             @"0.5", @"rate",
             
             
             nil];
    
    
    [MusicArray addObject:music];
    
    //===========
    
    music = [NSDictionary dictionaryWithObjectsAndKeys:
             @"0", @"sound",
             @"0", @"overlapRate",
             @"1", @"pitch",
             @"0.75", @"rate",
             nil];
    
    [MusicArray addObject:music];
    //==============ENDS======================
    
    
    
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

