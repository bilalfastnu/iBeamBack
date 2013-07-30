//
//  ChatManager.m
//  iBeamBack
//
//  Created by Sumaira Nazir on 4/17/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import "ChatManager.h"
//#import "User.h"
#import "UserManager.h"



#import "XMPP.h"
#import "XMPPRosterCoreDataStorage.h"

#import "DDLog.h"
#import "DDTTYLogger.h"

#import <CFNetwork/CFNetwork.h>


// Log levels: off, error, warn, info, verbose
static const int ddLogLevel = LOG_LEVEL_VERBOSE;


NSString * const HostName = @"ali-hasans-mac-mini-2.local";
#define HOSTPORT 5222

@implementation ChatManager

SYNTHESIZE_SINGLETON_FOR_CLASS(ChatManager);

@synthesize xmppStream;
@synthesize xmppRoster;
@synthesize xmppRosterStorage;
@synthesize delegate;
@synthesize loginedUserId;




-(NSString*)getUserJId:(NSString*)userName
{
    NSString *userId = nil;
    if ([userName compare:@"sumaira"] == NSOrderedSame) {
        userId = @"sumaira@ali-hasans-mac-mini-2.local";
        
    }
    if ([userName compare:@"umar"] == NSOrderedSame) {
        userId = @"umar@ali-hasans-mac-mini-2.local";
        
    }
    if ([userName compare:@"bilal"] == NSOrderedSame) {
        userId = @"bilal@ali-hasans-mac-mini-2.local";
    }
    return userId;
}


-(id)init{
    
    self = [super init];
    if (self != nil) {
        
        // Configure logging framework
        
        [DDLog addLogger:[DDTTYLogger sharedInstance]];
        
        // Initialize variables
        
        xmppStream = [[XMPPStream alloc] init];
        
        xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] init];
        xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:xmppRosterStorage];
        
        // Configure modules
        
        [xmppRoster setAutoRoster:YES];
        
        // Activate xmpp modules
        
        [xmppRoster activate:xmppStream];
        
        // Add ourself as a delegate to anything we may be interested in
        
        [xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
        
        // Configure and start xmpp stream
        
        // Optional:
        // 
        // Replace me with the proper domain and port.
        // The example below is setup for a typical google talk account.
        // 
        // If you don't supply a hostName, then it will be automatically resolved using the JID (below).
        // For example, if you supply a JID like 'user@quack.com/rsrc'
        // then the xmpp framework will follow the xmpp specification, and do a SRV lookup for quack.com.
        // 
        // If you don't specify a hostPort, then the default (5222) will be used.
        
        
        
        [xmppStream setHostName:HostName];
        [xmppStream setHostPort:HOSTPORT];
        UserManager *userManager =[UserManager sharedUserManager];
       // User *user = userManager.currentUser;
        
         //NSString *userId = [userManager getCurrentUserId];
       // NSString *userId =userManager.currentUser.userId;
        
        //NSString *userName = [userManager getFirstName:userId];
        NSString *userName =userManager.currentUser.firstName;
        userName =[userName lowercaseString];
        
        if ([userName compare:@"sumaira"] == NSOrderedSame) {
           
            [xmppStream setMyJID:[XMPPJID jidWithString:@"sumaira@ali-hasans-mac-mini-2.local"]];       
            password = @"sumaira";
            
        }
        if ([userName compare:@"umar"] == NSOrderedSame) {
            [xmppStream setMyJID:[XMPPJID jidWithString:@"umar@ali-hasans-mac-mini-2.local"]];       
            password = @"umar";
            
        }
        if ([userName compare:@"bilal"] == NSOrderedSame) {
            [xmppStream setMyJID:[XMPPJID jidWithString:@"bilal@ali-hasans-mac-mini-2.local"]];       
            password = @"bilal";
        }
        loginedUserId = [self getUserJId:userName];
        
        //[xmppStream setMyJID:[XMPPJID jidWithString:@"ali@sumaira-nazirs-imac.local/xmppframework"]];       
       // password = @"ali";
        
      /*  NSString *currentUserJID = [self getUserJId:userName];
        
       [xmppStream setMyJID:[XMPPJID jidWithString:currentUserJID]];
          password = userName;
        
         NSLog(@"Current Id :-%@-",currentUserJID);
         
         NSLog(@"Password :-%@-",password);
        
        // Required:
        // 
        // Replace me with the proper JID and password
       [xmppStream setMyJID:[XMPPJID jidWithString:@"ali@sumaira-nazirs-imac.local/xmppframework"]];       
         [xmppStream setMyJID:[XMPPJID jidWithString:@"sumaira@sumaira-nazirs-imac.local"]];       
        password = @"sumaira";*/
       
        
        
        // You may need to alter these settings depending on the server you're connecting to
        allowSelfSignedCertificates = NO;
        allowSSLHostNameMismatch = NO;
        
        // Uncomment me when the proper information has been entered above.
        NSError *error = nil;
        if (![xmppStream connect:&error])
        {
            NSLog(@"Error connecting: %@", error);
        }
        
       
        
    }
    
    return self;
}


-(void)dealloc{
    [xmppStream removeDelegate:self];
    [xmppRoster removeDelegate:self];
    
    [xmppStream disconnect];
    [xmppStream release];
    [xmppRoster release];
    
    [password release];
    
    
    [super dealloc];
}



