package nid.compiler.swf.tags.etc
{
	import nid.compiler.swf.tags.ITag;
	import nid.compiler.swf.tags.TagUnknown;
	
	public class TagSWFEncryptActions extends TagUnknown implements ITag
	{
		public static const TYPE:uint = 253;
		
		public function TagSWFEncryptActions(type:uint = 0) {}
		
		override public function get type():uint { return TYPE; }
		override public function get name():String { return "SWFEncryptActions"; }
	}
}
