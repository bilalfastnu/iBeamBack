//
//  AmazonWebServiceData.m
//  iBeamBack
//
//  Created by Bilal Nazir on 4/13/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import "AmazonWebServiceData.h"


@implementation AmazonWebServiceData

@synthesize accessKey,bucketName,s3Signature,accountS3Path;

@synthesize s3PostPolicy, baseS3Path, accountS3TempPath;

@synthesize s3UserAgent, duration;
///////////////////////////////////////////////////////////////////////////

-(id) initWithAmazonWebServiceData:(NSDictionary*)dataDictionary withAccountId:(NSString*)accountId
{
    self = [super init];
    
    if (self) {
        
        bucketName = [[dataDictionary objectForKey:@"bucket_name"] retain];
        s3PostPolicy =[[dataDictionary objectForKey:@"s3_policy"] retain];
        accessKey = [[dataDictionary objectForKey:@"access_key"] retain];
        s3Signature = [[dataDictionary objectForKey:@"s3_signature"] retain];
        duration = [[dataDictionary objectForKey:@"duration"] retain];
        s3UserAgent = [[dataDictionary objectForKey:@"s3_user_agent"] retain];
        
        baseS3Path	= [[NSString stringWithFormat:@"http://s3.amazonaws.com/%@/",bucketName] retain];
        accountS3Path		= [[NSString stringWithFormat:@"%@%@/",baseS3Path,accountId] retain];
        accountS3TempPath	= [[NSString stringWithFormat:@"%@temp/",accountS3Path] retain];
      }
    return self;
}

///////////////////////////////////////////////////////////////////////////

-(void) dealloc
{
    [accessKey release];
    [baseS3Path release];
    [bucketName release];
    [s3Signature release];
    [s3PostPolicy release];
    [accountS3Path release];
    [accountS3TempPath release];
    
    [super dealloc];
}
@end
