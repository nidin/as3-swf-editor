package nid.compiler.swf.factories
{
	import nid.compiler.swf.tags.ITag;

	public interface ISWFTagFactory
	{
		function create(type:uint):ITag;
	}
}