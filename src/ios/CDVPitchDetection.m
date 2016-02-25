//
//  CDVPitchDetection.m
//  Basic_Audio_Watermarks
//
//  Created by Andrew Trice on 12/4/12.
//
//

#import "CDVPitchDetection.h"

@implementation CDVPitchDetection

@synthesize isListening;
@synthesize	rioRef;
@synthesize currentFrequency;
@synthesize registeredFrequencies;
static float matchFrequency = 0.0;
static CDVPitchDetection * cid= nil;
static bool otherfreq = false;
static int count = 0;
//- (CDVPlugin*)initWithWebView:(UIWebView*)theWebView
//{
//    self = [super initWithWebView:theWebView];
//    if (self) {
//        self.registeredFrequencies = [[NSMutableArray alloc] init];
//        self.rioRef = [RIOInterface sharedInstance];
//        [rioRef setSampleRate:44100];
//        [rioRef setFrequency:1000];
//        [rioRef initializeAudioSession];
//    }
//    return self;
//}

-(void)pluginInitialize{
    NSLog(@"initialize");
    // self.rioRef = [RIOInterface sharedInstance];
    self.registeredFrequencies = [[NSMutableArray alloc] initWithCapacity:10];
    // matchFrequency = 0.0;
    // matchFrequency = 0.0;
    // [rioRef setSampleRate:44100];
    //[rioRef setFrequency:16000];
    // [rioRef initializeAudioSession];
    // NSLog(@"after initialize");
    // cid = self;
}


- (void)startListener:(CDVInvokedUrlCommand*)command {
    NSLog(@"Start LIstener");
    [rioRef setSampleRate:44100];
    //[rioRef setFrequency:294];
    [rioRef initializeAudioSession];
    NSLog(@"after initialize");
    isListening = YES;
    [rioRef startListening:self];
    NSLog(@"Start LIstener");
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"listener started"];
    [pluginResult setKeepCallback:[NSNumber numberWithBool:YES]];
    cid = self;
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)stopListener:(CDVInvokedUrlCommand*)command {
    NSLog(@"Stop LIstener");
    isListening = NO;
    [rioRef stopListening];
    matchFrequency = 0.0;
    otherfreq = NO;
    count = 0;
    [self.registeredFrequencies removeAllObjects];
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"listener stopped"];
    //[pluginResult setKeepCallback:[NSNumber numberWithBool:YES]];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}


- (void)registerFrequency:(CDVInvokedUrlCommand*)command {
    
    NSString *frequencyString = [command.arguments objectAtIndex:0];
    float frequency = [frequencyString floatValue];
    self.rioRef = [RIOInterface sharedInstance];
    matchFrequency = 0.0;
    NSLog(@"registerFrequency called %f",frequency);
    [self.registeredFrequencies addObject:frequencyString];
    matchFrequency = [frequencyString floatValue];
    bool a = [[command.arguments objectAtIndex:1] boolValue];
    NSLog(@"A = %d",a);
    if(a){
        otherfreq = YES;
        NSLog(@"otherfreq : %d", otherfreq);
    }
    NSLog(@"registerfrequency : %f", matchFrequency);
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:self.registeredFrequencies];
    //[pluginResult setKeepCallback:[NSNumber numberWithBool:YES]];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)unregisterFrequency:(CDVInvokedUrlCommand*)command {
    // NSLog(@"unregisterFrequency called");
    // NSString* frequency = [command.arguments objectAtIndex:0];
    //TODO
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"frequency unregistered"];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}



// This method gets called by the rendering function. Do something with the new frequency
- (void)frequencyChangedWithValue:(float)newFrequency{
    //NSLog(@"frequencyChangeWithValue called %f", newFrequency);
    //	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    //
    //
    //	[pool drain];
    //    pool = nil;
   // NSLog( @"frequencyChangedWithValue: %f", matchFrequency);
    @autoreleasepool {
       // NSLog( @"frequencyChangedWithValue: %f", matchFrequency );
        
        //int x = 0;
        float buffer = 100;
 
        float minFrequency = matchFrequency - buffer;
        float maxFrequency = matchFrequency + buffer;

        NSLog(@"otherfreq: %d", otherfreq);
        if ( newFrequency >= minFrequency && newFrequency <= maxFrequency ) {
            self.currentFrequency = matchFrequency;
            [self performSelectorOnMainThread:@selector(updateFrequency) withObject:nil waitUntilDone:NO];
            
        } else {
            NSLog(@"minFrequency: %f", minFrequency);
            NSLog(@"maxFrequency: %f", maxFrequency);
            NSLog(@"newFrequency: %f", newFrequency);
            NSLog(@"otherfreq: %d", count);
            if(otherfreq){
                count++;
                if(count > 4){
                    self.currentFrequency = newFrequency;
                    [self performSelectorOnMainThread:@selector(otherFrequencyUpdate) withObject:nil waitUntilDone:NO];
                }
            }
        }
        
    }
}

- (void)updateFrequency {
    //NSLog( @"updateFrequency called %f",self.currentFrequency);
    @autoreleasepool {
        NSDictionary* freqData = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:self.currentFrequency] forKey:@"frequency"];
        //NSString *js = [NSString stringWithFormat:@"window.plugins.pitchDetect.executeCallback('%@')", freqData];
        NSData *jData = [NSJSONSerialization dataWithJSONObject:freqData options:0 error:nil];
        NSString *jsData = [[NSString alloc] initWithData:jData encoding:NSUTF8StringEncoding];
        NSString *js = [NSString stringWithFormat:@"window.plugins.pitchDetect.executeCallback('%@')", jsData];
        [cid.commandDelegate evalJs:js];
        //matchFrequency = 0.0;
    }
    //NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    
    //[pool drain];
    //pool = nil;
    
}

- (void) otherFrequencyUpdate {
    NSLog( @"otherFrequencyUpdate called %f",self.currentFrequency);
    @autoreleasepool {
        NSDictionary* freqData1 = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:self.currentFrequency] forKey:@"frequency"];
        //NSString *js = [NSString stringWithFormat:@"window.plugins.pitchDetect.executeCallback('%@')", freqData];
        NSData *jData1= [NSJSONSerialization dataWithJSONObject:freqData1 options:0 error:nil];
        NSString *jsData1 = [[NSString alloc] initWithData:jData1 encoding:NSUTF8StringEncoding];
        NSString *js = [NSString stringWithFormat:@"window.plugins.pitchDetect.otherfrequency('%@')", jsData1];
        [cid.commandDelegate evalJs:js];
        count = 0;
        //matchFrequency = 0.0;
    }

}

static CDVPitchDetection *sharedInstance = nil;

#pragma mark -
#pragma mark Singleton Methods
+ (CDVPitchDetection *)sharedInstance
{
    if (sharedInstance == nil) {
        sharedInstance = [[CDVPitchDetection alloc] init];
    }
    
    return sharedInstance;
}

@end
