package com.editor.project_pop.getLocale.component
{
	import com.air.io.SandyFileProxy;
	import com.editor.component.containers.UICanvas;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UIImage;
	import com.editor.component.controls.UILinkButton;
	import com.editor.component.controls.UIText;
	import com.editor.project_pop.getLocale.tab2.AppGetLocaleTab2Cache;
	import com.editor.project_pop.getLocale.tab2.AppGetLocaleTab2_tab;
	import com.sandy.asComponent.controls.ASSpace;
	import com.sandy.asComponent.itemRenderer.ASHListItemRenderer;
	import com.sandy.asComponent.vo.ASComponentConst;
	import com.sandy.component.itemRenderer.SandyHBoxItemRenderer;
	import com.sandy.utils.StringTWLUtil;
	import com.sandy.utils.TimerUtils;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
		
	public class AppGetLocaleItemRenderer extends ASHListItemRenderer
	{
		public function AppGetLocaleItemRenderer()
		{
			super();
			verticalAlign = ASComponentConst.verticalAlign_middle;
			create_init();
		}
		
		override protected function renderTextField():void{};
		
		//[Embed(source='theme/classic/swf/assets.swf', symbol='tree_tick_a2')]
		public var tree_tick_a2:String = "tree_tick_a2";
		
		//√的
		//[Embed(source='/theme/classic/swf/assets.swf', symbol='tree_tick_a1')]
		public var tree_tick_a1:String = "tree_tick_a1";
		
		private var fileName:*;
		private var file:SandyFileProxy;
		private var ti:UIText;
		private var iconImg:UIImage
		private var folderClosedIcon:DisplayObject;
		private var folderOpenIcon:DisplayObject;
		
		private var folder_sp:UICanvas
		
		private function create_init():void
		{
			
			horizontalGap = 10;
			
			var sp2:ASSpace = new ASSpace();
			sp2.width = 20;
			sp2.height = 20
			addChild(sp2);
			
			folder_sp = new UICanvas();
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
			
			iconImg = new UIImage();
			addChild(iconImg);
			
			
			ti = new UIText();
			ti.mouseEnabled=false;
			ti.mouseChildren = false
			ti.width = 250
			addChild(ti);
			
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
			
			setCache(folderOpenIcon.visible);
			
			if(folderOpenIcon.visible){
				
			}else{
				
			}
		}
		
		public function mySelect(v:Boolean):void
		{
			folderOpenIcon.visible = v;
			folderClosedIcon.visible = !v;
			setCache(v);
		}
		
		private function setCache(v:Boolean):void
		{
			if(file == null) return ;
			if(v){
				AppGetLocaleTab2Cache.getInstance().tmp_add(file.getFile(),get_AppGetLocaleTab2_tab().type);
			}else{
				AppGetLocaleTab2Cache.getInstance().tmp_remove(file.nativePath,get_AppGetLocaleTab2_tab().type);
			}
		}
		
		override public function poolChange(value:*):void
		{
			if(value == "file_up"){
				fileName = "file_up"
				file = null
			}else{
				file = value as SandyFileProxy;
				fileName = file.name;
			}
						
			super.poolChange(value);
			
			mouseChildren = true;
			mouseEnabled = false;
			
			folderOpenIcon.visible = false
			folderClosedIcon.visible = true
				
			if(file!=null&&
				AppGetLocaleTab2Cache.getInstance().check_in_tmp(file.nativePath,get_AppGetLocaleTab2_tab().type)){
				folderOpenIcon.visible = true;
				folderClosedIcon.visible = false;	
			}
			
			if(value == "file_up"){
				ti.text = "["+StringTWLUtil.space_sign_en+"] ... ";
			}else{
				ti.text = file.name;
			}
			
			if(file!=null){
				if(file.isDirectory){
					folder_sp.visible = false
				}else{
					folder_sp.visible = true
				}
			}else{
				folder_sp.visible = false;
			}
			 
			iconImg.source = getIconSource();
			iconImg.width = getIconWidth();
			iconImg.height = getIconHeight();
		}
		
		private function get_AppGetLocaleTab2_tab():AppGetLocaleTab2_tab
		{
			return AppGetLocaleTab2_tab(uiowner.uiowner.uiowner.uiowner);
		}
		
		override protected function getIconSource():String
		{
			if(fileName == "file_up"){
				return "fold2_a"; 
			}
			if(file.isDirectory){
				return "fold2_a";
			}
			return "file_a";
		}
		
		override protected function getIconWidth():int
		{
			if(fileName == "file_up"){
				return 16
			}
			if(file.isDirectory){
				return 16
			}
			return 14
		}
		
		override protected function getIconHeight():int
		{
			if(fileName == "file_up"){
				return 13;
			}
			if(file.isDirectory){
				return 13
			}
			return 16
		}
		
	}
}