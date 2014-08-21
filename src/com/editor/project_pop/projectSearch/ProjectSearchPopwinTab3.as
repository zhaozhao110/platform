package com.editor.project_pop.projectSearch
{
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UITextInput;
	import com.editor.component.controls.UIVlist;
	import com.editor.modules.cache.ProjectCache;
	import com.editor.modules.event.AppModulesEvent;
	import com.editor.vo.OpenFileData;
	import com.sandy.asComponent.controls.data.ASTreeDataProvider;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.asComponent.vo.ASComponentConst;
	import com.sandy.asComponent.vo.ASTreeData;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.filesystem.File;
	
	public class ProjectSearchPopwinTab3 extends UIVBox
	{
		public function ProjectSearchPopwinTab3()
		{
			super();
			create_init();
		}
		
		public var win:ProjectSearchPopwin;
		
		public var pathTI:UITextInput;
		public var file_tree:UIVlist;
		public var lb:UILabel;
		
		private function create_init():void
		{
			styleName = "uicanvas"
			verticalGap = 0;
			padding = 5;
			enabledPercentSize = true
			
			pathTI = new UITextInput();
			pathTI.width = 350
			pathTI.height = 22;
			pathTI.editable = true;
			addChild(pathTI);
			
			file_tree = new UIVlist();
			file_tree.styleName = "list"
			file_tree.enabeldSelect = true;
			file_tree.borderStyle = ASComponentConst.borderStyle_solid;
			file_tree.borderColor = 0x808080;
			file_tree.width = 350;
			file_tree.height = 320
			file_tree.y = 2;
			file_tree.padding = 2;
			file_tree.doubleClickEnabled = true;
			file_tree.x = 2;
			file_tree.verticalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			file_tree.horizontalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			addChild(file_tree);
			
			file_tree.doubleClickEnabled = true;
			file_tree.addEventListener(ASEvent.CHANGE,fileTreeChangeHandle);
			
			pathTI.addEventListener(ASEvent.CHANGE,filter);
		}
		 
		private function filter(e:ASEvent):void
		{
			if(StringTWLUtil.isWhitespace(pathTI.text)) return ;
			var dp:ASTreeDataProvider = ProjectCache.getInstance().cache;
			var a:Array = dp.all_ls.source;
			var b:Array = [];
			var n:int=a.length;
			for(var i:int=0;i<n;i++){
				var d:ASTreeData = a[i] as ASTreeData;
				if(StringTWLUtil.beginsWith(d.file.name,pathTI.text)){
					b.push(d);
				}
			}
			
			file_tree.dataProvider = b;
		}
		
		private function fileTreeChangeHandle(e:ASEvent):void
		{
			var file:File = ASTreeData(e.addData as Object).file;
			
			if(e.isDoubleClick){
				if(!file.isDirectory){
					var dd:OpenFileData = new OpenFileData();
					dd.file = file
					sendAppNotification(AppModulesEvent.openEditFile_event,dd);
					win.closeWin();
				}
			}
		}
		
		
	}
}