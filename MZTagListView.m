
#import "MZTagListView.h"


@interface MZTagListView () {
	
	NSMutableArray *_positions;
	NSMutableArray *_selectedTags;
	NSMutableArray *_tags;
	NSString *_filter;
	NSString *_usedFilter;
	
}

@property (nonatomic, strong) NSArray *activeTags;

@end

// ---------------------------------------------------------------------
#pragma mark -
#pragma mark MZTagList

@implementation MZTagListView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
	{
		_tags = [NSMutableArray new];
		
		_tagFont = [UIFont systemFontOfSize:19];
		_tagColor = [UIColor whiteColor];
		_tagBackgroundColor = [UIColor lightGrayColor];
		
		_selectedTagColor = [UIColor yellowColor];
		_selectedTagBackgroundColor = [UIColor redColor];
		
		_tagInsets = UIEdgeInsetsMake(6, 6, 6, 6);
		_tagMarginX = 10.0f;
		_tagMarginY = 10.0f;
		_listPaddingX = 10.0f;
		_listPaddingY = 10.0f;
		_positions = [NSMutableArray new];
		_selectedTags = [NSMutableArray new];
		
		_tagCornderRadius = 6.0f;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
	static NSDictionary *tagAttributes;
	static NSDictionary *selectedTagAttributes;
	if ( ! tagAttributes)
	{
		NSMutableParagraphStyle *para = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
		para.lineBreakMode = NSLineBreakByTruncatingTail;
		
		tagAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
						 para, NSParagraphStyleAttributeName,
						 _tagColor, NSForegroundColorAttributeName,
						 self.tagFont, NSFontAttributeName,
						 nil];
		
		selectedTagAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
								 para, NSParagraphStyleAttributeName,
								 _selectedTagColor, NSForegroundColorAttributeName,
								 self.tagFont, NSFontAttributeName,
								 nil];
	}
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextClearRect(context, self.bounds);
	[self.backgroundColor set];
	CGContextFillRect(context, self.bounds);

	CGFloat tagX = _listPaddingX;
	CGFloat tagY = _listPaddingY;
	CGFloat viewWidth = CGRectGetWidth(self.bounds);
	CGFloat maxWidth = viewWidth - (_listPaddingX * 2) - _tagInsets.left - _tagInsets.right;
	CGFloat lastTagHeight;
	[_positions removeAllObjects];
	
	for (NSInteger i = 0; i < self.activeTags.count; i++)
	{
		NSString *tagString = [self.activeTags objectAtIndex:i];
		
		CGRect tagRect = [tagString boundingRectWithSize:CGSizeMake(viewWidth, 15) options:NSStringDrawingUsesLineFragmentOrigin attributes:tagAttributes context:nil];
		CGFloat tagWidth = MIN(CGRectGetWidth(tagRect), maxWidth);
		CGFloat tagHeight = CGRectGetHeight(tagRect);
		
		BOOL overflow = tagX + tagWidth + _tagInsets.left + _tagInsets.right > viewWidth;
		if (overflow)
		{
			tagX = _listPaddingX;
			tagY += (tagHeight + _tagInsets.top + _tagInsets.bottom + _tagMarginY);
		}
		
		BOOL selected = [_selectedTags containsObject:tagString];
		UIColor *backgroundColor = selected ? _selectedTagBackgroundColor : _tagBackgroundColor;

		UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(tagX, tagY, tagWidth + _tagInsets.left + _tagInsets.right, tagHeight + _tagInsets.top + _tagInsets.bottom) cornerRadius:_tagCornderRadius];
		CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
		[bezierPath fill];
		
		[tagString drawInRect:CGRectMake(tagX + _tagInsets.left, tagY + _tagInsets.top, tagWidth, tagHeight) withAttributes:selected ? selectedTagAttributes : tagAttributes];
		
		CGRect hitRect = CGRectMake(tagX - (_tagMarginX/2), tagY - (_tagMarginY/2), tagWidth + _tagInsets.left + _tagInsets.right + (_tagMarginX), tagHeight + _tagInsets.top + _tagInsets.bottom + (_tagMarginY));
		[_positions addObject:[NSValue valueWithCGRect:hitRect]];
		
		tagX += (tagWidth + (_tagInsets.left + _tagInsets.right) + _tagMarginX);
		lastTagHeight = tagHeight;
	}
	
	((MZTagList *)self.superview).contentSize = CGSizeMake(CGRectGetWidth(self.bounds), _listPaddingY * 2 + tagY + lastTagHeight);
}

