package com.editor.modules.pop.rename
{
	import com.air.popupwin.data.AIRPopOptions;
	import com.editor.component.controls.UIForm;
	import com.editor.component.controls.UITextInput;
	import com.editor.model.PopupwinSign;
	import com.editor.view.popup.AppPopupWithEmptyWin;
	
	import flash.display.NativeWindowType;

	public class AppRenameFilePopwin extends AppPopupWithEmptyWin
	{
		public function AppRenameFilePopwin()
		{
			super()
			create_init();
		}
		
		public var form:UIForm;
		public var nameForm:UITextInput;
		public var pathForm:UITextInput;
		
		
		private function create_init():void
		{
			form = new UIForm();
			form.verticalGap = 5;
			form.y = 50;
			form.x = 20
			form.width = 350;
			form.height = 200;
			form.leftWidth = 50
			this.addChild(form);
			
			var form_a:Array = [];
			
			pathForm = new UITextInput();
			pathForm.width = 300
			pathForm.height = 22
			pathForm.formLabel = "文件："
			form_a.push(pathForm);
			
			nameForm = new UITextInput();
			nameForm.width = 300
			nameForm.height = 22
			nameForm.formLabel = "新文件名："
			form_a.push(nameForm);
			
			form.areaComponent = form_a;
		}
		
		override protected function getAirOpts():AIRPopOptions
		{
			var opts:AIRPopOptions = new AIRPopOptions();
			opts.type = NativeWindowType.UTILITY;
			opts.width = 400;
			opts.height = 250;
			opts.title = "重命名文件"	
			return opts;
		}
		
		override protected function __init__():void
		{
			useDefaultBotButton = true
			popupSign  		= PopupwinSign.AppRenameFilePopwin_sign
			isModel    		= true;		
			enabledDrag    	= true;
			super.__init__();
		}
		
		override protected function createPopWin():void
		{
			super.createPopWin();
			registerMediator(new AppRenameFilePopwinMediator(this))
		}
		
		override public function delPopwin():void
		{
			super.delPopwin()
			removeMediator(AppRenameFilePopwinMediator.NAME)
		}
	}
}