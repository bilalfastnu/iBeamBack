//
//  FeedManager.m
//  iBeamBack
//
//  Created by Bilal Nazir on 4/14/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import "FeedManager.h"

#import "FeedRemoteCaller.h"



#import "FeedItem.h"
#import "FeedDataProcessor.h"


@implementation FeedManager

@synthesize feedDataDelegate;

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Poling data

-(void)startTimerThread
{
    NSThread* thread = [[NSThread alloc] initWithTarget:self
                                               selector:@selector(setupTimerThread)
                                                 object:nil];
    [thread start];
    [thread release];
}

-(void)setupTimerThread
{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    NSTimer* timer = [NSTimer timerWithTimeInterval:10
                                             target:self
                                           selector:@selector(triggerTimer:)
                                           userInfo:nil
                                            repeats:NO];
    NSRunLoop* runLoop = [NSRunLoop currentRunLoop];
    [runLoop addTimer:timer forMode:NSRunLoopCommonModes];
    [runLoop run];
    [pool release];
}

-(void)triggerTimer:(NSTimer*)timer
{
    // Do your stuff

    filterFeedRemoteCaller = [[FilterFeedRemoteCaller alloc] init];
    filterFeedRemoteCaller.delegate = self;
    [filterFeedRemoteCaller pollFeed:nil withFiltersObject:nil];

}

///////////////////////////////////////////////////////////////////////////////////////////////////
-(id) init
{
    self = [super init];
    
    if (self) {
        
        feedProcessedData = [[NSMutableDictionary alloc] init];
       [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(startTimerThread) userInfo:nil repeats:YES];
        
    }
    return self;
}
///////////////////////////////////////////////////////////////////////////////////////////////////

+(FeedManager *)sharedFeedManager
{
	return (FeedManager *)[super sharedInstance];
}

- (NSMutableDictionary *)feedItems
{
    //return currentPageFeedProcessedData;
    return currentPageFeedProcessedData;
}
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma Feed Remote Callers Methods

-(void)fetchAccountFeedForPage:(NSInteger)page
{
    feedRemoteCaller  = [[FeedRemoteCaller alloc] init];
    feedRemoteCaller.delegate = self;
    [feedRemoteCaller fetchAccountFeedForPage:page];
}

-(void)fetchFeedForFilter:(NSDictionary *) filterDictionary ofPageNumber:(NSInteger) page
{
    filterFeedRemoteCaller = [[FilterFeedRemoteCaller alloc] init];
    filterFeedRemoteCaller.delegate = self;
    [filterFeedRemoteCaller fetchFeedForFilter:filterDictionary ofPageNumber:page];
}
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Data Maniupulation

-(FeedItem *) getObjectForFeedId:(NSString*)feedId
{
    return [feedProcessedData objectForKey:feedId];
}

-(void) updateFeedItem:(FeedItem*)feedItem
{
    [currentPageFeedProcessedData setValue:feedItem forKey:[NSString stringWithFormat:@"%d",feedItem.feedId ]];
    
}
///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -
#pragma mark FeedDataProcessor Delegate methods

- (void)scrybeFeedDataDidFinishProcessing:(FeedDataProcessor *)rssFeedProcessor processedData:(NSMutableDictionary*)processedData
{
    [currentPageFeedProcessedData release];
    currentPageFeedProcessedData = [[NSMutableDictionary alloc] initWithDictionary:processedData];
    [feedProcessedData addEntriesFromDictionary:processedData];
    
    [feedDataDelegate scrybeFeedDataDidFinishProcessing:self];
}
- (void)scrybeFeedDataProcessing:(FeedDataProcessor *)rssFeedProcessor didFailWithError:(NSError *)error
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Feed Manager scrybeFeedDataProcessing"
                                                        message:[NSString stringWithFormat:@"%@",error]
                                                       delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
    [alertView show];
    [alertView release];
  
}

///////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark -
#pragma mark RemoteCall Delegate methods

- (void)callerDidFinishLoading:(RemoteCaller *)caller receivedObject:(NSObject *)object
{
    //[feedRemoteCaller release];
    //[filterFeedRemoteCaller release];
    
    NSLog(@"Feed Data: %@",object);
    FeedDataProcessor *feedDataProcessor = [[FeedDataProcessor alloc] init];
    feedDataProcessor.feedProcessorDelegate = self;
   
    [feedDataProcessor processFeedData:object withPreviousFeedData:feedProcessedData];

    [feedDataProcessor release];
    
    //[self setupTimerThread];
}
- (void)caller:(RemoteCaller *)caller didFailWithError:(NSError *)error
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Feed Manager"
                                                        message:[NSString stringWithFormat:@"%@",error]
                                                       delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
    
    [alertView show];
    [alertView release];
}
///////////////////////////////////////////////////////////////////////////////////////////////////
-(void) dealloc

{
    [feedProcessedData release];
    [currentPageFeedProcessedData release];
    [super dealloc];
}
@end
