﻿package nid.compiler.swf.data.actions.swf3
{
	import nid.compiler.swf.data.actions.*;
	
	public class ActionToggleQuality extends Action implements IAction
	{
		public static const CODE:uint = 0x08;
		
		public function ActionToggleQuality(code:uint, length:uint) {
			super(code, length);
		}
		
		override public function toString(indent:uint = 0):String {
			return "[ActionToggleQuality]";
		}
	}
}
