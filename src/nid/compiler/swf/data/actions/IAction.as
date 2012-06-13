package nid.compiler.swf.data.actions
{
	import nid.compiler.swf.SWFData;
	
	public interface IAction
	{
		function get code():uint;
		function get length():uint;
		
		function parse(data:SWFData):void;
		function publish(data:SWFData):void;
		function clone():IAction;
		function toString(indent:uint = 0):String;
	}
}
