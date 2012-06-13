package nid.xfl
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.setTimeout;
	import nid.compiler.abc.AbcGenerator;
	import nid.compiler.mediator.ScriptPool;
	import nid.compiler.swf.data.SWFRawTag;
	import nid.compiler.swf.data.SWFRecordHeader;
	import nid.compiler.swf.data.SWFSymbol;
	import nid.compiler.swf.factories.SWFTagFactory;
	import nid.compiler.swf.SWF;
	import nid.compiler.swf.SWFCompiler;
	import nid.compiler.swf.SWFData;
	import nid.compiler.swf.tags.ITag;
	import nid.compiler.swf.tags.TagDoABC;
	import nid.compiler.swf.tags.TagEnd;
	import nid.compiler.swf.tags.TagShowFrame;
	import nid.compiler.swf.tags.TagSymbolClass;
	import nid.xfl.core.XFLObject;
	import nid.xfl.events.XFLEvent;
	
	/**
	 * ...
	 * @author Nidin P Vinayakan
	 */
	public class XFLCompiler extends SWFCompiler
	{
		
		/**
		 * DoABC
		 */
		static public var DoABCTag:TagDoABC;
		static public var abcGenerator:AbcGenerator;
		static public var DoABC:Boolean;
		static public var SymbolClass:TagSymbolClass;
		private var ImportedSymbolClass:TagSymbolClass;
		private var ImportedAbcTag:TagDoABC;
		
		static private var _characterId:uint=1;
		static public function get characterId():uint { return _characterId; }
		static public function set characterId(value:uint):void { _characterId = value; }
		
		static public var displayList:Dictionary;
		static public var elementLibrary:Dictionary;
		private var data:SWFData;
		public var debug:Boolean;
		public var dumpString:String;
		
		static public function findSymbol(name:String):Boolean
		{
			for each(var sym:SWFSymbol in SymbolClass.symbols)
			{
				if(sym.name == name)return true;
			}
			return false;
		}
		
		public function XFLCompiler():void 
		{
			reset();
		}
		public function reset():void
		{
			DoABC 		= false;
			DoABCTag 	= null;
			SymbolClass	= null;
			ImportedAbcTag 	= null;
			ImportedSymbolClass = null;
			abcGenerator 	= null;
			displayList 	= null;
			elementLibrary 	= null;
			_characterId 	= 1;
			abcGenerator 	= new AbcGenerator();
			displayList 	= new Dictionary();
			elementLibrary 	= new Dictionary();
			tags = null;
			tags = new Vector.<ITag>();
			tagsRaw = null;
			tagsRaw = new Vector.<SWFRawTag>();
		}
		public function build(_xflobj:XFLObject, _debug:Boolean = false):void
		{
			reset();
			debug = _debug;
			xflobj = _xflobj;
			//xflobj.doc.DoABC = false;
			DoABC = xflobj.doc.DoABC;
			
			if (DoABC)
			{
				abcGenerator.prepair();
				XFLCompiler.DoABCTag 	= TagDoABC.create();
				SymbolClass				= null;
				SymbolClass 			= new TagSymbolClass();
			}
			
			/**
			 * SWF Properties
			 */
			backgroundColor = xflobj.doc.backgroundColor;
			frameSize.xmin 	= 0;
			frameSize.xmax 	= xflobj.doc.width * 20;
			frameSize.ymin 	= 0;;
			frameSize.ymax 	= xflobj.doc.height * 20;
			frameCount 		= xflobj.totalFrames;
			
			bytes = null;
			bytes = new ByteArray();
			
			data = null;
			data = new SWFData();
			
			buildHeader(data);
			scan();
			initTags();
			if (DoABC) importABC();
			else buildSWFTags();
			
		}
		public function scan():void
		{
			var property:Object = { depth:0 }
			property.clipDepths = new Object();
			
			//for (var l:int = 0; l < xflobj.layers.length; l++)
			//{
				//xflobj.layers[l].scan(property);
			//}
			var l:int = 0;
			
			with(xflobj)
			{
				for (l = 0; l < layers.length; l++)
				{
					if (layers[l].hasParentLayer && !layers[(layers.length - 1) - layers[l].parentLayerIndex].isScaned)
					{
						layers[(layers.length - 1) - layers[l].parentLayerIndex].scan(property);
					}
					if (layers[l].layerType == "mask")
					{
						layers[l].clipDepth = property.clipDepths[(layers.length - 1) - l];
					}
					else
					{
						layers[l].scan(property);
					}
				}
			}
		}
		public function buildSWFTags():void 
		{
			var qName:String	= xflobj.doc.NAME.replace(/[ ]/g, "");
			if(qName.indexOf("-") != -1)
			qName	= qName.substring(0, qName.indexOf("-"));
			
			var property:Object = { docName:qName, tagId:0 };
			
			property.frameScriptPool = [];
			
			for (var i:int = 0; i < xflobj.totalFrames; i++)
			{
				property.depth = 0;
				property.p_depth = "1";
				property.scriptPool = new ScriptPool(i);
				
				for (var l:int = 0; l < xflobj.layers.length; l++)
				{
					if (i < xflobj.layers[l].frames.length && xflobj.layers[l].frames[i] != null)
					{
						//xflobj.layers[l].publish(i, tags, property);
						with (xflobj)
						{
							if (layers[l].hasParentLayer && !layers[(layers.length - 1) - layers[l].parentLayerIndex].isPublished)
							{
								layers[(layers.length - 1) - layers[l].parentLayerIndex].publish(i, tags, property);
							}
							if(layers[l].layerType != "mask")
							{
								layers[l].publish(i, tags, property);
							}
						}
					}
				}
				
				if (property.scriptPool.script.length > 0)
				property.frameScriptPool.push(property.scriptPool);
				
				if (DoABC && i == 0)
				{
					tags.push(ImportedAbcTag);
					tags.push(ImportedSymbolClass);
				}
				
				tags.push(new TagShowFrame());
			}
			
			buildScriptPool(property);
			
			tags.push(new TagEnd());
			
			publishTags(data, version);
			publishFinalize(data);
			
			bytes.writeBytes(data);
			
			var swf:SWF = new SWF(bytes);
			//trace(swf);
			dumpString = swf.toString();
			
			dispatchEvent(new XFLEvent(XFLEvent.SWF_EXPORTED));
		}
		
		private function importABC():void 
		{
			if (xflobj.doc.TYPE == XFLType.ZIP)
			{
				//trace('abc.bin:' + xflobj.doc.zipDoc.files[xflobj.doc.NAME + '_abc.bin']);
				parseABC(null, xflobj.doc.zipDoc.files[xflobj.doc.NAME + '_abc.bin']);
			}
			else 
			{
				var loader:URLLoader = new URLLoader();
				loader.dataFormat = URLLoaderDataFormat.BINARY;
				loader.addEventListener(Event.COMPLETE, parseABC);
				loader.load(new URLRequest(xflobj.doc.BIN_PATH + 'abc.bin'));
			}
		}
		
		private function parseABC(e:Event,ba:ByteArray=null):void 
		{
			var tagFactory:SWFTagFactory = new SWFTagFactory();
			var abc_ba:ByteArray;
			var abc_data:SWFData = new SWFData();
			
			if (xflobj.doc.TYPE == XFLType.ZIP)
			{
				abc_ba = ba;
			}
			else
			{
				abc_ba = e.target.data;
			}
			
			abc_data.length = 0;
			abc_ba.position = 0;
			abc_ba.readBytes(abc_data);
			
			for (var i:int = 0; i < 2 ; i++)
			{
				var tagRaw:SWFRawTag = abc_data.readRawTag();
				var tagHeader:SWFRecordHeader = tagRaw.header;
				var tag:ITag = tagFactory.create(tagHeader.type);
				tag.parse(abc_data, tagHeader.contentLength, 9, false);
				//tags.push(tag);
				//trace(tag);
				
				if (tag is TagSymbolClass)
				{
					ImportedSymbolClass = tag as TagSymbolClass;
				}
				else if (tag is TagDoABC)
				{
					ImportedAbcTag = tag as TagDoABC;
				}
			}
			
			buildSWFTags();
		}
		
		
		
		/**
		 * Feature purpose 
		 * Not used now
		 * 
		 */
		private function buildScriptPool(property:Object):void
		{
			if (property.frameScriptPool.length > 0)
			{
				if (!XFLCompiler.findSymbol(property.docName + '_fla.MainTimeline'))
				{
					var symbol:SWFSymbol = SWFSymbol.create(property.tagId, property.docName + '_fla.MainTimeline');
					XFLCompiler.SymbolClass.symbols.push(symbol);
				}
				
				XFLCompiler.abcGenerator.addSymbolClass(property.docName + '_fla','MainTimeline', property.frameScriptPool);
			}
			
			if (DoABC)
			{
				for (var i:int = 0; i < SymbolClass.symbols.length; i++)
				{
					var sName1:String = classPrefix(property.docName) + SymbolClass.symbols[i].name;
					
					for (var j:int = 0; j < ImportedSymbolClass.symbols.length; j++)
					{
						var sName2:String = ImportedSymbolClass.symbols[j].name;
						sName2 = sName2.substring(0, sName2.lastIndexOf('_'));
						
						trace('sName1:' + sName1);
						trace('sName2:' + sName2);
						
						if (sName1 == sName2)
						{
							trace('match found @: tagId:' + SymbolClass.symbols[i].tagId + ' name:' + ImportedSymbolClass.symbols[j].name);
							ImportedSymbolClass.symbols[j].tagId = SymbolClass.symbols[i].tagId;
							//trace('--------------------------------');
							//trace(SymbolClass.symbols[i]);
							//trace(ImportedSymbolClass.symbols[i]);
						}
					}
				}
			}
		}
		private function classPrefix(docName:String):String
		{
			if (String(Number(docName.charAt(0))) == "NaN") return '';
			else return'_';
		}
		
		private function buildABC():void 
		{
			//trace('building abc...');
			//XFLCompiler.DoABCTag.bytes = abcGenerator.build();
			//tags.push(XFLCompiler.DoABCTag);
			//tags.push(SymbolClass);
		}
		
	}
	
}