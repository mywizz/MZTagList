
#import "MZTagList.h"
#import "MZTagListView.h"

@interface MZTagList () {
	MZTagListView *_tagView;
}

@end

// ---------------------------------------------------------------------
#pragma mark -
#pragma mark MZTagList

@implementation MZTagList

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
	{
		[self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self)
	{
		[self commonInit];
	}
	return self;
}

- (void)commonInit
{
	_tagView = [[MZTagListView alloc] initWithFrame:self.bounds];
	[self addSubview:_tagView];
	
	self.backgroundColor = [UIColor clearColor];
	self.showsHorizontalScrollIndicator = NO;
	self.showsVerticalScrollIndicator = YES;
	self.bounces = YES;
}

- (void)setTagDelegate:(id<MZTagListDelegate>)tagDelegate
{
	_tagView.delegate = tagDelegate;
}

// ---------------------------------------------------------------------
#pragma mark -
#pragma mark Public methods

- (void)addTags:(NSArray *)tags
{
	[_tagView addTags:tags];
}

- (void)selectTag:(NSString *)tag
{
	[_tagView selectTag:tag];
}

- (NSArray *)selectedTags
{
	return [_tagView selectedTags];
}

- (void)filterWithString:(NSString *)tagString
{
	[_tagView filterWithString:tagString];
}

- (void)addTag:(NSString *)tag selected:(BOOL)selected
{
	[_tagView addTag:tag selected:selected];
}

- (void)clear
{
	[_tagView clear];
}

// ---------------------------------------------------------------------
#pragma mark -
#pragma mark Setters

- (void)setTagFont:(UIFont *)tagFont
{
	_tagView.tagFont = tagFont;
}

- (void)setTagColor:(UIColor *)tagColor
{
	_tagView.tagColor = tagColor;
}

- (void)setSelectedTagColor:(UIColor *)selectedTagColor
{
	_tagView.selectedTagColor = selectedTagColor;
}

- (void)setTagBackgroundColor:(UIColor *)tagBackgroundColor
{
	_tagView.tagBackgroundColor = tagBackgroundColor;
}

- (void)setSelectedTagBackgroundColor:(UIColor *)selectedTagBackgroundColor
{
	_tagView.selectedTagBackgroundColor = selectedTagBackgroundColor;
}

- (void)setTagInsets:(UIEdgeInsets)tagInsets
{
	_tagView.tagInsets = tagInsets;
}

- (void)setTagMarginX:(CGFloat)tagMarginX
{
	_tagView.tagMarginX = tagMarginX;
}

- (void)setTagMarginY:(CGFloat)tagMarginY
{
	_tagView.tagMarginY = tagMarginY;
}

- (void)setListPaddingX:(CGFloat)listPaddingX
{
	_tagView.listPaddingX = listPaddingX;
}

- (void)setListPaddingY:(CGFloat)listPaddingY
{
	_tagView.listPaddingY = listPaddingY;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
	_tagView.backgroundColor = backgroundColor;
}

- (void)setTagCornderRadius:(CGFloat)tagCornderRadius
{
	_tagView.tagCornderRadius = tagCornderRadius;
}

@end
