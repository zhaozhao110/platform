package com.editor.project_pop.serverCode
{
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIAssetsSymbol;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UITabBar;
	import com.editor.component.controls.UITextArea;
	import com.editor.component.controls.UITextInput;
	import com.editor.model.OpenPopwinData;
	import com.editor.model.PopupwinSign;
	import com.editor.modules.cache.ProjectCache;
	import com.editor.modules.pop.pathList.OpenPathListPopWinVO;
	import com.editor.view.popup.AppDestroyPopupwinMediator;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.manager.SharedObjectManager;
	import com.sandy.math.ArrayCollection;
	import com.sandy.popupwin.data.OpenPopByAirOptions;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.events.MouseEvent;
	import flash.filesystem.File;

	public class CreateServerCodePopwinMediator extends AppDestroyPopupwinMediator
	{
		public static const NAME:String = "CreateServerCodePopwinMediator"
		public function CreateServerCodePopwinMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get createWin():CreateServerCodePopwin
		{
			return viewComponent as CreateServerCodePopwin
		}
		public function get ti():UITextInput
		{
			return createWin.ti;
		}
		public function get ti2():UITextInput
		{
			return createWin.ti2;
		}
		public function get ti4():UITextArea
		{
			return createWin.ti4;
		}
		public function get ti6():UITextInput
		{
			return createWin.ti6;
		}
		public function get text():UITextArea
		{
			return createWin.text;
		}
		public function get parserBtn():UIButton
		{
			return createWin.parserBtn;
		}
		public function get pubBtn():UIButton
		{
			return createWin.pubBtn;
		}
		public function get dg():UIVBox
		{
			return createWin.dg;
		}
		public function get ti5():UITextInput
		{
			return createWin.ti5;
		}
		public function get addBtn1():UIAssetsSymbol
		{
			return createWin.addBtn1;
		}
		public function get addBtn2():UIAssetsSymbol
		{
			return createWin.addBtn2;
		}
		public function get addBtn3():UIAssetsSymbol
		{
			return createWin.addBtn3;
		}
		public function get addBtn4():UIAssetsSymbol
		{
			return createWin.addBtn4;
		}
		public function get delBtn():UIAssetsSymbol
		{
			return createWin.delBtn;
		}
		public function get textCan():UIVBox
		{
			return createWin.textCan;
		}
		public function get pathTi():UITextInput
		{
			return createWin.pathTi;
		}
		public function get selectBtn():UIButton
		{
			return createWin.selectBtn;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			new CreateServerCodeTool();
			
			dg.labelField = "name";
			dg.addEventListener(ASEvent.CHANGE,onDGChange)
				
			ti5.enterKeyDown_proxy = onKeyDown;
			
			var d:CreateServerCodeVO = (getOpenDataProxy() as OpenPopwinData).data as CreateServerCodeVO;
			if(d!=null){
				if(!StringTWLUtil.isWhitespace(d.funName)){
					ti6.text = d.funName;
				}
				if(!StringTWLUtil.isWhitespace(d.info)){
					ti2.text = d.info;
				}
			}
			
			/*var pro:String = iSharedObject.find("","CreateServerCodePopwin");
			if(StringTWLUtil.isWhitespace(pro)){
				ti.text = "";
			}else{
				ti.text = pro;
			}*/
			ti.text = "App"
			
			CreateServerCodeTool.instance.dispose();
		}
		
		private function onKeyDown():void
		{
			if(dg.selectedItem == null) return ;
			CreateServerCodeVO(dg.selectedItem).parser(ti5.text);
			onChange();
		}
		
		private function onDGChange(e:ASEvent=null):void
		{
			if(dg.selectedItem == null) return ;
			ti5.text = CreateServerCodeVO(dg.selectedItem).cont;
		}
		
		private function onChange(e:ASEvent=null):void
		{
			var pre:int = dg.selectedIndex;
			dg.dataProvider = getArray().source;
			dg.selectedIndex = pre;
		}
		
		public function reactToParserBtnClick(e:MouseEvent=null):void
		{
			CreateServerCodeTool.instance.parserRec(ti4.text);
			onChange();
		}
		
		public function reactToPubBtnClick(e:MouseEvent):void
		{
			if(StringTWLUtil.isWhitespace(ti.text)) return ;
			if(StringTWLUtil.isWhitespace(ti2.text)) return ;
			if(StringTWLUtil.isWhitespace(ti4.text)) return ;
			if(StringTWLUtil.isWhitespace(ti6.text)) return ;
			
			iSharedObject.put("","CreateServerCodePopwin",ti.text);
				
			textCan.visible = true;
			text.text = CreateServerCodeTool.instance.createAS(this);
		}
		
		private function getArray():ArrayCollection
		{
			return CreateServerCodeTool.instance.rec_ls;
		}
		
		//在选中行之前插入新行
		public function reactToAddBtn1Click(e:MouseEvent):void
		{
			var ind:int = dg.selectedIndex;
			var item:CreateServerCodeVO = new CreateServerCodeVO();
			getArray().addItemAt(item,ind);
			onChange();
			dg.selectedIndex = ind+1;
			onDGChange();
		}
		
		public function reactToAddBtn2Click(e:MouseEvent):void
		{
			var ind:int = dg.selectedIndex;
			var item:CreateServerCodeVO = new CreateServerCodeVO();
			getArray().addItemAt(item,ind+1);
			onChange();
			dg.selectedIndex = ind+1;
			onDGChange();
		}
		
		public function reactToAddBtn3Click(e:MouseEvent):void
		{
			var ind:int = dg.selectedIndex;
			var item:CreateServerCodeVO = new CreateServerCodeVO();
			item.while_b = true;
			getArray().addItemAt(item,ind);
			onChange();
			dg.selectedIndex = ind+1;
			onDGChange();
		}
		
		public function reactToAddBtn4Click(e:MouseEvent):void
		{
			var ind:int = dg.selectedIndex;
			var item:CreateServerCodeVO = new CreateServerCodeVO();
			item.while_a = true;
			getArray().addItemAt(item,ind+1);
			onChange();
			dg.selectedIndex = ind+1;
			onDGChange();
		}
		
		public function reactToDelBtnClick(e:MouseEvent):void
		{
			getArray().removeItemAt(dg.selectedIndex);
			onChange();
		}
		
		public function reactToSelectBtnClick(e:MouseEvent):void
		{
			var win:OpenPathListPopWinVO = new OpenPathListPopWinVO();
			win.call_f = getFileURL;
			win.isDirectory = false;
			win.pathFile = new File(ProjectCache.getInstance().getUserSocketCodePath());
			var openData:OpenPopwinData = new OpenPopwinData();
			openData.popupwinSign = PopupwinSign.AppPathListPopwin_sign;
			openData.data = win;
			var opt:OpenPopByAirOptions = new OpenPopByAirOptions();
			openData.openByAirData = opt;
			openPopupwin(openData);
		}
		
		private function getFileURL(fl:File):void
		{
			var saveFile:File = fl;
			pathTi.text = ProjectCache.getInstance().getOppositePath(fl.nativePath);
			if(CreateServerCodeTool.instance.copyCode(saveFile,text.text)){
				showMessage("复制成功");
			}else{
				showMessage("复制失败");
			}
		}
		
	}
}