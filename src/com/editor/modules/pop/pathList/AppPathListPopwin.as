package com.editor.modules.pop.pathList
{
	import com.air.popupwin.data.AIRPopOptions;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UITextInput;
	import com.editor.component.controls.UIVlist;
	import com.editor.model.PopupwinSign;
	import com.editor.view.popup.AppPopupWithEmptyWin;
	import com.sandy.asComponent.vo.ASComponentConst;
	
	import flash.display.NativeWindowType;
	import flash.utils.setTimeout;

	public class AppPathListPopwin extends AppPopupWithEmptyWin
	{
		public function AppPathListPopwin()
		{
			super()
			create_init();
		}
		
		public var pathTI:UITextInput;
		public var file_tree:UIVlist;
		public var lb:UILabel;
		
		private function create_init():void
		{
			var form:UIVBox = new UIVBox();
			//form.background_red = true
			form.verticalGap = 10;
			form.y = 20;
			form.x = 20
			form.width = 350;
			form.height = 500;
			this.addChild(form);
			
			lb = new UILabel();
			lb.text = "选择包路径:" ;
			form.addChild(lb);
			
			pathTI = new UITextInput();
			pathTI.width = 350
			pathTI.height = 22;
			pathTI.editable = true;
			form.addChild(pathTI);
			
			file_tree = new UIVlist();
			file_tree.styleName = "list"
			file_tree.enabeldSelect = true;
			file_tree.borderStyle = ASComponentConst.borderStyle_solid;
			file_tree.borderColor = 0x808080;
			file_tree.width = 350;
			file_tree.height = 320
			file_tree.y = 2;
			file_tree.padding = 2;
			file_tree.x = 2;
			file_tree.verticalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			file_tree.horizontalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			form.addChild(file_tree);
			
		}
		
		override protected function getAirOpts():AIRPopOptions
		{
			var opts:AIRPopOptions = new AIRPopOptions();
			opts.type = NativeWindowType.UTILITY;
			opts.width = 400;
			opts.height = 500;
			opts.title = "选择包"	
			return opts;
		}
		
		override protected function __init__():void
		{
			useDefaultBotButton = true
			popupSign  		= PopupwinSign.AppPathListPopwin_sign
			isModel    		= true;		
			enabledDrag    	= true;
			super.__init__();
		}
		
		override protected function createPopWin():void
		{
			super.createPopWin();
			registerMediator(new AppPathListPopwinMediator(this))
		}
		
		override public function delPopwin():void
		{
			super.delPopwin()
			removeMediator(AppPathListPopwinMediator.NAME)
		}
	}
}