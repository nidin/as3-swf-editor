﻿package nid.compiler.swf.data.actions.swf5
{
	import nid.compiler.swf.data.actions.*;
	
	public class ActionEquals2 extends Action implements IAction
	{
		public static const CODE:uint = 0x49;
		
		public function ActionEquals2(code:uint, length:uint) {
			super(code, length);
		}
		
		override public function toString(indent:uint = 0):String {
			return "[ActionEquals2]";
		}
	}
}
