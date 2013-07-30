//
//  AccountManager.h
//  iBeamBack
//
//  Created by Bilal Nazir on 4/13/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Account.h"
#import "NSSingleton.h"
#import "AmazonWebServiceData.h"


@class ASObject;


@interface AccountManager : NSSingleton {
    
    Account *userAccount;
    AmazonWebServiceData *amazonWebService;
}
@property (nonatomic, retain) Account *userAccount;
@property (nonatomic, retain) AmazonWebServiceData *amazonWebService;


///Actions

+(AccountManager *)sharedAccountManager;
-(void) initilizeAmazonWebServiceData:(ASObject*) serviceDataObject;

@end
