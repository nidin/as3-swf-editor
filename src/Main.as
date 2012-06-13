package 
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.FileReference;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import nid.ui.Button;
	import nid.xfl.editor.avm.AVMEnvironment;
	import nid.xfl.events.XFLEvent;
	import nid.xfl.XFLEditor;
	
	/**
	 * ...
	 * @author Nidin P Vinayakan
	 */
	public class Main extends Sprite 
	{
		static public var _stage:Stage;
		private var xfleditor:XFLEditor;
		private var fileref:FileReference;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			_stage = stage;
			
			xfleditor = new XFLEditor();
			addChild(xfleditor);
			xfleditor.addEventListener(XFLEvent.READY, exportSWF);
			
			/**
			 *  New template test
			 */
			xfleditor.load("template test/text_exp_2/text_exp_2.xfl");
			
			var build:Button = new Button("Build SWF",100);
			build.x  = stage.stageWidth - build.width;
			addChild(build);
			
			var reload:Button = new Button("Reload XFL",100);
			reload.x  = build.x - reload.width;
			addChild(reload);
			
			var fps:TextField = new TextField();
			fps.defaultTextFormat = new TextFormat("Arial", 12, 0xff0000, true);
			fps.width = 60;
			fps.x = reload.x - 70;
			fps.text = 'FPS:' + AVMEnvironment.fps.toString();
			addChild(fps);
			
			build.addEventListener(MouseEvent.CLICK, saveSWF);
			reload.addEventListener(MouseEvent.CLICK, reloadXFL);
		}
		
		private function reloadXFL(e:MouseEvent):void 
		{
			
			xfleditor.reload();
		}
		
		private function saveSWF(e:MouseEvent):void 
		{
			xfleditor.exportSWF();
		}
		
		private function exportSWF(e:XFLEvent):void 
		{
			//xfleditor.exportSWF();
		}
		
		private function browseFile(e:MouseEvent):void 
		{
			fileref = new FileReference();
			fileref.addEventListener(Event.SELECT, onSelect);
			fileref.browse();
		}
		
		private function onSelect(e:Event):void 
		{
			fileref.addEventListener(Event.COMPLETE, onFileLoaded);
			fileref.load();
			//xfleditor.load(fileref.data);
		}
		
		private function onFileLoaded(e:Event):void 
		{
			trace('data loaded');
			xfleditor.load(fileref.data);
		}
		
	}
	
}