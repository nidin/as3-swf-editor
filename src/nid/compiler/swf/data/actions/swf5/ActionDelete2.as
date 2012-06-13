﻿package nid.compiler.swf.data.actions.swf5
{
	import nid.compiler.swf.data.actions.*;
	
	public class ActionDelete2 extends Action implements IAction
	{
		public static const CODE:uint = 0x3b;
		
		public function ActionDelete2(code:uint, length:uint) {
			super(code, length);
		}
		
		override public function toString(indent:uint = 0):String {
			return "[ActionDelete2]";
		}
	}
}
