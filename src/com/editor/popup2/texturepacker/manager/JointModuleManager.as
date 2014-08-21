package com.editor.popup2.texturepacker.manager
{
	import com.air.io.DeleteFile;
	import com.air.io.FileUtils;
	import com.air.io.SaveImage;
	import com.air.io.SelectFile;
	import com.air.io.WriteFile;
	import com.editor.component.containers.UICanvas;
	import com.editor.popup2.texturepacker.mediator.JointModuleLibMediator;
	import com.editor.popup2.texturepacker.mediator.JointModulePreviewMediator;
	import com.editor.popup2.texturepacker.mediator.JointModuleToolBarMediator;
	import com.sandy.asComponent.controls.interfac.IASMenuButton;
	import com.sandy.common.zipUtil.ZipEntry;
	import com.sandy.common.zipUtil.ZipOutput;
	import com.sandy.component.expand.data.SandyMenuData;
	import com.sandy.event.SandyExternalEvent;
	import com.sandy.gameTool.image.JPGEncoder;
	import com.sandy.manager.SandyManagerBase;
	import com.sandy.math.SandyArray;
	import com.sandy.popupwin.data.OpenMessageData;
	import com.sandy.utils.BitmapDataUtil;
	import com.sandy.utils.UIComponentUtil;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	public class JointModuleManager extends SandyManagerBase
	{
		private static var instance:JointModuleManager;
		public static function getInstance():JointModuleManager
		{
			return !instance?instance = new JointModuleManager:instance;
		}
		
		public static var img_w:int = 512;
		public static var img_h:int = 512;
		public static var selectFold:File;
				
		
		
		public function clear():void
		{
			get_JointModuleLibMediator().reflash();
			get_JointModulePreviewMediator().reflash();
		}
		
		public function reflashLib(load:Boolean=false):void
		{
			get_JointModuleLibMediator().reflash();
			if(load){
				get_JointModulePreviewMediator().reflash();
			}
		}
		
		public function get_JointModuleLibMediator():JointModuleLibMediator
		{
			return iManager.retrieveMediator(JointModuleLibMediator.NAME) as JointModuleLibMediator;
		}
		
		public function get_JointModulePreviewMediator():JointModulePreviewMediator
		{
			return iManager.retrieveMediator(JointModulePreviewMediator.NAME) as JointModulePreviewMediator;
		}
		
		public function get_JointModuleToolBarMediator():JointModuleToolBarMediator
		{
			return iManager.retrieveMediator(JointModuleToolBarMediator.NAME) as JointModuleToolBarMediator;
		}
		
		public function getAllImage():Array
		{
			var f:FileUtils = new FileUtils();
			f.getAllDirectoryListing(selectFold,["jpg","png"]);
			return f.file_ls;
		}
		
		
		///////////////////// xml ///////////////////////////
		
		private var proXmlFile:File;
		private var proXmlData:String;
		
		public function publish():void
		{
			var a:Array = getAllImage();
			if(a.length == 0){
				iManager.applicationMediator.showError("数据存在异常");
				return ;
			}
			SelectFile.selectDirectory("保存目录",saveProjectHandler);
		}
		
		private function saveProjectHandler(e:Event):void
		{
			var f:File = e.target as File;
			
			var s:String = "<TextureAtlas imagePath='" + f.name + "'>\n";
			var a:Array = get_JointModulePreviewMediator().bma_ls;
			for(var i:int=0;i<a.length;i++)
			{
				var obj:Object = a[i] as Object;
				var bm:Bitmap = obj.bitmap;
				var fl:File = obj.file;
				var rect:Rectangle = obj.rect;
				s += "\t<SubTexture name='"+fl.name.split(".")[0]+"' x='"+rect.x +"' y='"+rect.y +"' width='"+rect.width+"' height='"+rect.height +"'/>\n";
			}
			s += "</TextureAtlas>";
			
			var xml_file:File = new File(f.nativePath+File.separator+"texture.xml")
			var w:WriteFile = new WriteFile();
			w.write(xml_file,s);
			
			var bms:UICanvas = get_JointModulePreviewMediator().bms;
			var bt:BitmapData = BitmapDataUtil.getBitmapData(bms.width,bms.height);
			bt.draw(bms,null,null,null,null,true);
			var img_file:File = new File(f.nativePath+File.separator+"texture"+get_JointModuleToolBarMediator().fmb.selectedItem)
			SaveImage.saveByPath(bt,img_file);
		}
		
		
	}
}