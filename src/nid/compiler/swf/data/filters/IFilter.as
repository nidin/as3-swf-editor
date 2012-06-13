package nid.compiler.swf.data.filters
{
	import nid.compiler.swf.SWFData;
	
	public interface IFilter
	{
		function get id():uint;
		
		function parse(data:SWFData):void;
		function publish(data:SWFData):void;
		function clone():IFilter;
		function toString(indent:uint = 0):String;
	}
}
