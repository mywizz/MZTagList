
#import "MZTagList.h"

@interface MZTagListView : UIView

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
@property (nonatomic, weak) id<MZTagListDelegate> delegate;

- (void)addTags:(NSArray *)tags;

- (void)selectTag:(NSString *)tag;

- (NSArray *)selectedTags;

- (void)filterWithString:(NSString *)tagString;

- (void)addTag:(NSString *)tag selected:(BOOL)selected;

- (void)clear;

@end
