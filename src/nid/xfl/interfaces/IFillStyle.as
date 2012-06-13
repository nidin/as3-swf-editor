package nid.xfl.interfaces 
{
	import nid.compiler.swf.data.SWFFillStyle;
	import nid.compiler.swf.tags.ITag;
	
	/**
	 * ...
	 * @author Nidin P Vinayakan
	 */
	public interface IFillStyle 
	{
		function export(type:int, tags:Vector.<ITag> = null, property:Object = null):SWFFillStyle;
		function get color():uint;
		function get alpha():Number;
		function get index():uint;
	}
	
}