//
//  ResourceHeaderView.m
//  iBeamBack
//
//  Created by Bilal Nazir on 4/18/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import "ResourceHeaderView.h"


@implementation ResourceHeaderView

@synthesize titleLabel, sharingInfoLabel, userImageView;

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        sharingInfoLabel = [[ UILabel alloc] init];
		sharingInfoLabel.font = [UIFont systemFontOfSize:16];
		
		titleLabel = [[ UILabel alloc] init];
		titleLabel.font = [UIFont boldSystemFontOfSize:18];
        
		userImageView = [[ScrybeImageThumbView alloc ]init];
		
		self.backgroundColor =[ UIColor whiteColor];
		
		//titleLabel.backgroundColor = [UIColor greenColor];
		//sharingInfoLabel.backgroundColor = [UIColor grayColor];
		
		[self addSubview:titleLabel];
		[self addSubview: userImageView];
		[self addSubview:sharingInfoLabel];

    }
    return self;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
-(void) layoutSubviews
{
	[super layoutSubviews];
    
	CGRect frame = self.frame;
	userImageView.frame =  CGRectMake(10, frame.size.height/6 ,50.0, 50.0);
	sharingInfoLabel.frame = CGRectMake(userImageView.frame.origin.x+60,userImageView.frame.origin.y,frame.size.width-(userImageView.frame.origin.x+60), 20.0);
    
	titleLabel.frame = CGRectMake(userImageView.frame.origin.x+60, sharingInfoLabel.frame.size.height+20,frame.size.width-(userImageView.frame.origin.x+60), 20.0);
    
}
///////////////////////////////////////////////////////////////////////////////////////////////////


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    //Get the CGContext from this view
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	//draw border arround user icon
	/*CALayer *l = [[CALayer layer] retain];
	
	l.masksToBounds = YES;
	l.cornerRadius = 3.0;
	l.borderWidth = 1.0;
	
	l.frame = CGRectMake(7.0, self.frame.size.height/8,userImage.frame.size.width+6.0f, userImage.frame.size.width+6.0f);
	l.borderColor = [[UIColor lightGrayColor] CGColor];
	[self.layer addSublayer:l];
	[l release];*/
	
	//draw line
	
	//Set the stroke (pen) color
	CGContextSetStrokeColorWithColor(context, [UIColor darkGrayColor].CGColor);
	CGContextMoveToPoint(context, 5, rect.size.height);
	CGContextAddLineToPoint(context, rect.size.width-5,rect.size.height);
	CGContextStrokePath(context);

}


- (void)dealloc
{
    [titleLabel release];
	[sharingInfoLabel release];
	[userImageView release];

    [super dealloc];
}

@end
