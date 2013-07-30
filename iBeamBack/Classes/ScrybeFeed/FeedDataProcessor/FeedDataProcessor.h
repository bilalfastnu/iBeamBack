//
//  FeedDataProcessor.h
//  iBeamBack
//
//  Created by Bilal Nazir on 4/14/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ScrybeFeedDataProcessorDelegate;


@interface FeedDataProcessor : NSObject {
    
    NSArray *feedGroupsInfo;
    NSMutableDictionary *conversationDictionary;
    NSObject <ScrybeFeedDataProcessorDelegate> *feedProcessorDelegate;
}

@property (nonatomic, retain) NSObject <ScrybeFeedDataProcessorDelegate> *feedProcessorDelegate; 

-(void) processFeedData:(NSObject *) feedDataObject withPreviousFeedData:(NSMutableDictionary*)oldFeedData
;
@end

///////////////////////////////////////////////////////////////////////////////////

@protocol ScrybeFeedDataProcessorDelegate<NSObject>

- (void)scrybeFeedDataDidFinishProcessing:(FeedDataProcessor *)rssFeedProcessor processedData:(NSMutableDictionary*)feedProcessedData;
- (void)scrybeFeedDataProcessing:(FeedDataProcessor *)rssFeedProcessor didFailWithError:(NSError *)error;

@end
