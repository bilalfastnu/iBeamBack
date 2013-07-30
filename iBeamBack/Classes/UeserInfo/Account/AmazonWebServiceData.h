//
//  AmazonWebServiceData.h
//  iBeamBack
//
//  Created by Bilal Nazir on 4/13/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AmazonWebServiceData : NSObject {
   
    NSString *accessKey;
    NSNumber *duration;
    NSString *s3UserAgent;
	NSString *baseS3Path;
    NSString *bucketName;
    NSString *s3Signature;
    NSString *s3PostPolicy;
	NSString *accountS3Path;
	NSString *accountS3TempPath;

}
@property (nonatomic, retain) NSNumber * duration;
@property (nonatomic, retain) NSString * s3UserAgent;
@property (nonatomic, retain) NSString * accessKey;
@property (nonatomic, retain) NSString * baseS3Path;
@property (nonatomic, retain) NSString * bucketName;
@property (nonatomic, retain) NSString * s3Signature;
@property (nonatomic, retain) NSString * s3PostPolicy;
@property (nonatomic, retain) NSString * accountS3Path;
@property (nonatomic, retain) NSString * accountS3TempPath;

-(id) initWithAmazonWebServiceData:(NSDictionary*)dataDictionary withAccountId:(NSString*)accountId;

@end
