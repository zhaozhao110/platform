package com.editor.modules.pop.editEvent
{
	import com.asparser.ClsAttri;
	import com.asparser.ClsDB;
	import com.asparser.Parser;
	import com.asparser.TypeDB;
	import com.air.io.ReadFile;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UITextArea;
	import com.editor.component.controls.UITextInput;
	import com.editor.modules.cache.ProjectCache;
	import com.editor.view.popup.AppDestroyPopupwinMediator;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.events.MouseEvent;

	public class AppEditEventPopWinMediator extends AppDestroyPopupwinMediator
	{
		public static const NAME:String = "AppEditEventPopWinMediator";
		public function AppEditEventPopWinMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get createWin():AppEditEventPopWin
		{
			return viewComponent as AppEditEventPopWin
		}
		public function get pathTi():UITextInput
		{
			return createWin.pathTi;
		}
		public function get eventTi():UITextInput
		{
			return createWin.eventTi;
		}
		public function get event_vb():UIVBox
		{
			return createWin.event_vb;
		}
		public function get addBtn():UIButton
		{
			return createWin.addBtn;
		}
		public function get infoTi():UITextArea
		{
			return createWin.infoTi;
		}
		public function get pubBtn():UIButton
		{
			return createWin.pubBtn;
		}
		public function get editBtn():UIButton
		{
			return createWin.editBtn;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			cls_path = ProjectCache.getInstance().getUserEventPath();
			pathTi.text = cls_path;
			
			tool = new ParserAppEventTool(this);
			tool.parser(cls_path);
			
			event_vb.addEventListener(ASEvent.CHANGE,onChange);
		}
		
		public var tool:ParserAppEventTool;
		private var cls_path:String;
		
		private function onChange(e:ASEvent):void
		{
			var item:ClsAttri = event_vb.selectedItem as ClsAttri;
			eventTi.text = item.name;
			infoTi.htmlText = item.info;
		}
		
		public function reactToAddBtnClick(e:MouseEvent):void
		{
			if(StringTWLUtil.isWhitespace(eventTi.text)) return ;
			var t:String = infoTi.text;
			t = StringTWLUtil.removeNewlineChar(t);
			tool.add(eventTi.text,t);
		}
		
		public function reactToPubBtnClick(e:MouseEvent):void
		{
			tool.pub();
		}
		
		public function reactToEditBtnClick(e:MouseEvent):void
		{
			if(StringTWLUtil.isWhitespace(eventTi.text)) return ;
			var t:String = infoTi.text;
			t = StringTWLUtil.removeNewlineChar(t);
			tool.change(eventTi.text,t);
		}
		
		
	}
}