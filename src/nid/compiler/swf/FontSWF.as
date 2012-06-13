package nid.compiler.swf 
{
	import flash.utils.ByteArray;
	import nid.compiler.swf.data.SWFKerningRecord;
	import nid.compiler.swf.data.SWFRectangle;
	import nid.compiler.swf.data.SWFShape;
	import nid.compiler.swf.data.SWFZoneRecord;
	import nid.compiler.swf.tags.TagCSMTextSettings;
	import nid.compiler.swf.tags.TagDefineFont3;
	import nid.compiler.swf.tags.TagDefineFontAlignZones;
	import nid.compiler.swf.tags.TagDefineFontName;
	import nid.compiler.swf.tags.TagDefineText;
	/**
	 * ...
	 * @author Nidin P Vinayakan
	 */
	public class FontSWF extends SWF 
	{
		protected var _glyphShapeTable:Vector.<SWFShape>;
		protected var _codeTable:Vector.<uint>;
		protected var _fontAdvanceTable:Vector.<int>;
		protected var _fontBoundsTable:Vector.<SWFRectangle>;
		protected var _fontKerningTable:Vector.<SWFKerningRecord>;
		
		protected var _zoneTable:Vector.<SWFZoneRecord>;
		
		public var defineFontName:TagDefineFontName;
		public var ascent:int;
		public var descent:int;
		public var leading:int;
		
		public function FontSWF(ba:ByteArray = null)
		{
			super(ba);
			
			for (var i:int = 0; i < tags.length; i++)
			{
				if (tags[i] is TagDefineFont3)
				{
					_glyphShapeTable 	= TagDefineFont3(tags[i]).glyphShapeTable;
					_codeTable 			= TagDefineFont3(tags[i]).codeTable;
					_fontAdvanceTable 	= TagDefineFont3(tags[i]).fontAdvanceTable;
					_fontKerningTable 	= TagDefineFont3(tags[i]).fontKerningTable;
					ascent				= TagDefineFont3(tags[i]).ascent;
					descent				= TagDefineFont3(tags[i]).descent;
					leading				= TagDefineFont3(tags[i]).leading;
				}
				else if (tags[i] is TagDefineFontAlignZones)
				{
					_zoneTable = TagDefineFontAlignZones(tags[i]).zoneTable;
				}
				else if (tags[i] is TagDefineFontName)
				{
					defineFontName = tags[i] as TagDefineFontName;
				}
			}
		}
		public function get glyphShapeTable():Vector.<SWFShape>{ return _glyphShapeTable; }
		public function get codeTable():Vector.<uint> { return _codeTable; }
		public function get fontAdvanceTable():Vector.<int> { return _fontAdvanceTable; }
		public function get fontBoundsTable():Vector.<SWFRectangle> { return _fontBoundsTable; }
		public function get fontKerningTable():Vector.<SWFKerningRecord> { return _fontKerningTable; }
		
		public function get zoneTable():Vector.<SWFZoneRecord> { return _zoneTable; }
		
	}

}