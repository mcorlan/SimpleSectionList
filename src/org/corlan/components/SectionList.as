package org.corlan.components {
	
	import flash.events.MouseEvent;
	import spark.components.IItemRenderer;
	import spark.components.List;
	
	public class SectionList extends List {
		
		/**
		 * The property name for data that are section title items
		 */ 
		private var _sectionField:String;
		
		public function set sectionField(value:String):void {
			_sectionField = value;
		}

		/**
		 * Disable selection for section title items 
		 */
		override protected function item_mouseDownHandler(event:MouseEvent):void {
			var data:Object;
			if (event.currentTarget is IItemRenderer)
				data = IItemRenderer(event.currentTarget).data;
			if (data && data[_sectionField])
				event.preventDefault();
			super.item_mouseDownHandler(event);
		}
		
	}
}