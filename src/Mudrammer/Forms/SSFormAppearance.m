//
//  SSFormAppearance.m
//  Mudrammer
//
//  Created by Jonathan Hersh on 10/1/13.
//  Copyright (c) 2013 Jonathan Hersh. All rights reserved.
//

#import "SSFormAppearance.h"

@implementation SSFormAppearance

+ (instancetype)appearance {
    SSFormAppearance *theme = [SSFormAppearance new];

    SSThemes *themer = [SSThemes sharedThemer];
    theme.backgroundColorEnabled = [themer valueForThemeKey:kThemeBackgroundColor];
    theme.backgroundColorDisabled = theme.backgroundColorEnabled;

    theme.entryTextColorEnabled = [themer valueForThemeKey:kThemeFontColor];
    theme.entryTextColorDisabled = theme.entryTextColorEnabled;

    theme.valueColorEnabled = [themer valueForThemeKey:kThemeFontColor];
    theme.valueColorDisabled = theme.valueColorEnabled;

    theme.labelColorEnabled = [themer valueForThemeKey:kThemeFontColor];
    theme.labelColorDisabled = theme.labelColorEnabled;

    theme.actionColorEnabled = [themer valueForThemeKey:kThemeFontColor];
    theme.actionColorDisabled = theme.actionColorEnabled;

    theme.entryAlignment = NSTextAlignmentRight;
    theme.labelAlignment = NSTextAlignmentLeft;
    theme.valueAlignment = NSTextAlignmentRight;
    theme.buttonAlignment = NSTextAlignmentCenter;

    theme.tableSeparatorColor = [UIColor lightGrayColor];
    theme.tableBackgroundColor = theme.backgroundColorEnabled;
    theme.tableGroupedBackgroundColor = theme.backgroundColorEnabled;

    theme.sectionTitleColor = theme.labelColorEnabled;
    theme.sectionFooterColor = [UIColor secondaryLabelColor];

    theme.toolbarTranslucent = NO;

    return theme;
}

- (CGFloat)heightForHeaderInSection:(QSection *)section andTableView:(QuickDialogTableView *)tableView andIndex:(NSInteger)index {
    if (section.title.length == 0 && section.headerView == nil) {
        return 1.0;
    }
    return [super heightForHeaderInSection:section andTableView:tableView andIndex:index];
}

- (CGFloat)heightForFooterInSection:(QSection *)section andTableView:(QuickDialogTableView *)tableView andIndex:(NSInteger)index {
    if (section.footer.length == 0 && section.footerView == nil) {
        return 1.0;
    }
    return [super heightForFooterInSection:section andTableView:tableView andIndex:index];
}

- (UIView *)buildHeaderForSection:(QSection *)section andTableView:(QuickDialogTableView *)tableView andIndex:(NSInteger)index {
    return [self sectionViewWithText:section.title textStyle:UIFontTextStyleHeadline color:self.sectionTitleColor];
}

- (UIView *)buildFooterForSection:(QSection *)section andTableView:(QuickDialogTableView *)tableView andIndex:(NSInteger)index {
    return [self sectionViewWithText:section.footer textStyle:UIFontTextStyleFootnote color:self.sectionFooterColor];
}

- (UIView *)sectionViewWithText:(NSString *)text textStyle:(UIFontTextStyle)textStyle color:(UIColor *)color {
    if (text.length == 0) {
        return nil;
    }

    UIListContentConfiguration *content = [UIListContentConfiguration cellConfiguration];
    content.text = text;
    content.textProperties.font = [UIFont preferredFontForTextStyle:textStyle];
    content.textProperties.color = color;
    content.textProperties.numberOfLines = 0;

    UITableViewHeaderFooterView *view = [UITableViewHeaderFooterView new];
    view.backgroundConfiguration = [UIBackgroundConfiguration clearConfiguration];
    view.contentConfiguration = content;
    view.isAccessibilityElement = YES;
    view.accessibilityLabel = text;
    view.accessibilityTraits = UIAccessibilityTraitStaticText;
    return view;
}

- (void)cell:(UITableViewCell *)cell willAppearForElement:(QElement *)element atIndexPath:(NSIndexPath *)path
{
    [super cell:cell willAppearForElement:element atIndexPath:path];

    if ([element isKindOfClass:[QButtonElement class]]) {
        UIColor *actionColor = element.enabled ? self.actionColorEnabled : self.actionColorDisabled;
        cell.isAccessibilityElement = YES;
        cell.accessibilityLabel = cell.textLabel.text;
        cell.accessibilityTraits = UIAccessibilityTraitButton;
        if (!element.enabled) {
            cell.accessibilityTraits |= UIAccessibilityTraitNotEnabled;
        }

        cell.backgroundConfiguration = [self buttonBackgroundWithColor:actionColor highlighted:NO];
        cell.configurationUpdateHandler = ^(UITableViewCell *buttonCell, UICellConfigurationState *state) {
            buttonCell.backgroundConfiguration = [self buttonBackgroundWithColor:actionColor highlighted:state.highlighted];
        };
    }

    if ([cell isKindOfClass:[QEntryTableViewCell class]]) {
        QEntryTableViewCell *entryCell = (QEntryTableViewCell *)cell;

        if ([entryCell.textField.placeholder length] > 0) {
            UIColor *attColor = [self.entryTextColorEnabled colorWithAlphaComponent:0.7f];

            NSAttributedString *attributedPlaceHolder = [[NSAttributedString alloc] initWithString:entryCell.textField.placeholder
                                                                                        attributes:@{
                                                                                             NSFontAttributeName : entryCell.textField.font,
                                                                                             NSForegroundColorAttributeName : attColor,
                                                                                             NSUnderlineStyleAttributeName : @1,
                                                                                             NSUnderlineColorAttributeName : attColor,
                                                                                        }];

            [entryCell.textField setAttributedPlaceholder:attributedPlaceHolder];
        }
    }
}

- (UIBackgroundConfiguration *)buttonBackgroundWithColor:(UIColor *)color highlighted:(BOOL)highlighted {
    UIBackgroundConfiguration *background = [UIBackgroundConfiguration clearConfiguration];
    background.backgroundInsets = NSDirectionalEdgeInsetsMake(3.0, 16.0, 3.0, 16.0);
    background.cornerRadius = 8.0;
    background.strokeWidth = 1.0;
    background.strokeColor = [color colorWithAlphaComponent:0.65];
    background.backgroundColor = [color colorWithAlphaComponent:highlighted ? 0.20 : 0.06];
    return background;
}

@end
