package com.editor.modules.pop.createProject
{
	import com.editor.component.containers.UIHBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UIForm;
	import com.editor.component.controls.UISelectFileButton;
	import com.editor.component.controls.UITextInput;
	import com.editor.model.PopupwinSign;
	import com.editor.view.popup.AppPopupWithEmptyWin;
	import com.editor.view.popup.AppPopupWithNoTitleWin;
	import com.editor.view.popup.def.AppDefault3PopupWithTitleWin;
	import com.sandy.asComponent.vo.ASComponentConst;
	import com.air.component.SandySelectFileButton;
	import com.air.component.SandyTextInputWithLabelWithSelectFile;
	import com.sandy.component.controls.SandyButton;
	import com.air.popupwin.data.AIRPopOptions;
	
	import flash.display.NativeWindowSystemChrome;
	import flash.display.NativeWindowType;
	import flash.utils.setTimeout;

	/**
	 * 新建项目
	 */ 
	public class AppCreateProjectPopupwin extends AppPopupWithEmptyWin
	{
		public function AppCreateProjectPopupwin()
		{
			super()
			create_init();
		}
		
		public var form:UIForm;
		public var nameForm:UITextInput;
		public var pathForm:UITextInput;
		public var pathButton:UISelectFileButton;
		
		private function create_init():void
		{
			form = new UIForm();
			form.verticalGap = 5;
			form.y = 50;
			form.x = 20
			form.width = 350;
			form.height = 350;
			form.leftWidth = 100
			this.addChild(form);
			
			var form_a:Array = [];
			
			nameForm = new UITextInput();
			nameForm.width = 220
			nameForm.height = 22
			nameForm.formLabel = "项目名称："
			form_a.push(nameForm);
			
			var hb1:UIHBox = new UIHBox();
			hb1.width = 250;
			hb1.height = 22;
			hb1.formLabel = "项目目录："
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
			opts.title = "新建项目"	
			return opts;
		}
		
		override protected function __init__():void
		{
			useDefaultBotButton = true
			popupSign  		= PopupwinSign.AppCreateProjectPopupwin_sign;
			isModel    		= true;		
			enabledDrag    	= true;
			super.__init__();
		}
		
		override protected function createPopWin():void
		{
			super.createPopWin();
			registerMediator(new AppCreateProjectPopwinMediator(this))
		}
				
		override public function delPopwin():void
		{
			super.delPopwin()
			removeMediator(AppCreateProjectPopwinMediator.NAME)
		}
	}
}