////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Custom
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// It's easy to create XML elments to send and to read received XML elements.
// You have the entire NSXMLElement and NSXMLNode API's.
// 
// In addition to this, the NSXMLElementAdditions class provides some very handy methods for working with XMPP.
// 
// On the iPhone, Apple chose not to include the full NSXML suite.
// No problem - we use the KissXML library as a drop in replacement.
// 
// For more information on working with XML elements, see the Wiki article:
// http://code.google.com/p/xmppframework/wiki/WorkingWithElements

- (void)goOnline
{
	NSXMLElement *presence = [NSXMLElement elementWithName:@"presence"];
	
	[[self xmppStream] sendElement:presence];
}

- (void)goOffline
{
	NSXMLElement *presence = [NSXMLElement elementWithName:@"presence"];
	[presence addAttributeWithName:@"type" stringValue:@"unavailable"];
	
	[[self xmppStream] sendElement:presence];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Utility methods
//////////////////////////////////////////////////////////////////////////////////////////////////////////


-(NSString*)getTimeStamp{
	
	//if (true) { 
    time_t latestTimestamp;
    
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle]; // Jan 1, 2010
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];  // 1:43 PM
    
    time_t now; time(&now);
    latestTimestamp = now;
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:latestTimestamp];
    
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]; // TODO: get locale from iPhone system prefs
    [dateFormatter setLocale:usLocale];
    [usLocale release];
    
    return ( [dateFormatter stringFromDate:date]);
    
	//}
}

-(ChatItem*)convertMsgToChatItem:(XMPPMessage*)receivedMsg
{
    ChatItem *newItem = [[ChatItem alloc]init];
    
    newItem.toUserId = [receivedMsg attributeStringValueForName:@"to"];
    newItem.fromUserId =[receivedMsg attributeStringValueForName:@"from"];    
    newItem.textMessage =[[receivedMsg elementForName:@"body"] stringValue];
    newItem.timeStamp = [self getTimeStamp];
    NSLog(@"receivedMsg %@",newItem);
    return newItem;
    
}
-(NSXMLElement*)converMsgToNSXML:(ChatItem*)sendingMsg{
    
    NSXMLElement * xmlMessage = [NSXMLElement elementWithName:@"message"];
    // [xmlMessage addAttributeWithName:@"to" stringValue:sendingMsg.toUserId];
    [xmlMessage addAttributeWithName:@"to" stringValue:sendingMsg.toUserId];
    [xmlMessage addAttributeWithName:@"type" stringValue:@"chat"];
    
    DDXMLNode *body = [DDXMLNode elementWithName:@"body" stringValue:sendingMsg.textMessage];
    [xmlMessage addChild:body];
    return xmlMessage;
}




//////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark XMPPStream Delegate
//////////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)xmppStream:(XMPPStream *)sender willSecureWithSettings:(NSMutableDictionary *)settings
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
	
	if (allowSelfSignedCertificates)
	{
		[settings setObject:[NSNumber numberWithBool:YES] forKey:(NSString *)kCFStreamSSLAllowsAnyRoot];
	}
	
	if (allowSSLHostNameMismatch)
	{
		[settings setObject:[NSNull null] forKey:(NSString *)kCFStreamSSLPeerName];
	}
	else
	{
		// Google does things incorrectly (does not conform to RFC).
		// Because so many people ask questions about this (assume xmpp framework is broken),
		// I've explicitly added code that shows how other xmpp clients "do the right thing"
		// when connecting to a google server (gmail, or google apps for domains).
		
		NSString *expectedCertName = nil;
		
		NSString *serverDomain = xmppStream.hostName;
		NSString *virtualDomain = [xmppStream.myJID domain];
		
		if ([serverDomain isEqualToString:@"talk.google.com"])
		{
			if ([virtualDomain isEqualToString:@"gmail.com"])
			{
				expectedCertName = virtualDomain;
			}
			else
			{
				expectedCertName = serverDomain;
			}
		}
		else
		{
			expectedCertName = serverDomain;
		}
		
		if (expectedCertName)
		{
			[settings setObject:expectedCertName forKey:(NSString *)kCFStreamSSLPeerName];
		}
	}
}

- (void)xmppStreamDidSecure:(XMPPStream *)sender
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
	
	isOpen = YES;
	
	NSError *error = nil;
	
	if (![[self xmppStream] authenticateWithPassword:password error:&error])
        //if (![[self xmppStream] authenticateAnonymously:&error])
    {
		DDLogError(@"Error authenticating: %@", error);
	}
}

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
	
	[self goOnline];
}

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq
{
	DDLogVerbose(@"%@: %@ - %@", THIS_FILE, THIS_METHOD, [iq elementID]);
	
	return NO;
}

-(void) sendMessage:(ChatItem*)sendingMsg {
    NSXMLElement *xmlMessage =[self converMsgToNSXML:sendingMsg];
    [xmppStream sendElement:xmlMessage];
    
}


- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
    if([message isChatMessage] && [message isChatMessageWithBody]) {
        DDLogVerbose(@"messageReceived: %@", message);
        ChatItem *messageItem =[self convertMsgToChatItem:message];
        [delegate receiveMessage:messageItem];
        
    }
}

- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence
{
	DDLogVerbose(@"%@: %@ - %@", THIS_FILE, THIS_METHOD, [presence fromStr]);
}

- (void)xmppStream:(XMPPStream *)sender didReceiveError:(id)error
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
	
	if (!isOpen)
	{
		DDLogError(@"Unable to connect to server. Check xmppStream.hostName");
	}
}

@end
