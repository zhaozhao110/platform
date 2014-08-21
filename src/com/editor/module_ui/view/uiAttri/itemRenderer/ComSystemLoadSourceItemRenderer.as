package com.editor.module_ui.view.uiAttri.itemRenderer
{
	import com.editor.component.controls.UIAssetsSymbol;
	import com.editor.component.controls.UILabel;
	import com.sandy.asComponent.controls.loader.ASLoader;
	import com.sandy.asComponent.itemRenderer.ASHListItemRenderer;
	
	import flash.events.MouseEvent;
	import flash.filesystem.File;

	public class ComSystemLoadSourceItemRenderer extends ASHListItemRenderer
	{
		public function ComSystemLoadSourceItemRenderer()
		{
			super();
			create_init();
		}
		
		override protected function renderTextField():void{};
		
		private var txt:UILabel;
		private var addBtn:UIAssetsSymbol;
		
		private function create_init():void
		{
			mouseChildren = true;
			mouseEnabled = true;
			
			txt = new UILabel();
			txt.width = 200;
			addChild(txt);
			
			addBtn = new UIAssetsSymbol();
			addBtn.source = "add_a"
			addBtn.buttonMode = true;
			addBtn.toolTip = "重新导入"
			addBtn.addEventListener(MouseEvent.CLICK , onAdd);
			addChild(addBtn);
		}
		
		private function onAdd(e:MouseEvent):void
		{
			var fl:File = new File(item.path);
			if(fl.exists){
				var ld:ASLoader = new ASLoader();
				//ld.complete_fun = loadComplete
				ld.complete_args = fl;
				ld.load(fl.nativePath,false,true);
			}
		}
		
		private var item:Object;
		
		override public function poolChange(value:*):void
		{
			super.poolChange(value);
			item = value;
			txt.text = item.sign;
			txt.toolTip = item.path;
		}
		
		
	}
}