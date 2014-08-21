package com.editor.module_ui.view.uiAttri.com.itemRenderer
{
	import com.editor.component.controls.UIAssetsSymbol;
	import com.editor.component.controls.UITextInput;
	import com.editor.module_ui.view.uiAttri.com.ComArray;
	import com.editor.module_ui.vo.OpenFileInUIEditorEventVO;
	import com.editor.modules.cache.ProjectCache;
	import com.editor.modules.event.AppModulesEvent;
	import com.editor.modules.pop.createClass.AppCreateClassFilePopwinVO;
	import com.sandy.asComponent.itemRenderer.ASHListItemRenderer;
	import com.sandy.asComponent.itemRenderer.ASListItemRenderer;
	import com.sandy.manager.SandyManagerBase;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.events.MouseEvent;
	import flash.filesystem.File;

	public class ComArrayItemRenderer extends ASHListItemRenderer
	{
		public function ComArrayItemRenderer()
		{
			super();
			create_init();
		}
		
		override protected function renderTextField():void{};
		
		public var cell:ComArray;
		private var ti:UITextInput;
		private var delBtn:UIAssetsSymbol;
		
		
		private function create_init():void
		{
			height = 25;
			width = 250;
			
			mouseChildren = true;
			mouseEnabled = false;
			
			ti = new UITextInput();
			ti.name = "ComArrayItemRenderer"
			ti.height = 22;
			ti.width = 170;
			ti.enterKeyDown_proxy = ti_keyDown;
			addChild(ti);
			
			delBtn = new UIAssetsSymbol();
			delBtn.source = "close2_a"
			delBtn.toolTip = "删除"
			delBtn.buttonMode = true;
			delBtn.addEventListener(MouseEvent.CLICK , onDelHandle);
			addChild(delBtn);
			
			
		}
		
		
		
		override public function poolChange(value:*):void
		{
			super.poolChange(value);
			ti.text = value.toString();
		}
		
		override public function poolDispose():void
		{
			super.poolDispose();
			ti.text = "";
		}
		
		private function onDelHandle(e:MouseEvent):void
		{
			cell.del(listIndex);
		}
		
		private function ti_keyDown():void
		{
			if(StringTWLUtil.isWhitespace(ti.text)) return ;
			cell.add(ti.text,listIndex);
		}
		
	}
}