﻿package nid.compiler.swf.tags
{
	import nid.compiler.swf.SWF;
	import nid.compiler.swf.SWFData;
	import nid.compiler.swf.SWFTimelineContainer;
	import nid.compiler.swf.tags.IDefinitionTag;
	import nid.compiler.swf.timeline.Frame;
	import nid.compiler.swf.timeline.Layer;
	import nid.compiler.swf.timeline.Scene;
	
	import flash.utils.Dictionary;
	
	public class TagDefineSprite extends SWFTimelineContainer implements IDefinitionTag
	{
		public static const TYPE:uint = 39;
		
		public var frameCount:uint;
		
		protected var _characterId:uint;
		
		public function TagDefineSprite() {}
		
		public function get characterId():uint { return _characterId; }
		public function set characterId(value:uint):void { _characterId = value; }
		
		public function parse(data:SWFData, length:uint, version:uint, async:Boolean = false):void {
			_characterId = data.readUI16();
			frameCount = data.readUI16();
			/*
			if(async) {
				parseTagsAsync(data, version);
			} else {
				parseTags(data, version);
			}
			*/
			parseTags(data, version);
		}
		
		public function publish(data:SWFData, version:uint):void {
			var body:SWFData = new SWFData();
			body.writeUI16(characterId);
			body.writeUI16(frameCount); // TODO: get the real number of frames from controlTags
			publishTags(body, version);
			data.writeTagHeader(type, body.length);
			data.writeBytes(body);
		}
		
		public function clone():IDefinitionTag {
			var tag:TagDefineSprite = new TagDefineSprite();
			throw(new Error("Not implemented yet."));
			return tag;
		}
		
		public function get type():uint { return TYPE; }
		public function get name():String { return "DefineSprite"; }
		public function get version():uint { return 3; }
		public function get level():uint { return 1; }
	
		override public function toString(indent:uint = 0):String {
			return Tag.toStringCommon(type, name, indent) +
				"ID: " + characterId + ", " +
				"FrameCount: " + frameCount +
				super.toString(indent);
		}
	}
}
