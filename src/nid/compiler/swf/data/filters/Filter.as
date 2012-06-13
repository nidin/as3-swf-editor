﻿package nid.compiler.swf.data.filters
{
	import nid.compiler.swf.SWFData;
	
	public class Filter implements IFilter
	{
		protected var _id:uint;
		
		public function Filter(id:uint) {
			_id = id;
		}

		public function get id():uint { return _id; }
		
		public function parse(data:SWFData):void {
			throw(new Error("Implement in subclasses!"));
		}
		
		public function publish(data:SWFData):void {
			throw(new Error("Implement in subclasses!"));
		}
		
		public function clone():IFilter {
			throw(new Error("Implement in subclasses!"));
		}
		
		public function toString(indent:uint = 0):String {
			return "[Filter]";
		}
	}
}
