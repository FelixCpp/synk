// Declarations for the slice of AVConference.framework that synk needs.
//
// AVConference lives in /System/Library/PrivateFrameworks and ships no headers.
// Unlike CoreDevice it is Objective-C, so the declarations below are the plain
// interface — no .swiftinterface reconstruction, and every name is checked by
// the linker.
//
// synk only needs the *negotiator*. CoreDevice's media stream carries an opaque
// offer/answer blob that only AVConference can produce and read; once the
// handshake is done the device sends plain RTP, which synk receives itself. So
// the receiving half of AVConference (AVCVideoStream, AVCVideoDataOutput, …)
// stays out of this file on purpose.
#import <Foundation/Foundation.h>

/// Mode for -[AVCMediaStreamNegotiator initWithMode:options:error:].
///
/// The values are not published anywhere; they were determined by walking the
/// modes and reading back which AVCMediaStreamNegotiatorSettings subclass each
/// one produced (…SettingsCoreDeviceScreenSharing / …SettingsCoreDeviceSystemAudio).
typedef NS_ENUM(NSInteger, SynkAVCMediaStreamMode) {
  SynkAVCMediaStreamModeCoreDeviceScreenSharing = 5,
  SynkAVCMediaStreamModeCoreDeviceSystemAudio = 6,
};

@interface AVCMediaStreamNegotiator : NSObject
- (instancetype)initWithMode:(NSInteger)mode
                     options:(NSDictionary *)options
                       error:(NSError **)error;
- (BOOL)createOffer;
- (BOOL)setAnswer:(NSData *)answer withError:(NSError **)error NS_SWIFT_NAME(setAnswer(_:));
- (BOOL)processAnswerWithError:(NSError **)error errorReason:(NSString **)reason;
- (nullable NSDictionary *)generateMediaStreamInitOptionsWithError:(NSError **)error;
@property(nonatomic, strong) NSData *offer;
@property(nonatomic, strong) NSData *answer;
@end

/// `processAnswerWithError:errorReason:` puts its NSError** in a non-final
/// position, so Swift imports it as a pair of raw pointers instead of a
/// throwing call. Wrapping it keeps the Swift side readable.
static inline BOOL SynkNegotiatorProcessAnswer(AVCMediaStreamNegotiator *negotiator,
                                               NSError **error, NSString **reason) {
  return [negotiator processAnswerWithError:error errorReason:reason];
}

extern NSString *kAVCMediaStreamOptionCallID;
extern NSString *kAVCMediaStreamOptionClientName;
extern NSString *kAVCMediaStreamOptionClientPID;
extern NSString *kAVCMediaStreamOptionClientSessionID;
extern NSString *kAVCMediaStreamOptionIsOriginator;
