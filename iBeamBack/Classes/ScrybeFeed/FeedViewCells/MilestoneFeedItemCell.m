//
//  MilestoneFeedItemCell.m
//  iBeamBack
//
//  Created by Bilal Nazir on 4/18/11.
//  Copyright 2011 iBeamBack. All rights reserved.
//

#import "MilestoneFeedItemCell.h"

#import "Milestone.h"
#import "DateManager.h"

#define BOX_WIDTH		IMAGE_THUMB_VIEW_WIDTH

#define BOX_HEIGHT		IMAGE_THUMB_VIEW_HEIGHT


@implementation MilestoneFeedItemCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
///////////////////////////////////////////////////////////////////////////

#pragma mark -
#pragma mark MilestoneFeedItemCell Height

+ (CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)item { 
    
    CGFloat cellHeight = [super tableView:tableView rowHeightForObject:item];
	
	//cellHeight+= VERTICAL_DIFERENCE_LABEL;
	
	cellHeight+=BOX_HEIGHT+VERTICAL_DIFERENCE_LABEL;
	
	return cellHeight;
}
///////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark MilestoneFeedItemCell Prepare Cell For Resuse

-(void)prepareForReuse{
	
	[super prepareForReuse];
    [dueMonthLabel removeFromSuperview];
	[dueDayLabel removeFromSuperview];
	[numaricDateLabel removeFromSuperview];
	
	TT_RELEASE_SAFELY(dueMonthLabel);
	TT_RELEASE_SAFELY(dueDayLabel);
	TT_RELEASE_SAFELY(numaricDateLabel);

}

///////////////////////////////////////////////////////////////////////////

#pragma mark -
#pragma mark MilestoneFeedItemCell initilization

- (id)object {
	return _item;  
}

