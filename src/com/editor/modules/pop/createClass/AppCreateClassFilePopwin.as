package com.editor.modules.pop.createClass
{
	import com.air.popupwin.data.AIRPopOptions;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UICombobox;
	import com.editor.component.controls.UIForm;
	import com.editor.component.controls.UITextInput;
	import com.editor.component.expand.UIComboBoxWithLabel;
	import com.editor.model.PopupwinSign;
	import com.editor.view.popup.AppPopupWithEmptyWin;
	
	import flash.display.NativeWindowType;
	import flash.utils.setTimeout;

	public class AppCreateClassFilePopwin extends AppPopupWithEmptyWin
	{
		public function AppCreateClassFilePopwin()
		{
			super()
			create_init();
		}
		
		public var form:UIForm;
		public var nameForm:UITextInput;
		public var pathForm:UITextInput;
		public var pathButton:UIButton;
		public var cb:UICombobox;
		
		private function create_init():void
		{
			form = new UIForm();
			form.verticalGap = 5;
			form.y = 50;
			form.x = 10
			form.width = 350;
			form.height = 350;
			form.leftWidth = 50
			this.addChild(form);
			
			var form_a:Array = [];
			
			nameForm = new UITextInput();
			nameForm.width = 300 ;
			nameForm.height = 22 ;
			nameForm.formLabel = "文件名："
			form_a.push(nameForm);
			
			var hb1:UIHBox = new UIHBox();
			hb1.width = 300;
			hb1.height = 22;
			hb1.formLabel = "包路径："
			form_a.push(hb1);
			
			pathForm = new UITextInput();
			pathForm.width = 250
			pathForm.height = 22;
			pathForm.editable = false;
			hb1.addChild(pathForm);
			
			pathButton = new UIButton();
			pathButton.label = "浏览";
			hb1.addChild(pathButton);
			
			cb = new UICombobox();
			cb.formLabel = "模版：";
			cb.width = 250;
			cb.height = 22;
			cb.dropDownHeight = 150;
			form_a.push(cb);
						
			form.areaComponent = form_a;
			
			initComplete()
		}
		
		override protected function getAirOpts():AIRPopOptions
		{
			var opts:AIRPopOptions = new AIRPopOptions();
			opts.type = NativeWindowType.UTILITY;
			opts.width = 400;
			opts.height = 350;
			opts.title = "新建文件"	
			return opts;
		}
		
		override protected function __init__():void
		{
			useDefaultBotButton = true
			popupSign  		= PopupwinSign.AppCreateClassFilePopwin_sign;
			isModel    		= true;		
			enabledDrag    	= true;
			super.__init__();
		}
		
		override protected function createPopWin():void
		{
			super.createPopWin();
			registerMediator(new AppCreateClassFilePopwinMediator(this))
		}
		
		override public function delPopwin():void
		{
			super.delPopwin()
			removeMediator(AppCreateClassFilePopwinMediator.NAME)
		}
	}
}