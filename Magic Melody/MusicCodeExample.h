//
//  Header.h
//  Magic Melody
//
//  Created by Angela Tang on 2016-12-21.
//  Copyright © 2016 zixin. All rights reserved.
//

#ifndef Header_h
#define Header_h


#endif /* Header_h */

//This is just an example of how Music is created by code,
//It will create a json text file format and store in MusicArray
//Please store json as NSMutableArray when downloaded from server or import from text file


//implement of real array with dictionary
NSDictionary *music;
NSMutableArray *MusicArray;
//


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
