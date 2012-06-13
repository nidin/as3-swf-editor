package nid.compiler.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Nidin P Vinayakan
	 */
	public class CompilerEvent extends Event 
	{
		public static const SUCCESS:String = "success";
		public static const FAILED:String = "failed";
		
		public var data:Object;
		
		public function CompilerEvent(type:String,data:Object=null, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			this.data = data;	
		} 
		
		public override function clone():Event 
		{ 
			return new CompilerEvent(type,data, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("CompilerEvent", "type", "data", "bubbles", "cancelable", "eventPhase");
		}
		
	}
	
}