- (void)clear
{
	_filter = nil;
	_usedFilter = nil;
	[_tags removeAllObjects];
	[_positions removeAllObjects];
	[_selectedTags removeAllObjects];
}

- (void)addTags:(NSArray *)tags
{
	_tags = [NSMutableArray arrayWithArray:tags];
	[self setNeedsDisplay];
}

- (void)addTag:(NSString *)tag selected:(BOOL)selected
{
	if ([_tags containsObject:tag] == NO)
	{
		[_tags addObject:tag];
		
		[self buildTagsWithString:_filter];
		
		[self setNeedsDisplay];
		
		if (selected)
		{
			[self selectTag:tag];
		}
	}
}

- (void)selectTag:(NSString *)tag
{
	if ([_tags containsObject:tag])
	{
		NSUInteger idx = [self.activeTags indexOfObject:tag];
		[self selectTagAtIndex:idx];
	}
}

- (void)filterWithString:(NSString *)tagString
{
	_filter = tagString;
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(handleFilterWithString:) object:nil];
	[self performSelector:@selector(handleFilterWithString:) withObject:nil afterDelay:0.05];
}

- (void)handleFilterWithString:(NSString *)tagString
{
	[self setNeedsDisplay];
}

- (NSArray *)selectedTags
{
	return _selectedTags;
}

// ---------------------------------------------------------------------
#pragma mark -
#pragma mark Private

- (void)buildTagsWithString:(NSString *)tagString
{
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains[cd] %@", tagString];
	_activeTags = [_tags filteredArrayUsingPredicate:predicate];
	_usedFilter = tagString;
}

- (NSArray *)activeTags
{
	if (_filter.length)
	{
		if ( ! [_filter isEqualToString:_usedFilter])
		{
			[self buildTagsWithString:_filter];
		}
		return _activeTags;
	}
	
	return _tags;
}

- (void)selectTagAtIndex:(NSUInteger)idx
{
	NSString *tag = [self.activeTags objectAtIndex:idx];
	if ([_selectedTags containsObject:tag] == NO)
	{
		[_selectedTags addObject:tag];
		if (_delegate && [_delegate respondsToSelector:@selector(tagListDidSelectTag:)])
		{
			[_delegate performSelector:@selector(tagListDidSelectTag:) withObject:tag];
		}
	}
	else
	{
		[_selectedTags removeObject:tag];
		if (_delegate && [_delegate respondsToSelector:@selector(tagListDidDeselectTag:)])
		{
			[_delegate performSelector:@selector(tagListDidDeselectTag:) withObject:tag];
		}
	}
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesBegan:touches withEvent:event];
}

// ---------------------------------------------------------------------
#pragma mark -
#pragma mark touch handlers

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesEnded:touches withEvent:event];
	
	CGPoint point = [[touches anyObject] locationInView:self];
	__block NSUInteger touchedTagIndex;
	__block BOOL tagFound = NO;
	
	[_positions enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		
		CGRect rect = [obj CGRectValue];
		
		if (CGRectContainsPoint(rect, point))
		{
			touchedTagIndex = idx;
			tagFound = YES;
			*stop = YES;
		}
	}];
	
	if (tagFound)
	{
		[self selectTagAtIndex:touchedTagIndex];
		[self setNeedsDisplay];
	}
}

@end
