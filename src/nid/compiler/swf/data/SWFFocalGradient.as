﻿package nid.compiler.swf.data
{
	import nid.compiler.swf.SWFData;
	
	public class SWFFocalGradient extends SWFGradient
	{
		public function SWFFocalGradient(data:SWFData = null, level:uint = 1) {
			super(data, level);
		}
		
		override public function parse(data:SWFData, level:uint):void {
			super.parse(data, level);
			focalPoint = data.readFIXED8();
		}
		
		override public function publish(data:SWFData, level:uint = 1):void {
			super.publish(data, level);
			data.writeFIXED8(focalPoint);
		}
		
		override public function toString():String {
			return "(" + _records.join(",") + ")";
		}
	}
}
