//
//  FeedManager.h
//  iBeamBack
//
//  Created by Bilal Nazir on 4/14/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NSSingleton.h"
#import "RemoteCaller.h"

#import "FeedDataProcessor.h"
//#import "PollFeedRemoteCaller.h"
#import "FilterFeedRemoteCaller.h"

@class FeedItem;
@class FeedRemoteCaller;

@class FilterFeedRemoteCaller;

@protocol ScrybeFeedDataModelDelegate;

@interface FeedManager :  NSSingleton<RemoteCallerDelegate,ScrybeFeedDataProcessorDelegate> {
   
    NSObject <ScrybeFeedDataModelDelegate> *feedDataDelegate;
    
    NSMutableDictionary *feedProcessedData;
    NSMutableDictionary *currentPageFeedProcessedData;
    
    FeedRemoteCaller *feedRemoteCaller;
   // PollFeedRemoteCaller *pollFeedRemoteCaller;
    FilterFeedRemoteCaller *filterFeedRemoteCaller;
}

@property (nonatomic, retain) NSObject <ScrybeFeedDataModelDelegate> *feedDataDelegate;

+(FeedManager *)sharedFeedManager;

-(NSMutableDictionary *)feedItems;
-(void)fetchAccountFeedForPage:(NSInteger)page;
-(void)fetchFeedForFilter:(NSDictionary *) filterDictionary ofPageNumber:(NSInteger) page;

-(FeedItem *) getObjectForFeedId:(NSString*)feedId;
-(void) updateFeedItem:(FeedItem*)feedItem;



@end


///////////////////////////////////////////////////////////////////////////////////

@protocol ScrybeFeedDataModelDelegate<NSObject>

- (void)scrybeFeedDataDidFinishProcessing:(FeedManager *)feedManager;
- (void)scrybeFeedDataProcessing:(FeedManager *)feedManager didFailWithError:(NSError *)error;

@end
