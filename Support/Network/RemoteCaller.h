//
//  RemoteCaller.h
//  iPadBeamBack
//
//  Created by Bilal Nazir on 7/12/10.
//  Copyright 2010 Home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMFRemotingCall.h"

#import "SERVER.h"

@protocol RemoteCallerDelegate;

@interface RemoteCaller : NSObject <AMFRemotingCallDelegate>
{
	NSString *AMFRemotingService;
	AMFRemotingCall *m_remotingCall;
	NSObject <RemoteCallerDelegate> *m_delegate;
	
	NSString *lastMethodInvoked;
}

@property (nonatomic, assign) NSObject <RemoteCallerDelegate> *delegate;
@property (nonatomic, retain) NSString *lastMethodInvoked;
@property (nonatomic, retain) NSString *AMFRemotingService;
- (id)initWithRemotingService:(NSString *)remotingService withRemotCallingURL:(NSString *)remotURL;
@end



@protocol RemoteCallerDelegate
- (void)callerDidFinishLoading:(RemoteCaller *)caller receivedObject:(NSObject *)object;
- (void)caller:(RemoteCaller *)caller didFailWithError:(NSError *)error;
@end