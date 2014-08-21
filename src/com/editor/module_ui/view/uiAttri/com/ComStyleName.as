package com.editor.module_ui.view.uiAttri.com
{
	import com.editor.component.controls.UIAssetsSymbol;
	import com.editor.module_ui.ui.CreateUIFile;
	import com.editor.module_ui.view.projectDirectory.ProjectDirectoryMenu;
	import com.editor.modules.cache.ProjectAllUserCache;
	import com.editor.modules.cache.ProjectCache;
	import com.editor.modules.event.AppModulesEvent;
	import com.sandy.manager.SandyManagerBase;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.events.MouseEvent;
	import flash.filesystem.File;

	public class ComStyleName extends ComAutoCompleteComboBox
	{
		public function ComStyleName()
		{
			super();
		}
		
		private var resetStyleBtn:UIAssetsSymbol;
		private var addBtn:UIAssetsSymbol;
		
		override protected function create_init():void
		{
			super.create_init();
			
			resetStyleBtn = new UIAssetsSymbol();
			resetStyleBtn.source = "reflash_a"
			resetStyleBtn.width = 16;
			resetStyleBtn.height = 16;
			resetStyleBtn.toolTip = "重新加载样式"
			resetStyleBtn.buttonMode = true;
			resetStyleBtn.addEventListener(MouseEvent.CLICK , onClick);
			addChild(resetStyleBtn);
			
			addBtn = new UIAssetsSymbol();
			addBtn.source = "add_a"
			addBtn.buttonMode = true;
			addBtn.toolTip = "编辑CSS"
			addBtn.addEventListener(MouseEvent.CLICK , onAdd);
			addChild(addBtn);
		}
		
		private function onClick(e:MouseEvent):void
		{
			var fl:File = ProjectAllUserCache.getInstance().findFileByNameFromCSSXML(input.text);
			if(fl!=null){
				CreateUIFile.parserStyleName(fl,true);	
			}
		}
		
		private function onAdd(e:MouseEvent):void
		{
			if(StringTWLUtil.isWhitespace(input.text)) return ;
			var fl:File = ProjectAllUserCache.getInstance().findASFileByNameFromCSSXML(input.text);
			if(fl!=null&&fl.exists){
				sendAppNotification(AppModulesEvent.openFile_inCSSEditor_event,fl)
			}else{
				SandyManagerBase.getInstance().showError("没有找到css:"+input.text);
			}
		}
		
		
		
	}
}