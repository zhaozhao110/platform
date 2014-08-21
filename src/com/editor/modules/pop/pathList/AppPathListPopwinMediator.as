package com.editor.modules.pop.pathList
{
	import com.air.thread.ThreadMessageData;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UITextInput;
	import com.editor.component.controls.UIVlist;
	import com.editor.model.AppMainModel;
	import com.editor.model.OpenPopwinData;
	import com.editor.modules.cache.ProjectCache;
	import com.editor.view.popup.AppDestroyPopupwinMediator;
	import com.sandy.asComponent.controls.data.ASTreeDataProvider;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.asComponent.vo.ASTreeData;
	import com.sandy.puremvc.patterns.observer.Notification;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.events.Event;
	import flash.events.TextEvent;
	import flash.filesystem.File;

	public class AppPathListPopwinMediator extends AppDestroyPopupwinMediator
	{
		public static const NAME:String = "AppPathListPopwinMediator"
		public function AppPathListPopwinMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get pathWin():AppPathListPopwin
		{
			return viewComponent as AppPathListPopwin;
		}
		public function get fileTree():UIVlist
		{
			return pathWin.file_tree;
		}
		public function get pathTI():UITextInput
		{
			return pathWin.pathTI;
		}
		public function get lb():UILabel
		{
			return pathWin.lb;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			winVO = (pathWin.item as OpenPopwinData).data as OpenPathListPopWinVO;
			tool = new PathListWinTool();
			
			fileTree.doubleClickEnabled = true;
			fileTree.addEventListener(ASEvent.CHANGE,fileTreeChangeHandle);
			
			pathTI.addEventListener(ASEvent.CHANGE,filter);
			
			//只是会搜索src下的目录
			
			if(winVO.pathFile != null){
				if(winVO.isDirectory){
					dataA = tool.getDirectory(winVO.pathFile);
				}else{
					dataA = tool.getAllFile(winVO.pathFile);
				}
				pathTI.text = ProjectCache.getInstance().getOppositePath(winVO.pathFile.nativePath);
			}
			else
			{
				if(winVO.isDirectory){
					dataA = tool.getDirectory(new File(ProjectCache.getInstance().getProjectSrcURL()))
				}else{
					dataA = tool.getAllFile(new File(ProjectCache.getInstance().getProjectSrcURL()));
				}
			}
			fileTree.dataProvider = dataA;
		}
		
		private var dataA:Array = [];
		
		private function filter(e:ASEvent):void
		{
			var a:Array = [];
			for(var i:int=0;i<dataA.length;i++){
				var obj:Object = dataA[i];
				if(obj.name.indexOf(pathTI.text)!=-1){
					a.push(obj);
				}
			}
			fileTree.dataProvider = a;
		}
		
		private var tool:PathListWinTool;
		private var winVO:OpenPathListPopWinVO;
		
		private function fileTreeChangeHandle(e:ASEvent):void
		{
			var file:Object = e.addData as Object;
			pathTI.text = ProjectCache.getInstance().getOppositePath(file.path);
			if(e.isDoubleClick){
				okButtonClick();
			}
		}
		
		override protected function okButtonClick():void
		{
			//super.okButtonClick();
			if(StringTWLUtil.isWhitespace(pathTI.text)){
				return ;
			}
			winVO.call_f(new File(ProjectCache.getInstance().getProjectOppositePath(pathTI.text)));
			closeWin();
		}
		
	}
}