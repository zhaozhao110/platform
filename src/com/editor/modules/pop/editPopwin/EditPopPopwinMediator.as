package com.editor.modules.pop.editPopwin
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
	import com.editor.tool.project.create.CreatePopupwinTool;
	import com.editor.modules.cache.ProjectCache;
	import com.editor.view.popup.AppDestroyPopupwinMediator;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.popupwin.data.OpenMessageData;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.events.MouseEvent;

	public class EditPopPopwinMediator extends AppDestroyPopupwinMediator
	{
		public static const NAME:String = "EditPopPopwinMediator";
		public function EditPopPopwinMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get createWin():EditPopPopwin
		{
			return viewComponent as EditPopPopwin
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
		public function get editBtn():UIButton
		{
			return createWin.editBtn;
		}
		public function get pubBtn():UIButton
		{
			return createWin.pubBtn;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			cls_path = ProjectCache.getInstance().getUserPopSign()
			pathTi.text = cls_path;
			
			tool = new EditPopPopwinTool(this);
			tool.parser(cls_path);
			
			event_vb.addEventListener(ASEvent.CHANGE,onChange)
		}
		
		public var tool:EditPopPopwinTool;
		private var cls_path:String;
		
		private function onChange(e:ASEvent):void
		{
			var item:ClsAttri = event_vb.selectedItem as ClsAttri;
			eventTi.text = item.name ;
			infoTi.htmlText = item.info;
		}
		
		public function reactToAddBtnClick(e:MouseEvent):void
		{
			if(StringTWLUtil.isWhitespace(eventTi.text)) return ;
			
			var winName:String = StringTWLUtil.trim(eventTi.text);
			if(tool.db.haveMember(winName+"_sign")) return ;
			
			var tool2:CreatePopupwinTool = new CreatePopupwinTool();
			tool2.create(winName,StringTWLUtil.trim(infoTi.text));
			
			tool.parser(cls_path);
		}
		
		public function reactToEditBtnClick(e:MouseEvent):void
		{
			if(StringTWLUtil.isWhitespace(eventTi.text)) return ;
			
			var cls:ClsAttri = event_vb.getSelectItem() as ClsAttri;
			if(cls.name != eventTi.text){
				var m:OpenMessageData = new OpenMessageData();
				m.info = "您确定要修改"+cls.name+"名?"
				m.okFunction = changeWinName;
				m.okFunArgs = cls;
				showConfirm(m);
			}else{
				var t:String = infoTi.text;
				t = StringTWLUtil.removeNewlineChar(t);
				if(t.indexOf("/*")==-1){
					if(t.indexOf("//")==-1){
						t = "/**"+t+"*/";
					}
				}
				cls.info = t;
			}
		}
		
		private function changeWinName(cls:ClsAttri):Boolean
		{
			tool.rename(cls,eventTi.text);
			return true;
		}
		
		public function reactToPubBtnClick(e:MouseEvent):void
		{
			tool.pub();
		}
		
	}
}