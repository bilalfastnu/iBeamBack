//
//  NoteRemoteCaller.m
//  iBeamBack
//
//  Created by Bilal Nazir on 4/14/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import "NoteRemoteCaller.h"


@implementation NoteRemoteCaller

///////////////////////////////////////////////////////////////////////////
- (id)init
{
	
	NSString *notesRemotingService = [NSString stringWithFormat:@"%@notes",AMFRemotingBaseService];
	
    self = [super initWithRemotingService:notesRemotingService withRemotCallingURL:AMFRemoteCallingURL];
	if (self)
	{
        //add initializations
	}
	return self;
}

///////////////////////////////////////////////////////////////////////////
-(void) getNoteDetails:(NSString *)noteID
{
	m_remotingCall.method = @"NotesService.getItemDetails";
	m_remotingCall.arguments = [NSArray arrayWithObjects:noteID,@"1",@"true",nil];
	[m_remotingCall start];
	lastMethodInvoked = m_remotingCall.method;
}


@end
