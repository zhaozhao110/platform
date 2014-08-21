package com.editor.modules.pop.importSource
{
	import com.editor.component.containers.UIHBox;
	import com.editor.component.controls.UIForm;
	import com.editor.component.controls.UISelectFileButton;
	import com.editor.component.controls.UITextInput;
	import com.editor.model.PopupwinSign;
	import com.editor.view.popup.AppPopupWithEmptyWin;
	import com.sandy.asComponent.controls.ASTextField;
	import com.sandy.asComponent.itemRenderer.ASHListItemRenderer;
	import com.air.popupwin.data.AIRPopOptions;
	
	import flash.display.NativeWindowType;

	//导入资源，项目
	public class AppImportSourcePopupwin extends AppPopupWithEmptyWin
	{
		public function AppImportSourcePopupwin()
		{
			super()
			create_init();
		}
		
		public var form:UIForm;
		public var pathForm:UITextInput;
		public var pathButton:UISelectFileButton;
		
		
		private function create_init():void
		{
			form = new UIForm();
			form.verticalGap = 5;
			form.y = 50;
			form.x = 20
			form.width = 350;
			form.height = 200;
			form.leftWidth = 100
			this.addChild(form);
			
			var form_a:Array = [];
			
			var hb1:UIHBox = new UIHBox();
			hb1.width = 250;
			hb1.height = 22;
			hb1.formLabel = "导入项目目录：";
			form_a.push(hb1);
			
			pathForm = new UITextInput();
			pathForm.width = 150
			pathForm.height = 22;
			hb1.addChild(pathForm);
			
			pathButton = new UISelectFileButton();
			pathButton.openDirectory = true
			pathButton.label = "选择目录"
			hb1.addChild(pathButton);
			
			form.areaComponent = form_a;
			
			
		}
		
		
		override protected function getAirOpts():AIRPopOptions
		{
			var opts:AIRPopOptions = new AIRPopOptions();
			opts.type = NativeWindowType.UTILITY;
			opts.width = 400;
			opts.height = 250;
			opts.title = "导入项目"	
			return opts;
		}
		
		override protected function __init__():void
		{
			useDefaultBotButton = true
			popupSign  		= PopupwinSign.AppImportSourcePopupwin_sign;
			isModel    		= true;	
			enabledDrag    	= false;
			super.__init__();
		}
		
		override protected function createPopWin():void
		{
			super.createPopWin();
			registerMediator(new AppImportSourcePopupwinMediator(this))
		}
		
		override public function delPopwin():void
		{
			super.delPopwin()
			removeMediator(AppImportSourcePopupwinMediator.NAME)
		}
		
	}
}