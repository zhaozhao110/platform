package com.editor.module_ui.view.uiAttri.com
{
	import com.air.io.SelectFile;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIAssetsSymbol;
	import com.editor.component.controls.UIImage;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UITextInput;
	import com.editor.manager.StackManager;
	import com.editor.model.OpenPopwinData;
	import com.editor.model.PopupwinSign;
	import com.editor.module_ui.css.CSSShowContainerMediator;
	import com.editor.module_ui.css.CreateCSSFileItemVO;
	import com.editor.module_ui.ui.UIEditManager;
	import com.editor.module_ui.view.cssAttri.CSSEditorAttriListViewMediator;
	import com.editor.module_ui.view.uiAttri.vo.ComFileVO;
	import com.editor.module_ui.view.uiAttri.vo.IComBaseVO;
	import com.editor.module_ui.vo.OpenFileInUIEditorEventVO;
	import com.editor.modules.cache.ProjectCache;
	import com.editor.modules.event.AppModulesEvent;
	import com.editor.modules.pop.createClass.AppCreateClassFilePopwinVO;
	import com.sandy.error.SandyError;
	import com.sandy.manager.SandyManagerBase;
	import com.sandy.popupwin.data.OpenPopByAirOptions;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.desktop.Clipboard;
	import flash.desktop.ClipboardFormats;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;

	public class ComFile extends ComBase
	{
		public function ComFile()
		{
			super();
		}
		
		private var input:UITextInput;
		private var img:UIImage;
		private var vb:UIVBox;
		private var hb1:UIHBox
		private var hb2:UIHBox;
		private var ti1:UITextInput;
		private var ti2:UITextInput;
		private var ti3:UITextInput;
		private var ti4:UITextInput;
		private var preBtn:UIAssetsSymbol;
		public var addImg:UIAssetsSymbol;
		
		override protected function create_init():void
		{
			width = 260;
			height = 50
			
			vb = new UIVBox();
			vb.enabledPercentSize = true;
			addChild(vb);
				
			hb1 = new UIHBox();
			hb1.percentWidth = 100;
			hb1.height = 25;
			vb.addChild(hb1);
			
			createLeftTxt(hb1);
			
			input = new UITextInput();
			input.height = 22
			input.percentWidth = 100;
			input.enterKeyDown_proxy = enterKeyDown
			hb1.addChild(input);
			
			img = new UIImage();
			img.source = "openFold_a"
			img.width = 18;
			img.height = 18;
			hb1.addChild(img);
			img.addEventListener(MouseEvent.CLICK , onClickHandle);
			
			addImg = new UIAssetsSymbol();
			addImg.source = "add_a"
			addImg.buttonMode = true;
			addImg.toolTip = "编辑"
			addImg.addEventListener(MouseEvent.CLICK , onAddClick);
			hb1.addChild(addImg);
			
			hb2 = new UIHBox();
			hb2.percentWidth = 100;
			hb2.height = 25;
			vb.addChild(hb2);
			
			var lb3:UILabel = new UILabel();
			lb3.text = "left";
			lb3.width = 25;
			lb3.toolTip = "scaleGridLeft"
			hb2.addChild(lb3);
			
			ti3 = new UITextInput();
			ti3.width = 32;
			hb2.addChild(ti3);
			
			var lb1:UILabel = new UILabel();
			lb1.text = "top";
			lb1.width = 25;
			lb1.toolTip = "scaleGridTop"
			hb2.addChild(lb1);
			
			ti1 = new UITextInput();
			ti1.width = 32;
			hb2.addChild(ti1);
			
			var lb4:UILabel = new UILabel();
			lb4.text = "right";
			lb4.width = 30;
			lb4.toolTip = "scaleGridRight"
			hb2.addChild(lb4);
			
			ti4 = new UITextInput();
			ti4.width = 32;
			hb2.addChild(ti4);
			
			var lb2:UILabel = new UILabel();
			lb2.text = "bottom";
			lb2.width = 40;
			lb2.toolTip = "scaleGridBottom";
			hb2.addChild(lb2);
			
			ti2 = new UITextInput();
			ti2.width = 32;
			hb2.addChild(ti2);
					
			
			preBtn = new UIAssetsSymbol();
			preBtn.source = "pre_a"
			preBtn.width = 20;
			preBtn.height = 20;
			preBtn.buttonMode = true;
			preBtn.toolTip = "预览图片"
			preBtn.addEventListener(MouseEvent.CLICK , onPreClick);
			hb2.addChild(preBtn);
		}
		
		private function onPasteHandle(s:String):void
		{
			var a:Array = s.split(",");
			if(a[0] == "9rect"){
				ti3.text = int(a[1]).toString();
				ti1.text = int(a[2]).toString();
				ti4.text = int(a[3]).toString();
				ti2.text = int(a[4]).toString();
			}
		}
		
		private function onAddClick(e:MouseEvent):void
		{
			if(StringTWLUtil.isWhitespace(input.text)) return ;
			var path:String = ProjectCache.getInstance().getProjectOppositePath(input.text);
			var fl:File = new File(path);
			if(!fl.exists){
				SandyManagerBase.getInstance().showError("文件不存在");
				return ;
			}
			if(fl.extension != "as"){
				SandyManagerBase.getInstance().showError("只能编辑as文件");
				return ;
			}
			var ui_d:OpenFileInUIEditorEventVO = new OpenFileInUIEditorEventVO();
			ui_d.file = fl
			ui_d.type = AppCreateClassFilePopwinVO.file_type3
			sendAppNotification(AppModulesEvent.openFile_inUIEditor_event,ui_d)
		}
		
		private function onPreClick(e:MouseEvent):void
		{
			var path:String = ProjectCache.getInstance().getProjectOppositePath(input.text);
			var fl:File = new File(path);
			if(!fl.exists) return ;
			var open:OpenPopwinData = new OpenPopwinData();
			open.data = path
			open.addData = onPasteHandle;
			open.popupwinSign = PopupwinSign.PreImagePopWin_sign;
			var opt:OpenPopByAirOptions = new OpenPopByAirOptions();
			open.openByAirData = opt;
			SandyManagerBase.getInstance().openPopupwin(open);
		}
		
		private function checkCanPreImage():void
		{
			preBtn.visible = false;
			if(StringTWLUtil.isWhitespace(input.text)){
				preBtn.visible = false;
				return ;
			}
			var fl:File = new File(ProjectCache.getInstance().getProjectOppositePath(input.text));
			if(!fl.exists){
				preBtn.visible = false;
				return ;
			}
			if(input.text.indexOf(".png")!=-1 || input.text.indexOf(".jpg")!=-1){
				preBtn.visible = true;
				return ;
			}
		}
		
		private function onClickHandle(e:MouseEvent):void
		{
			SelectFile.select("选择文件",[],onResult)
		}
		
		private function onResult(e:Event):void
		{
			if(checkIsSkin()){
				var a:Array = CSSEditorAttriListViewMediator.currShow_cell.getAllDataList();
				if(StringTWLUtil.isWhitespace(a["embedType"])){
					SandyManagerBase.getInstance().showError("请先设置embedType属性");
					return ;
				}
			}
			var fl:File = e.target as File;
			input.text = ProjectCache.getInstance().getOppositePath(fl.nativePath);
			input.toolTip = input.text;
			checkCanPreImage();
			callUIRender();
		}
		
		private function checkIsSkin():Boolean
		{
			return CreateCSSFileItemVO.checkIsSkin(key)
		}
		
		private function enterKeyDown():void
		{
			input.toolTip = input.text;
			callUIRender();
		}
		
		override protected function reflash_init():void
		{
			super.reflash_init();
			
			if(StackManager.checkIsEditCSS()){
				hb2.visible = true
			}else{
				hb2.visible = false
			}
		}
		
		override public function setValue(obj:IComBaseVO):void
		{
			super.setValue(obj);
			if(StackManager.checkIsEditCSS()){
				hb2.visible = true
				if(css_data.paser.getValue(item.key)!=null){
					var d:ComFileVO = css_data.paser.getValue(item.key).getVO() as ComFileVO;
					if(d == null){
						resetCom()
						return ;
					}
					input.text = d.value;
					input.toolTip = d.value;
					ti1.text = d.scaleGridTop.toString();
					ti2.text = d.scaleGridBottom.toString();
					ti3.text = d.scaleGridLeft.toString();
					ti4.text = d.scaleGridRight.toString();
					checkCanPreImage()
				}
				return ;
			}
			hb2.visible = false
			if(obj!=null){
				input.text = obj.value;
				input.toolTip = obj.value;
				checkCanPreImage()
			}
		}
		
		override public function getValue():IComBaseVO
		{
			var d:ComFileVO = new ComFileVO();
			initVO(d);
			d.value = input.text;
			d.scaleGridTop = int(ti1.text);
			d.scaleGridBottom = int(ti2.text);
			d.scaleGridLeft = int(ti3.text);
			d.scaleGridRight = int(ti4.text);
			/*if(StringTWLUtil.isWhitespace(d.value)){
				return null;
			}*/
			return d;
		}
		
		override protected function resetCom():void
		{
			input.text = "";
			ti1.text = ""
			ti2.text = ""
			ti3.text = ""
			ti4.text = ""
			checkCanPreImage()
			if(key == "_itemRenderer" || key == "proxy" || key == "branch_itemRenderer" 
			 || key =="leaf_itemRenderer"){
				addImg.visible = true
			}else{
				addImg.visible = false;
			}
		}
		
	}
}