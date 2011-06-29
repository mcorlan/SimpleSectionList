//see Evtim Georgiev article http://www.adobe.com/devnet/flex/articles/spark_layouts.html
package org.corlan.layout {
	
	import mx.core.ILayoutElement;
	import spark.components.supportClasses.GroupBase;
	import spark.layouts.BasicLayout;
	
	public class SectionListLayout extends BasicLayout {
		
		private var _horizontalGap:Number = 0;
		private var _verticalGap:Number = 0;
		private var explicitColumnWidth:Number;
		private var _columnWidth:Number = 250;
		
		public function SectionListLayout() {
			super();
		}
		
		public function set horizontalGap(value:Number):void {
			_horizontalGap = value;
			
			// We must invalidate the layout
			var layoutTarget:GroupBase = target;
			if (layoutTarget) {
				layoutTarget.invalidateSize();
				layoutTarget.invalidateDisplayList();
			}
		}
		
		public function set verticalGap(value:Number):void {
			_verticalGap = value;
			
			// We must invalidate the layout
			var layoutTarget:GroupBase = target;
			if (layoutTarget) {
				layoutTarget.invalidateSize();
				layoutTarget.invalidateDisplayList();
			}
		}
		
		public function set columnWidth(value:Number):void {
			explicitColumnWidth = value;
			if (value == _columnWidth)
				return;
			
			_columnWidth = value;
			var layoutTarget:GroupBase = target;
			if (layoutTarget) {
				layoutTarget.invalidateSize();
				layoutTarget.invalidateDisplayList();
			}
		}
		
		// When extending the BasicLayout 
		// you have to override this method
		override public function measure():void {

		}
		
		//
		override public function updateDisplayList(containerWidth:Number, containerHeight:Number):void {
			// The position for the first element
			var x:Number = 0;
			var y:Number = 0;
			var maxWidth:Number = 0;
			var maxHeight:Number = 0;
			var elementWidth:Number, elementHeight:Number;

			// loop through the elements
			var layoutTarget:GroupBase = target;
			var count:int = layoutTarget.numElements;
			var element:ILayoutElement;
			for (var i:int = 0; i < count; i++) {
				// get the current element, we're going to work with the
				// ILayoutElement interface
				element = useVirtualLayout ? 
					layoutTarget.getVirtualElementAt(i) :
					layoutTarget.getElementAt(i);
				
				// Resize the element to its preferred size by passing
				// NaN for the width and height constraints
				element.setLayoutBoundsSize(NaN, NaN);
				elementHeight = element.getLayoutBoundsHeight();
				if ((element as Object).data 
						&& (element as Object).data.section) {
					
					element.setLayoutBoundsSize(containerWidth, elementHeight);
					elementWidth = containerWidth;
				} else {
					element.setLayoutBoundsSize(_columnWidth, elementHeight);
					elementWidth = _columnWidth;
				}				

				// Would the element fit on this line, or should we move
				// to the next line?
				if (x + elementWidth > containerWidth) {
					x = 0;
					y += elementHeight + _verticalGap;
				}
								
				// Position the element
				element.setLayoutBoundsPosition(x, y);
				
				// Find maximum element extents. This is needed for
				// the scrolling support.
				maxWidth = Math.max(maxWidth, x + elementWidth);
				maxHeight = Math.max(maxHeight, y + elementHeight);
				
				// Update the current position, add the gap
				x += elementWidth + _horizontalGap;
			}
			
			// Scrolling support - update the content size
			layoutTarget.setContentSize(maxWidth, maxHeight);
		}
	}
}