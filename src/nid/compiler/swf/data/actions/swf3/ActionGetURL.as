﻿package nid.compiler.swf.data.actions.swf3
{
	import nid.compiler.swf.SWFData;
	import nid.compiler.swf.data.actions.*;
	
	public class ActionGetURL extends Action implements IAction
	{
		public static const CODE:uint = 0x83;
		
		public var urlString:String;
		public var targetString:String;
		
		public function ActionGetURL(code:uint, length:uint) {
			super(code, length);
		}
		
		override public function parse(data:SWFData):void {
			urlString = data.readString();
			targetString = data.readString();
		}
		
		override public function publish(data:SWFData):void {
			var body:SWFData = new SWFData();
			body.writeString(urlString);
			body.writeString(targetString);
			write(data, body);
		}
		
		override public function clone():IAction {
			var action:ActionGetURL = new ActionGetURL(code, length);
			action.urlString = urlString;
			action.targetString = targetString;
			return action;
		}
		
		override public function toString(indent:uint = 0):String {
			return "[ActionGetURL] URL: " + urlString + ", Target: " + targetString;
		}
	}
}
