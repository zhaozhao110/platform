package com.editor.modules.pop.editLocale
{
	import com.asparser.ClsAttri;
	import com.asparser.ClsDB;
	import com.asparser.Field;
	import com.asparser.Parser;
	import com.asparser.TypeDB;
	import com.asparser.TypeDBCache;
	import com.air.io.ReadFile;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UIText;
	import com.editor.component.controls.UITextArea;
	import com.editor.component.controls.UITextInput;
	import com.editor.component.controls.UIVlist;
	import com.editor.modules.cache.ProjectCache;
	import com.editor.modules.event.AppModulesEvent;
	import com.editor.view.popup.AppDestroyPopupwinMediator;
	import com.editor.vo.LocaleData;
	import com.editor.vo.OpenFileData;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.utils.ColorUtils;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	
	public class EditLocalePopwinMediator extends AppDestroyPopupwinMediator
	{
		public static const NAME:String = "EditLocalePopwinMediator";
		public function EditLocalePopwinMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get createWin():EditLocalePopwin
		{
			return viewComponent as EditLocalePopwin
		}
		public function get pathTi():UITextInput
		{
			return createWin.pathTi;
		}
		public function get eventTi():UITextInput
		{
			return createWin.eventTi;
		}
		public function get event_vb():UIVlist
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
		public function get infoLB():UILabel
		{
			return createWin.infoLB;
		}
		public function get textCan():UIVBox
		{
			return createWin.textCan;
		}
		public function get lb3():UIText
		{
			return createWin.lb3;
		}
		public function get cls_vb():UIVBox
		{
			return createWin.cls_vb;
		}
		
		
		override public function onRegister():void
		{
			super.onRegister();
			
			cls_path = ProjectCache.getInstance().getUserLocale()
			pathTi.text = cls_path;
			
			tool = new EditLocaleTool(this);
			tool.parser(cls_path);
			
			reflashData();
			
			event_vb.addEventListener(ASEvent.CHANGE,onChange);
			cls_vb.addEventListener(ASEvent.CHANGE,onClsVBChange);
		}
		
		public var tool:EditLocaleTool;
		private var cls_path:String;
		
		public function reflashData():void
		{
			infoLB.text = tool.info;
			event_vb.dataProvider = tool.locale_map.source
		}
		
		private function onChange(e:ASEvent):void
		{
			var item:LocaleData = event_vb.selectedItem as LocaleData;
			eventTi.text = item.key;
			infoTi.htmlText = item.value
		}
		
		public function reactToAddBtnClick(e:MouseEvent):void
		{
			if(StringTWLUtil.isWhitespace(eventTi.text)) return ;
			tool.add(eventTi.text,infoTi.text);
		}
		
		public function reactToPubBtnClick(e:MouseEvent):void
		{
			tool.pub();
		}
		
		public function reactToEditBtnClick(e:MouseEvent):void
		{
			if(StringTWLUtil.isWhitespace(eventTi.text)) return ;
			tool.change(eventTi.text,infoTi.text);
		}
		
		public function showBindClass(d:LocaleData):void
		{
			textCan.visible = true;
			lb3.htmlText = "查看该locale所被使用的类列表:(双击列表可直接打开类)<br>"+ColorUtils.addColorTool(d.toString(),ColorUtils.red);
			cls_vb.dataProvider = TypeDBCache.getLocale(d.key);
		}
		
		private function onClsVBChange(e:ASEvent):void
		{
			if(e.isDoubleClick){
				var d:Field = e.addData as Field;
				var fl:File = new File(d.filePath); 
				if(fl.exists&&!fl.isDirectory){
					var dd:OpenFileData = new OpenFileData();
					dd.file = fl;
					dd.rowIndex = d.index;
					sendAppNotification(AppModulesEvent.openEditFile_event,dd);
				}
			}
		}
		
		
	}
}