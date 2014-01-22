

@protocol MZTagListDelegate <NSObject>

@optional
- (void)tagListDidSelectTag:(NSString *)tag;
- (void)tagListDidDeselectTag:(NSString *)tag;

@end

// ---------------------------------------------------------------------
#pragma mark -
#pragma mark MZTagList

@interface MZTagList : UIScrollView

@property (nonatomic, weak) id<MZTagListDelegate> tagDelegate;
@property (nonatomic, strong) UIFont *tagFont;
@property (nonatomic, strong) UIColor *tagColor;
@property (nonatomic, strong) UIColor *selectedTagColor;
@property (nonatomic, strong) UIColor *tagBackgroundColor;
@property (nonatomic, strong) UIColor *selectedTagBackgroundColor;
@property (nonatomic, assign) UIEdgeInsets tagInsets;
@property (nonatomic, assign) CGFloat tagMarginX;
@property (nonatomic, assign) CGFloat tagMarginY;
@property (nonatomic, assign) CGFloat listPaddingX;
@property (nonatomic, assign) CGFloat listPaddingY;
@property (nonatomic, assign) CGFloat tagCornderRadius;

// ---------------------------------------------------------------------
// Public methods
// ---------------------------------------------------------------------

- (void)addTag:(NSString *)tag selected:(BOOL)selected;

- (void)addTags:(NSArray *)tags;

- (void)selectTag:(NSString *)tag;

- (NSArray *)selectedTags;

- (void)filterWithString:(NSString *)tagString;

- (void)clear;

@end