package com.editor.module_pop.serverDirManager.itemRenderer
{
	import com.editor.component.controls.UIImage;
	import com.editor.component.controls.UILabel;
	import com.sandy.asComponent.itemRenderer.ASHListItemRenderer;
	import com.sandy.component.itemRenderer.SandyHBoxItemRenderer;
	
	import flash.filesystem.File;
	
	public class ServerDirManagerRightListItemRenderer extends SandyHBoxItemRenderer
	{
		public function ServerDirManagerRightListItemRenderer()
		{
			super();
			create_init();
		}
		
		private var nameTxt:UILabel;
		private var typeTxt:UILabel;
		private var sizeTxt:UILabel;
		
		private function create_init():void
		{
			this.height = 25;
			paddingLeft = 5;
			
			nameTxt = new UILabel();
			nameTxt.width = 250
			addChild(nameTxt);
			
			typeTxt = new UILabel();
			typeTxt.width = 50;
			addChild(typeTxt);
			
			sizeTxt = new UILabel();
			sizeTxt.width = 70;
			addChild(sizeTxt);
		}
		
		
		
		private var file:File;
		
		override public function poolChange(value:*):void
		{
			super.poolChange(value);
			
			file = data as File;
			
			nameTxt.text = file.name;
			if(file.isDirectory){
				typeTxt.text = "fold"
				sizeTxt.text = ""
			}else{
				typeTxt.text = file.extension;
				sizeTxt.text = int(file.size/1024)+"K"
			}
		}
		
	}
}