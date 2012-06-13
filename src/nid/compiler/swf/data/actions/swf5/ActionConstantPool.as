﻿package nid.compiler.swf.data.actions.swf5
{
	import nid.compiler.swf.SWFData;
	import nid.compiler.swf.data.actions.*;
	import nid.compiler.utils.StringUtils2;
	
	public class ActionConstantPool extends Action implements IAction
	{
		public static const CODE:uint = 0x88;
		
		public var constants:Vector.<String>;
		
		public function ActionConstantPool(code:uint, length:uint) {
			super(code, length);
			constants = new Vector.<String>();
		}
		
		override public function parse(data:SWFData):void {
			var count:uint = data.readUI16();
			for (var i:uint = 0; i < count; i++) {
				constants.push(data.readString());
			}
		}
		
		override public function publish(data:SWFData):void {
			var body:SWFData = new SWFData();
			body.writeUI16(constants.length);
			for (var i:uint = 0; i < constants.length; i++) {
				body.writeString(constants[i]);
			}
			write(data, body);
		}
		
		override public function clone():IAction {
			var action:ActionConstantPool = new ActionConstantPool(code, length);
			for (var i:uint = 0; i < constants.length; i++) {
				action.constants.push(constants[i]);
			}
			return action;
		}
		
		override public function toString(indent:uint = 0):String {
			var str:String = "[ActionConstantPool] Values: " + constants.length;
			for (var i:uint = 0; i < constants.length; i++) {
				str += "\n" + StringUtils2.repeat(indent + 4) + i + ": " + StringUtils2.simpleEscape(constants[i]);
			}
			return str;
		}
	}
}
