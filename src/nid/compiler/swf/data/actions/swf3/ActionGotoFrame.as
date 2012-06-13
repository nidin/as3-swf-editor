﻿package nid.compiler.swf.data.actions.swf3
{
	import nid.compiler.swf.SWFData;
	import nid.compiler.swf.data.actions.*;
	
	public class ActionGotoFrame extends Action implements IAction
	{
		public static const CODE:uint = 0x81;
		
		public var frame:uint;
		
		public function ActionGotoFrame(code:uint, length:uint) {
			super(code, length);
		}
		
		override public function parse(data:SWFData):void {
			frame = data.readUI16();
		}
		
		override public function publish(data:SWFData):void {
			var body:SWFData = new SWFData();
			body.writeUI16(frame);
			write(data, body);
		}
		
		override public function clone():IAction {
			var action:ActionGotoFrame = new ActionGotoFrame(code, length);
			action.frame = frame;
			return action;
		}
		
		override public function toString(indent:uint = 0):String {
			return "[ActionGotoFrame] Frame: " + frame;
		}
	}
}
