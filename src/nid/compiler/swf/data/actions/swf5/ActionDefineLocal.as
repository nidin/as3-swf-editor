﻿package nid.compiler.swf.data.actions.swf5
{
	import nid.compiler.swf.data.actions.*;
	
	public class ActionDefineLocal extends Action implements IAction
	{
		public static const CODE:uint = 0x3c;
		
		public function ActionDefineLocal(code:uint, length:uint) {
			super(code, length);
		}
		
		override public function toString(indent:uint = 0):String {
			return "[ActionDefineLocal]";
		}
	}
}
