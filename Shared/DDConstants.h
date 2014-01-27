//
//  DTDConstants.h
//  DoTheDancing-SpriteKit
//
//  Created by Michael Gao on 12/15/13.
//  Copyright (c) 2013 Chin and Cheeks LLC. All rights reserved.
//

#ifndef DoTheDancing_SpriteKit_DTDConstants_h
#define DoTheDancing_SpriteKit_DTDConstants_h

typedef enum
{
    kSceneTypeNone = -1,
    kSceneTypeTestMotion,
    kSceneTypeMainMenu,
    kSceneTypeDanceMoveSelection,
    kSceneTypeDanceMoveInstructions,
    kSceneTypeDanceMoveSeeInAction,
    kSceneTypeDanceMoveDance,
    kSceneTypeDanceMoveResults,
    kSceneTypeMultiplayerHostOrJoin,
    kSceneTypeMultiplayerWaitingRoom,
    kSceneTypeSearchingForIpad,
    kSceneTypeConnectedToIpad,
} SceneTypes;

typedef enum
{
    kDanceMoveNone = -1,
    kDanceMoveBernie,
    kDanceMoveNum
} DanceMoves;

typedef enum
{
    kAudioManagerUninitialized = 0,
    kAudioManagerFailed = 1,
    kAudioManagerInitializing = 2,
    kAudioManagerInitialized = 100,
    kAudioManagerLoading = 200,
    kAudioManagerReady = 300
} GameManagerSoundState;

typedef enum
{
    QuitReasonNone,
	QuitReasonNoNetwork,          // no Wi-Fi or Bluetooth
	QuitReasonConnectionDropped,  // communication failure with server
	QuitReasonUserQuit,           // the user terminated the connection
	QuitReasonHostQuit,           // the host quit the game (on purpose)
} QuitReason;

#define kServiceType @"dtd-service"
#define kSessionContextType @"dtd-connect-context"
#define kPeerConnectionAcceptedNotification @"com.chinandcheeks.DoTheDancing-SpriteKit:PeerConnectionAcceptedNotification"
#define kPeerDidReceiveDataNotification @"com.chinandcheeks.DoTheDancing-SpriteKit:PeerDidReceiveDataNotification"

#define kDanceMoveBernieName @"Bernie"

#define kStep1_SFX @"step1_alice.caf"
#define kStep2_SFX @"step2_alice.caf"

#define kYawMin -400.0
#define kYawMax 400.0
#define kPitchMin -400.0
#define kPitchMax 400.0
#define kRollMin -400.0
#define kRollMax 400.0
#define kAccelerationXMin -1000.0
#define kAccelerationXMax 1000.0
#define kAccelerationYMin -1000.0
#define kAccelerationYMax 1000.0
#define kAccelerationZMin -1000.0
#define kAccelerationZMax 1000.0

#define DegreesToRadians(d) (M_PI * (d) / 180.0f)
#define RadiansToDegrees(r) ((r) * 180.0f / M_PI)

#define RGBA(r,g,b,a)				[SKColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b)					RGBA(r, g, b, 1.0f)

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_5 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 568.0f)
#define IS_IPHONE_4 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 480.0f)

#endif