- (void)setObject:(id)object {
	if (_item != object ) {
		[super setObject:object];
		
		if (object == nil) {
			return;
		}
        
        Milestone *milestone = object;
        
        feedTypeIcon.urlPath = [NSString stringWithFormat:@"bundle://%@",Milestone16];

        feedItemTitleLabel.text = [TTStyledText textFromXHTML:
                                   [NSString stringWithFormat:@"<a href=\"feedId=%d?ID=%@?type=MILESTONE?action=%d\">%@</a>    <a href=\"feedId=%d?ID=0?type=COMMENT?action=%d\">Comment</a>", milestone.feedId,milestone.resourceId,OPEN_RESOURCE,milestone.title,milestone.feedId,POST_COMMENT] lineBreaks:YES URLs:NO];
        
        [feedItemTitleLabel sizeToFit];
        
        
        float y = sharingInfoLabel.frame.origin.y+sharingInfoLabel.frame.size.height+VERTICAL_DIFERENCE_LABEL;
        
        y+=feedItemTitleLabel.frame.size.height+VERTICAL_DIFERENCE_LABEL;
        
        if ([milestone.details length]) {
			// set detail of cell
			detailedTextLabel.text=[TTStyledText textFromXHTML:milestone.details lineBreaks:YES URLs:YES];
            
            CGSize size = CGSizeZero;
            CGSize constraints = CGSizeMake(CELL_CONTENT_WIDTH-IMAGE_THUMB_VIEW_WIDTH, BOX_HEIGHT);
            
            size = [milestone.details sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraints lineBreakMode:UILineBreakModeWordWrap];
            
            [detailedTextLabel setFrame:CGRectMake(CONTENTS_STARTING_X+(IMAGE_THUMB_VIEW_WIDTH+HORIZONTAL_DIFERENCE_LABEL), y+2, size.width+HORIZONTAL_DIFERENCE_LABEL, size.height)];
        }
        
       /////////////// shows date /////////////////////////
        
        NSDate *date = [[DateManager sharedDateManager] localTimeZoneDateFrom:milestone.customProperty.dueOn];
		
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"MMMM"];
		NSString *dateString = [dateFormatter stringFromDate:date];  
		
		dueMonthLabel = [[UILabel alloc] initWithFrame:CGRectMake(CONTENTS_STARTING_X+2, y+2, BOX_WIDTH-4, 20)];
		dueMonthLabel.text = [dateString uppercaseString];
		dueMonthLabel.textAlignment = UITextAlignmentCenter;
		dueMonthLabel.textColor = [UIColor whiteColor];
		dueMonthLabel.font = [UIFont systemFontOfSize:12];
		
        [dateFormatter setDateFormat:@"d"];
		dateString = [dateFormatter stringFromDate:date];
		
		y+=20;
		numaricDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(CONTENTS_STARTING_X, y, BOX_WIDTH, BOX_HEIGHT-40)];
		numaricDateLabel.text = dateString;
		numaricDateLabel.textAlignment = UITextAlignmentCenter;
		numaricDateLabel.font = [UIFont systemFontOfSize:50];
        
		[dateFormatter setDateFormat:@"EEEE"];
		dateString = [dateFormatter stringFromDate:date];
		
		y+=BOX_HEIGHT-43;
		dueDayLabel = [[UILabel alloc] initWithFrame:CGRectMake(CONTENTS_STARTING_X, y, BOX_WIDTH, 20)];
		dueDayLabel.textAlignment = UITextAlignmentCenter;
		dueDayLabel.text = [dateString uppercaseString];
		dueDayLabel.font = [UIFont systemFontOfSize:12];
		
		[dateFormatter release];

        int days=[[DateManager sharedDateManager] getHowManyDaysHavePased:milestone.customProperty.dueOn];

        dueMonthLabel.backgroundColor = ([milestone.customProperty.status isEqualToString:@"done"]?
                      [UIColor colorWithRed:70.0f/255.0f green:130.0f/255.0f blue:70.0f/255.0f alpha:1.0]:
					 (days > 0 ?[UIColor colorWithRed:154.0f/255.0f green:30.0f/255.0f blue:32.0f/255.0f alpha:1.0]:[UIColor colorWithRed:232.0f/255.0f green:146.0f/255.0f blue:25.0f/255.0f alpha:1.0]));
		
        
		[self.contentView addSubview:dueMonthLabel];
		[self.contentView addSubview:numaricDateLabel];
		[self.contentView addSubview:dueDayLabel];

        
        ////////////////////////////////////////////////////
         
        
        ////////////////////// show conversations ///////////////////////
        
		if (milestone.conversationsCount) {
			
            float y = sharingInfoLabel.frame.origin.y+sharingInfoLabel.frame.size.height+VERTICAL_DIFERENCE_LABEL;
            
            y+=feedItemTitleLabel.frame.size.height+2*VERTICAL_DIFERENCE_LABEL+BOX_HEIGHT;

			if (milestone.conversationsCount > MAX_CONVERSATIONS_DISPLAY) {
				
				moreCommentsLabel = [[TTStyledTextLinkLabel alloc] init];
				[moreCommentsLabel setFrame:CGRectMake(CONTENTS_STARTING_X, y , CELL_CONTENT_WIDTH, 25)];
                
                moreCommentsLabel.text = [TTStyledText textFromXHTML:
                                          [NSString stringWithFormat:@"<a href=\"feedId=%d?ID=%@?type=COMMENT?action=%d\"> %d comments</a>", milestone.feedId,milestone.resourceId,SHOW_ALL_COMMENTS,milestone.conversationsCount] lineBreaks:YES URLs:NO];

                [moreCommentsLabel sizeToFit];
				[self.contentView addSubview:moreCommentsLabel];
                
				y+=4*VERTICAL_DIFERENCE_LABEL;
    		}
			
            [self.contentView addSubview:[super layoutConversations:milestone.conversationsArray delegate:self yOffset:y]];
			
		}
        /////////////////////////////////////////////////////////////////

        
    }
}


///////////////////////////////////////////////////////////////////////////
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    float y = sharingInfoLabel.frame.origin.y+sharingInfoLabel.frame.size.height+VERTICAL_DIFERENCE_LABEL;
    
    y+=feedItemTitleLabel.frame.size.height+VERTICAL_DIFERENCE_LABEL;

	rect = CGRectMake(CONTENTS_STARTING_X, y, BOX_WIDTH, BOX_HEIGHT);
	
	CALayer *boxLayer = [[CALayer layer] retain];
	
	boxLayer.masksToBounds = YES;
	boxLayer.cornerRadius = 3.0;
	boxLayer.borderWidth = 1.0;
    
	boxLayer.frame = rect;
	boxLayer.borderColor = [[UIColor lightGrayColor] CGColor];
	[self.layer addSublayer:boxLayer];
	[boxLayer release];
    
	
}




///////////////////////////////////////////////////////////////////////////
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    TT_RELEASE_SAFELY(dueMonthLabel);
	TT_RELEASE_SAFELY(dueDayLabel);
	TT_RELEASE_SAFELY(numaricDateLabel);

    [super dealloc];
}

@end
