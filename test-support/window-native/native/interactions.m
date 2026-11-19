#import <AppKit/AppKit.h>
#include <stdbool.h>
#include <stdint.h>

static id find_text(id node) {
  if ([[node accessibilityIdentifier] isEqualToString:@"markdown-interactions"])
    return node;
  for (id child in [node accessibilityChildren]) {
    id found = find_text(child);
    if (found)
      return found;
  }
  return nil;
}

int32_t scoop_markdown_test_ax(void *pointer, int32_t operation,
                               const uint8_t *bytes, int64_t length,
                               int64_t start, int64_t count) {
  id node = find_text((__bridge NSView *)pointer);
  if (!node)
    return -1;
  NSString *text = [[NSString alloc] initWithBytes:bytes
                                            length:(NSUInteger)length
                                          encoding:NSUTF8StringEncoding];
  if (operation == 0)
    return [[node accessibilityValue] isEqualToString:text];
  if (operation == 1)
    return NSEqualRanges([node accessibilitySelectedTextRange],
                         NSMakeRange((NSUInteger)start, (NSUInteger)count));
  SEL selector = operation == 2 ? @selector(setAccessibilitySelectedTextRange:)
                                : @selector(setAccessibilitySelectedText:);
  if (![node isAccessibilitySelectorAllowed:selector])
    return 0;
  dispatch_async(dispatch_get_main_queue(), ^{
    if (operation == 2)
      [node setAccessibilitySelectedTextRange:NSMakeRange((NSUInteger)start,
                                                          (NSUInteger)count)];
    else
      [node setAccessibilitySelectedText:text];
  });
  return 1;
}

static id menu_observer;
static NSMenu *current_menu;
static NSTimer *menu_timer;
static int32_t menu_mask;
static int32_t menu_finished;
static bool menu_delete;
static int32_t menu_format;

static NSMenuItem *item(NSMenu *menu, NSString *title) {
  for (NSMenuItem *value in menu.itemArray) {
    if ([value.title isEqualToString:title])
      return value;
  }
  return nil;
}

static NSMenuItem *format_item(NSMenu *menu, NSString *title) {
  for (NSMenuItem *value in menu.itemArray)
    if ([value.title isEqualToString:title] ||
        [value.title hasSuffix:[@"  " stringByAppendingString:title]])
      return value;
  return nil;
}

static void inspect_format_menu(void) {
  NSMenuItem *bold = format_item(current_menu, @"粗体");
  NSMenu *heading = item(current_menu, @"标题").submenu;
  NSMenuItem *level = format_item(heading, @"2 级标题");
  menu_mask = (bold.enabled ? 1 : 0) | (heading ? 2 : 0) |
              (heading.numberOfItems == 7 ? 4 : 0) | (level.enabled ? 8 : 0);
  NSMenuItem *selected = menu_format == 1 ? bold : level;
  if (selected.enabled)
    [NSApp sendAction:selected.action to:selected.target from:selected];
}

void scoop_markdown_test_menu_observe(void) {
  menu_observer = [NSNotificationCenter.defaultCenter
      addObserverForName:NSMenuDidBeginTrackingNotification
                  object:nil
                   queue:nil
              usingBlock:^(NSNotification *notification) {
                current_menu = notification.object;
                menu_timer = [NSTimer
                    timerWithTimeInterval:0.05
                                  repeats:NO
                                    block:^(NSTimer *timer) {
                                      if (menu_format) {
                                        inspect_format_menu();
                                        [current_menu
                                            cancelTrackingWithoutAnimation];
                                        menu_finished = 1;
                                        return;
                                      }
                                      NSMenuItem *copy =
                                          item(current_menu, @"MD Copy");
                                      NSMenuItem *paste =
                                          item(current_menu, @"MD Paste");
                                      NSMenuItem *deletion =
                                          item(current_menu, @"MD Delete");
                                      menu_mask = (copy.enabled ? 1 : 0) |
                                                  (paste.enabled ? 2 : 0) |
                                                  (deletion.enabled ? 4 : 0);
                                      if (menu_delete && deletion.enabled)
                                        [NSApp sendAction:deletion.action
                                                       to:deletion.target
                                                     from:deletion];
                                      [current_menu
                                          cancelTrackingWithoutAnimation];
                                      menu_finished = 1;
                                    }];
                [NSRunLoop.mainRunLoop addTimer:menu_timer
                                        forMode:NSRunLoopCommonModes];
              }];
}

void scoop_markdown_test_menu_prepare(bool deletion) {
  menu_format = 0;
  menu_delete = deletion;
  menu_mask = 0;
  menu_finished = 0;
}

void scoop_markdown_test_menu_prepare_format(int32_t format) {
  menu_format = format;
  menu_delete = false;
  menu_mask = 0;
  menu_finished = 0;
}

int32_t scoop_markdown_test_menu_result(void) {
  return menu_finished ? menu_mask : -1;
}

void scoop_markdown_test_menu_close(void) {
  [menu_timer invalidate];
  [current_menu cancelTrackingWithoutAnimation];
  if (menu_observer)
    [NSNotificationCenter.defaultCenter removeObserver:menu_observer];
  menu_timer = nil;
  current_menu = nil;
  menu_observer = nil;
}

static id find_control(id node, NSString *name, bool press) {
  if (([[node accessibilityIdentifier] isEqualToString:name] ||
       [[node accessibilityLabel] isEqualToString:name]) &&
      (!press ||
       [node isAccessibilitySelectorAllowed:@selector(
                                                accessibilityPerformPress)]))
    return node;
  for (id child in [node accessibilityChildren]) {
    id found = find_control(child, name, press);
    if (found)
      return found;
  }
  return nil;
}

int32_t scoop_markdown_test_control(void *pointer, const uint8_t *bytes,
                                    int64_t length, int32_t operation) {
  NSView *view = (__bridge NSView *)pointer;
  NSString *name = [[NSString alloc] initWithBytes:bytes
                                            length:(NSUInteger)length
                                          encoding:NSUTF8StringEncoding];
  if (operation == 4)
    return [view.window.title hasPrefix:name];
  id control = find_control(view, name, operation == 2);
  if (!control)
    return 0;
  if (operation == 1)
    return [control isAccessibilityEnabled];
  if (operation == 2) {
    dispatch_async(dispatch_get_main_queue(), ^{
      [control accessibilityPerformPress];
    });
    return 1;
  }
  if (operation == 3) {
    NSRect frame = [control accessibilityFrame];
    return !NSIsEmptyRect(frame) && NSContainsRect(view.window.frame, frame);
  }
  return 1;
}

void scoop_markdown_test_context_key(void *pointer) {
  NSView *view = (__bridge NSView *)pointer;
  NSString *characters =
      [NSString stringWithFormat:@"%C", (unichar)NSF10FunctionKey];
  for (NSNumber *type in @[ @(NSEventTypeKeyDown), @(NSEventTypeKeyUp) ]) {
    NSEvent *event =
        [NSEvent keyEventWithType:(NSEventType)type.unsignedLongLongValue
                               location:NSZeroPoint
                          modifierFlags:NSEventModifierFlagShift
                              timestamp:NSProcessInfo.processInfo.systemUptime
                           windowNumber:view.window.windowNumber
                                context:nil
                             characters:characters
            charactersIgnoringModifiers:characters
                              isARepeat:NO
                                keyCode:109];
    if (event.type == NSEventTypeKeyDown)
      [view keyDown:event];
    else
      [view keyUp:event];
  }
}
