package nid.xfl.dom 
{
	import nid.utils.Boolean2;
	import nid.xfl.dom.DOMDocument;
	//import nid.xfl.data.display.DisplayFrame;
	/**
	 * ...
	 * @author Nidin P Vinayakan
	 */
	public class DOMLayer 
	{
		/**
		 * XFL Reference
		 */
		public var doc:DOMDocument;
		
		/**
		 * 
		 */
		public var name:String;
		public var color:uint;
		public var locked:Boolean;
		public var current:Boolean;
		public var isSelected:Boolean;
		public var animationType:String;
		public var layerType:String;
		public var parentLayerIndex:int;
		public var hasParentLayer:Boolean;
		public var domframes:Vector.<DOMFrame>;
		public var totalFrames:int = 0;
		public var isPlaced:Boolean;
		public var isRemoved:Boolean;
		
		public function DOMLayer(data:XML=null,refdoc:DOMDocument=null) 
		{	
			doc = refdoc;
			
			if (data != null)
			{
				parse(data);
			}
		}
		
		public function parse(data:XML):void
		{
			name 				= data.@name;
			color 				= uint(data.@color.replace("#","0x"));
			locked 				= Boolean2.toBoolean(data.@locked);
			current 			= Boolean2.toBoolean(data.@current);
			isSelected 			= Boolean2.toBoolean(data.@isSelected);
			animationType 		= data.@animationType;
			layerType 			= data.@layerType;
			parentLayerIndex 	= data.@parentLayerIndex;
			hasParentLayer 		= String(data.@parentLayerIndex) == ""?false:true;
			
			domframes = null;
			domframes = new Vector.<DOMFrame>();
			
			//displayframes = null;
			//displayframes = new Vector.<DisplayFrame>();
			
			for (var i:int = 0; i < data.frames.DOMFrame.length(); i++)
			{
				/**
				 * BUILD XFL DOM FRAMES
				 */
				domframes.push(new DOMFrame(data.frames.DOMFrame[i], doc));
			}
			
		}
		
	}

}