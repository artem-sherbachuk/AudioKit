//
//  AKSettings.h
//  AudioKit
//
//  Created by Stéphane Peter on 4/8/15.
//  Copyright (c) 2015 AudioKit. All rights reserved.
//

#import <Foundation/Foundation.h>

// These values are initialized from AudioKit.plist if it is present in the app bundle

@interface AKSettings : NSObject

+ (AKSettings * __nonnull)settings;

@property (nonatomic, readonly, nonnull) NSString *audioInput, *audioOutput;
@property (nonatomic, readonly) UInt32 sampleRate, samplesPerControlPeriod;
@property (nonatomic, readonly) UInt16 numberOfChannels;
@property (nonatomic, readonly) float zeroDBFullScaleValue;
@property (nonatomic, readonly) BOOL loggingEnabled, audioInputEnabled, messagesEnabled;

@end
