#import "../../../../test-support/window-native/headers/darwin/window.h"

// Observe the source after routed input, before the pending session is
// cancelled.
@interface SWDragSource : NSObject
@property(nonatomic, readonly) NSImage *preview;
@property(nonatomic, readonly) NSPoint hotSpot;
@property(nonatomic, readonly) NSArray<NSDraggingItem *> *items;
@end

int32_t md_test_drag_preview(void *pointer, const uint8_t *bytes,
                             int64_t length, bool custom) {
  SWView *view = (__bridge SWView *)pointer;
  SWDragSource *source = view.owner.application.dragSource;
  NSBitmapImageRep *rep = (id)source.preview.representations.firstObject;
  if (source.items.count != 1 || ![rep isKindOfClass:NSBitmapImageRep.class])
    return 1;
  NSString *expected = [[NSString alloc] initWithBytes:bytes
                                                length:length
                                              encoding:NSUTF8StringEncoding];
  NSPasteboardItem *item = (id)source.items.firstObject.item;
  if (![[item stringForType:NSPasteboardTypeString] isEqual:expected])
    return 2;
  if (custom) {
    if (!NSEqualSizes(rep.size, NSMakeSize(24, 16)) ||
        !NSEqualPoints(source.hotSpot, NSMakePoint(4, 5)))
      return 3;
    return rep.bitmapData[0] == 255 && rep.bitmapData[3] == 255 ? 0 : 4;
  }
  bool ink = false, clear = false;
  for (NSInteger y = 0; y < rep.pixelsHigh; ++y) {
    const uint8_t *row = rep.bitmapData + y * rep.bytesPerRow;
    for (NSInteger x = 0; x < rep.pixelsWide; ++x) {
      uint8_t alpha = row[x * 4 + 3];
      ink |= alpha > 0;
      clear |= !alpha;
    }
  }
  return ink && clear &&
                 NSPointInRect(source.hotSpot, (NSRect){NSZeroPoint, rep.size})
             ? 0
             : 5;
}

void md_test_drag_move(void *pointer, double x, double y) {
  NSView *view = (__bridge NSView *)pointer;
  NSEvent *event = [NSEvent
      mouseEventWithType:NSEventTypeLeftMouseDragged
                location:[view convertPoint:NSMakePoint(x, y) toView:nil]
           modifierFlags:0
               timestamp:NSProcessInfo.processInfo.systemUptime
            windowNumber:view.window.windowNumber
                 context:nil
             eventNumber:2
              clickCount:1
                pressure:1.0];
  [view mouseDragged:event];
}
