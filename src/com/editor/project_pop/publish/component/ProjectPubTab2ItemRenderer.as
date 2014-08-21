package com.editor.project_pop.publish.component
{
	import com.air.io.FileUtils;
	import com.editor.component.controls.UILabel;
	import com.editor.modules.cache.ProjectCache;
	import com.editor.project_pop.publish.mediator.ProjectPubTab2Mediator;
	import com.sandy.asComponent.containers.ASCanvas;
	import com.sandy.asComponent.controls.ASSpace;
	import com.sandy.asComponent.itemRenderer.ASHListItemRenderer;
	import com.sandy.asComponent.itemRenderer.ASListItemRenderer;
	import com.sandy.component.itemRenderer.SandyHBoxItemRenderer;
	import com.sandy.component.itemRenderer.SandyHListItemRenderer;
	import com.sandy.utils.ColorUtils;
	import com.sandy.utils.TimerUtils;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.filesystem.File;

	public class ProjectPubTab2ItemRenderer extends SandyHListItemRenderer
	{
		public function ProjectPubTab2ItemRenderer()
		{
			super();
			create_init();
		}
		
		private var ti1:UILabel;
		private var ti2:UILabel;
		private var ti3:UILabel;
		private var ti4:UILabel;
		
		override protected function renderTextField():void{};
		
		//[Embed(source='theme/classic/swf/assets.swf', symbol='tree_tick_a2')]
		public var tree_tick_a2:String = "tree_tick_a2";
		
		//√的
		//[Embed(source='/theme/classic/swf/assets.swf', symbol='tree_tick_a1')]
		public var tree_tick_a1:String = "tree_tick_a1";
		
		protected var folderClosedIcon:DisplayObject;
		protected var folderOpenIcon:DisplayObject;
		
		private function create_init():void
		{
			mouseChildren = true;
			mouseEnabled = true;
			
			var sp2:ASSpace = new ASSpace();
			sp2.width = 10;
			sp2.height = 10
			addChild(sp2);
				
			var folder_sp:ASCanvas = new ASCanvas();
			folder_sp.mouseEnabled = true;
			folder_sp.mouseChildren = false
			folder_sp.addEventListener(MouseEvent.CLICK , onFolderClick);
			addChild(folder_sp);
			
			folderClosedIcon = new Bitmap(iManager.iResource.getBitmapData(tree_tick_a2)) as DisplayObject;
			folder_sp.addChild(folderClosedIcon);
			
			folder_sp.width = folderClosedIcon.width;
			folder_sp.height = folderClosedIcon.height;
			
			folderOpenIcon = new Bitmap(iManager.iResource.getBitmapData(tree_tick_a1)) as DisplayObject;
			folder_sp.addChild(folderOpenIcon);
			folderOpenIcon.visible = false;
			
			ti1 = new UILabel();
			ti1.mouseEnabled=false;
			ti1.mouseChildren = false
			ti1.width = 250
			addChild(ti1);
			
			ti2 = new UILabel();
			ti2.mouseEnabled=false;
			ti2.mouseChildren = false;
			ti2.width = 250
			addChild(ti2);
			
			ti3 = new UILabel();
			ti3.mouseEnabled=false;
			ti3.mouseChildren = false;
			ti3.width = 250
			addChild(ti3);
			
			ti4 = new UILabel();
			ti4.mouseEnabled=false;
			ti4.mouseChildren = false;
			ti4.width = 100
			addChild(ti4);
			
		}
		
		private function getThemeSwfFile():File
		{
			return new File(ProjectCache.getInstance().getThemeAssetsPath()+File.separator+"swf");
		}
		
		override public function poolChange(value:*):void
		{
			super.poolChange(value);
			
			var swf_fl:File = File(value);
			var bin_fl:File = getBinSwfFile(swf_fl.name.split(".")[0],swf_fl.nativePath.indexOf(getThemeSwfFile().nativePath)!=-1);
			
			ti1.text = swf_fl.name;
			ti2.text = TimerUtils.getFromatTime(swf_fl.modificationDate.time/1000);
			if(bin_fl!=null){
				ti3.text = TimerUtils.getFromatTime(bin_fl.modificationDate.time/1000);
				if(swf_fl.modificationDate.time > bin_fl.modificationDate.time){
					isPass();
				}
				ti4.text = FileUtils.getFileSize(bin_fl.nativePath)+"K";
			}else{
				ti3.text = ""
				ti4.text = ""
				isPass()
			}
			
		}
		
		public var needCompile:Boolean;
		
		override public function poolDispose():void
		{
			super.poolDispose();
			needCompile = false
			ti1.color = ColorUtils.black;
			ti2.color = ColorUtils.black;
			ti3.color = ColorUtils.black;
		}
		
		private function isPass():void
		{
			needCompile = true
			ti1.color = ColorUtils.red;
			ti2.color = ColorUtils.red;
			ti3.color = ColorUtils.red;
		}
		
		private function getBinSwfFile(n:String,isInTheme:Boolean):File
		{
			var bin_swf:File;
			if(!isInTheme){
				bin_swf = new File(ProjectCache.getInstance().getBin()+File.separator+"assets"+File.separator+"swf");
			}else{
				bin_swf = new File(ProjectCache.getInstance().getBin()+File.separator+"theme"+File.separator+"assets"+File.separator+"swf");
			}
			var fl:File = new File(bin_swf.nativePath+File.separator+n+".swf");
			if(fl.exists){
				return fl;
			}
			return null;
		}
		
		public function select2():void
		{
			if(!needCompile) return ;
			folderOpenIcon.visible = true
			folderClosedIcon.visible = false
				
			get_ProjectPubTab2Mediator().addSwf(data as File);	
		}
		
		private function onFolderClick(e:MouseEvent):void
		{
			if(folderOpenIcon.visible){
				folderOpenIcon.visible = false;
				folderClosedIcon.visible = true
			}else{
				folderOpenIcon.visible = true
				folderClosedIcon.visible = false
			}
			
			if(folderOpenIcon.visible){
				get_ProjectPubTab2Mediator().addSwf(data as File);
			}else{
				get_ProjectPubTab2Mediator().delSwf(data as File);
			}
		}
		
		private function get_ProjectPubTab2Mediator():ProjectPubTab2Mediator
		{
			return iManager.retrieveMediator(ProjectPubTab2Mediator.NAME) as ProjectPubTab2Mediator;
		}
	}
}