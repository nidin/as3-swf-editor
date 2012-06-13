package nid.compiler.swf.tags
{
	import nid.compiler.utils.StringUtils2;
	
	public class Tag
	{
		public static function toStringCommon(type:uint, name:String, indent:uint = 0):String {
			return StringUtils2.repeat(indent) + "[" + StringUtils2.printf("%02d", type) + ":" + name + "] ";
		}
	}
}
