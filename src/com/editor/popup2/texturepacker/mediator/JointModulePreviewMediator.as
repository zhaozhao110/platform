package com.editor.popup2.texturepacker.mediator
{
	import com.air.io.ReadImage;
	import com.air.io.WriteFile;
	import com.air.logging.CatchErrorLog;
	import com.editor.component.containers.UICanvas;
	import com.editor.mediator.AppMediator;
	import com.editor.popup2.texturepacker.manager.JointModuleManager;
	import com.editor.popup2.texturepacker.manager.MaxRectsBinPack;
	import com.editor.popup2.texturepacker.view.JointModulePreview;
	import com.sandy.utils.BitmapDataUtil;
	import com.sandy.utils.UIComponentUtil;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.filesystem.File;
	import flash.geom.Rectangle;

	public class JointModulePreviewMediator extends AppMediator
	{
		public static const NAME:String = "JointModulePreviewMediator";
		public function JointModulePreviewMediator(viewComponent:*):void
		{
			super(NAME,viewComponent);
		}
		public function get win():JointModulePreview
		{
			return viewComponent as JointModulePreview;
		}
		public function get bms():UICanvas
		{
			return win.bms;
		}
		public function get bms_cont():UICanvas
		{
			return win.bms_cont;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			resetSize()
		}
		
		public function resetSize():void
		{
			bms.width = JointModuleManager.img_w;
			bms.height = JointModuleManager.img_h;
		}
		
		public var bma_ls:Array = [];
		private var load_total:int;
		private var pack:MaxRectsBinPack;
		
		public function reflash():void
		{
			var saveF:File = JointModuleManager.selectFold
			
			//CatchErrorLog.getInstance().error("1");
			resetSize()
			//if(JointModuleManager.getInstance().get_JointModulePreviewMediator().bma_ls.length == 0) return 
			var a:Array = saveF.getDirectoryListing();
			if(a.length == 0){
				clear();
				return ;
			}
			
			pack = new MaxRectsBinPack(bms.width,bms.height);
			bma_ls=null;bma_ls=[];
			clear();
			
			a = JointModuleManager.getInstance().getAllImage();
			load_total = a.length;
			//CatchErrorLog.getInstance().error("2"+"/"+a.length+"/"+JointModuleManager.getInstance().getSaveFile().getDirectoryListing().length);
			for(var i:int=0;i<a.length;i++)
			{
				var read:ReadImage = new ReadImage();
				read.complete_f = loadComplete;
				//CatchErrorLog.getInstance().error("3/"+File(a[i]).nativePath);
				read.loadImageFromFile(a[i] as File);
			}
		}
		
		private function loadComplete(bmp:Bitmap,img:ReadImage):void
		{
			var cl_bmp:Bitmap = new Bitmap(bmp.bitmapData.clone());
						
			var rect:Rectangle = pack.insert(cl_bmp.width,cl_bmp.height,(retrieveMediator(JointModuleToolBarMediator.NAME) as JointModuleToolBarMediator).win.packType_cb.selectedIndex+1);
			bma_ls.push({file:img.selectedFile,bitmap:cl_bmp,rect:rect});
			cl_bmp.x = rect.x;
			cl_bmp.y = rect.y;
			bms.addChild(cl_bmp);
		}
				
		private function clear():void
		{
			UIComponentUtil.removeAllChild(bms);
		}
		
		public function getBitmap():BitmapData
		{
			var bt:BitmapData = BitmapDataUtil.getBitmapData(bms.width,bms.height);
			bt.draw(bms);
			return bt;
		}
		
	}
}