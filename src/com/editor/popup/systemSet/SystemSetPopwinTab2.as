package com.editor.popup.systemSet
{
	import com.air.io.FileUtils;
	import com.air.io.SelectFile;
	import com.air.io.WriteFile;
	import com.editor.command.action.DownToolFileCommand;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UICheckBox;
	import com.editor.component.controls.UICombobox;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UITextInput;
	import com.editor.model.AppMainModel;
	import com.editor.vo.global.AppGlobalConfig;
	import com.editor.vo.project.AppProjectItemVO;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.popupwin.data.OpenMessageData;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;

	public class SystemSetPopwinTab2 extends UIVBox
	{
		public function SystemSetPopwinTab2()
		{
			super();
			//create_init();
		}
		
		public var form:UIVBox;
		public var sdk_cb:UICombobox;
		public var sdk_addBtn:UIButton;
		public var sdk_delBtn:UIButton;
		public var sdk_editBtn:UIButton;
		public var projectCB:UICombobox;
		public var inspectorCB:UICheckBox;
		
		override public function delay_init():Boolean
		{
			form = new UIVBox();
			form.enabledPercentSize = true
			form.padding = 10;
			form.verticalGap = 5
			form.styleName = "uicanvas"
			//form.horizontalAlign = ASComponentConst.horizontalAlign_center;
			this.addChild(form);
			
			////////////////////////////////////////////////////////////////////
			var box:UIHBox = new UIHBox();
			box.styleName = "uicanvas";
			box.height = 60;
			box.horizontalGap = 5;
			box.percentWidth = 100;
			box.verticalAlignMiddle = true
			form.addChild(box);
			
			var lb:UILabel = new UILabel();
			lb.text = "sdk编辑："
			box.addChild(lb);
			
			sdk_cb = new UICombobox();
			sdk_cb.width = 150;
			sdk_cb.height = 23;
			sdk_cb.labelField = "name"
			sdk_cb.addEventListener(ASEvent.CHANGE,sdk_cb_change);
			box.addChild(sdk_cb);
			
			sdk_addBtn = new UIButton();
			sdk_addBtn.label = "添加"
			sdk_addBtn.toolTip = "选择sdk目录，选择的目录名将作为sdk的名字"
			box.addChild(sdk_addBtn);
			sdk_addBtn.addEventListener(MouseEvent.CLICK , sdk_addBtn_click);
			
			sdk_editBtn = new UIButton();
			sdk_editBtn.label = "编辑"
			sdk_editBtn.toolTip = "选择一个sdk，可以修改sdk的目录"
			box.addChild(sdk_editBtn);
			sdk_editBtn.addEventListener(MouseEvent.CLICK , sdk_editBtn_click);
			
			sdk_delBtn = new UIButton();
			sdk_delBtn.label = "删除"
			box.addChild(sdk_delBtn);
			sdk_delBtn.addEventListener(MouseEvent.CLICK , sdk_delBtn_click);
			
			
			///////////////////////////////////////////////////////
			
			box = new UIHBox();
			box.styleName = "uicanvas";
			box.height = 60;
			box.horizontalGap = 5;
			box.percentWidth = 100;
			box.verticalAlignMiddle = true
			form.addChild(box);
			
			lb = new UILabel();
			lb.text = "切换项目:"
			box.addChild(lb);
			
			projectCB = new UICombobox();
			projectCB.width = 150
			projectCB.height = 22;
			projectCB.x = 470;
			projectCB.y = 45;
			projectCB.dropDownWidth = 140
			projectCB.labelField = "label";
			box.addChild(projectCB);
						
			//projectCB.addEventListener(ASEvent.CHANGE,onProjectChange)
			
			///////////////////////////////////////////////////////
			//tInspectorPreloader.swf
			
			box = new UIHBox();
			box.styleName = "uicanvas";
			box.height = 60;
			box.horizontalGap = 5;
			box.percentWidth = 100;
			box.verticalAlignMiddle = true
			form.addChild(box);
			
			inspectorCB = new UICheckBox();
			inspectorCB.label = "启动全局inspector，打开任何swf,都会出现该工具";
			inspectorCB.addEventListener(ASEvent.CHANGE,inspectorCBChange);
			box.addChild(inspectorCB);
			
			reflash();
			
			return true;
		}
		
		private function reflash():void
		{
			sdk_ls = AppMainModel.getInstance().applicationStorageFile.sdkFold_ls;
			sdk_cb.dataProvider = getSdk_cb_data();
			sdk_cb.selectedIndex = 0;
			
			projectCB.dataProvider = AppGlobalConfig.instance.projects.list;
			projectCB.selectedIndex = int(iManager.iSharedObject.find("","loginProject"))
				
			inspectorCB.selected = iManager.iSharedObject.find("","inspector")==1?true:false;
		}
		
		////////////////////////////////////////////////////////////////////
		
		private function inspectorCBChange(e:ASEvent=null):void
		{
			iManager.iSharedObject.put("","inspector",inspectorCB.selected==true?1:0);
			
			var f:File = FileUtils.getMMCFG();
			if(inspectorCB.selected){
				if(!f.exists){
					var w:WriteFile = new WriteFile();
					w.write(f,"");
				}
				var str:String = "PreloadSWF="
				str += DownToolFileCommand.saveFile.nativePath+File.separator+"tInspectorPreloader.swf";
				w = new WriteFile();
				w.write(f,str);
			}else{
				if(f.exists){
					f.deleteFile();
				}
			}
		}
		
		////////////////////////////////////////////////////////////////////
		private var sdk_ls:Array = [];
		
		private function sdk_cb_change(e:ASEvent):void
		{
			if(sdk_cb.selectedItem!=null){
				sdk_cb.toolTip = sdk_cb.selectedItem.toolTip; 	
			}
		}
		
		private function sdk_addBtn_click(e:MouseEvent):void
		{
			SelectFile.selectDirectory("选择sdk的目录",sdk_addBtn_click_result);
		}
		
		private function sdk_addBtn_click_result(e:Event):void
		{
			var fl:File = e.target as File;
			sdk_ls.push(fl.nativePath);
			AppMainModel.getInstance().applicationStorageFile.putKey_sdkFold(sdk_ls.join("|"));
			sdk_cb.dataProvider = getSdk_cb_data();
			sdk_cb.selectLast(); 
			sdk_cb.toolTip = fl.nativePath;
		}
		
		private function getSdk_cb_data():Array
		{
			var out:Array = [];
			for(var i:int=0;i<sdk_ls.length;i++){
				var fl:File = new File(sdk_ls[i]);
				if(fl.exists){
					out.push({name:fl.name,path:fl.nativePath,toolTip:fl.nativePath})
				}
			}
			return out;
		}
		
		private function sdk_editBtn_click(e:MouseEvent):void
		{
			if(sdk_cb.selectedItem == null) return ;
			SelectFile.selectDirectory("选择sdk的目录",sdk_editBtn_click_result);
		}
		
		private function sdk_editBtn_click_result(e:Event):void
		{
			var fl:File = e.target as File;
			var obj:Object = sdk_cb.selectedItem;
			var selectInd:int;
			var path:String = obj.path;
			for(var i:int=0;i<sdk_ls.length;i++){
				if(sdk_ls[i] == path){
					sdk_ls[i] = fl.nativePath;
					selectInd = i
				}
			}
			AppMainModel.getInstance().applicationStorageFile.putKey_sdkFold(sdk_ls.join("|"));
			sdk_cb.dataProvider = getSdk_cb_data();
			sdk_cb.selectedIndex = selectInd;
		}
		
		private function sdk_delBtn_click(e:MouseEvent):void
		{
			if(sdk_cb.selectedItem == null) return ;
			var obj:Object = sdk_cb.selectedItem;
			
			var m:OpenMessageData = new OpenMessageData();
			m.info = "确定要删除sdk:"+obj.name+"?"
			m.okFunction = sdk_delBtn_click_confirm;
			iManager.iPopupwin.showConfirm(m);
		}
			
		private function sdk_delBtn_click_confirm():Boolean
		{
			var obj:Object = sdk_cb.selectedItem;
			var selectInd:int;
			var path:String = obj.path;
			for(var i:int=0;i<sdk_ls.length;i++){
				if(sdk_ls[i] == path){
					sdk_ls.splice(i,1);
				}
			}
			AppMainModel.getInstance().applicationStorageFile.putKey_sdkFold(sdk_ls.join("|"));
			sdk_cb.dataProvider = getSdk_cb_data();
			sdk_cb.selectedIndex = selectInd;
			if(sdk_cb.dataProvider.length == 0){
				sdk_cb.toolTip = "";
			}
			return true
		}
		
		public function okButtonClick():void
		{
			if(form == null) return ;
			
			iManager.iSharedObject.put("","loginProject",projectCB.selectedIndex);
			AppMainModel.getInstance().selectProject = projectCB.selectedItem as AppProjectItemVO;
			inspectorCBChange();
		}
	}
}