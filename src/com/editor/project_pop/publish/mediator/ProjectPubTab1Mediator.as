package com.editor.project_pop.publish.mediator
{
	import com.air.io.FileUtils;
	import com.air.io.WriteFile;
	import com.editor.command.BackgroundThreadCommand;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UITextArea;
	import com.editor.modules.cache.ProjectCache;
	import com.editor.project_pop.publish.ProjectPublishPopwinMediator;
	import com.editor.project_pop.publish.view.ProjectPubTab1;
	import com.editor.view.popup.AppDestroyPopupwinMediator;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.asComponent.vo.IASTreeData;
	import com.sandy.component.controls.SandyTickTree;
	import com.sandy.popupwin.mediator.TabNavNotDestroyPopwinMediator;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.events.MouseEvent;
	import flash.filesystem.File;

	public class ProjectPubTab1Mediator extends AppDestroyPopupwinMediator
	{
		public static const NAME:String = "ProjectPubTab1Mediator"
		public function ProjectPubTab1Mediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get resWin():ProjectPubTab1
		{
			return viewComponent as ProjectPubTab1
		}
		public function get leftTree():SandyTickTree
		{
			return resWin.leftTree;
		}
		public function get rightTree():SandyTickTree
		{
			return resWin.rightTree;
		}
		public function get saveBtn():UIButton
		{
			return resWin.saveBtn;
		}
		public function get fileTxt():UITextArea
		{
			return resWin.fileTxt;
		}
		public function get fileBtn():UIButton
		{
			return resWin.fileBtn;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			var s:String = get_ProjectPublishPopwinMediator().hash.find("files");
			if(!StringTWLUtil.isWhitespace(s)){
				file_ls = s.split(",");
			}
			
			leftTree.filter_proxy = filter_proxy;
			leftTree.addEventListener(ASEvent.TICKSELECTCHANGE,leftTickChange);
			rightTree.filter_proxy = filter_proxy
			rightTree.addEventListener(ASEvent.TICKSELECTCHANGE,rightTickChange);
			leftTree.dataProvider = FileUtils.createFile(ProjectCache.getInstance().getBin());
			rightTree.dataProvider = FileUtils.createFile(ProjectCache.getInstance().getRelease());
		}
		
		private function get_ProjectPublishPopwinMediator():ProjectPublishPopwinMediator
		{
			return retrieveMediator(ProjectPublishPopwinMediator.NAME) as ProjectPublishPopwinMediator;
		}
		
		private function filter_proxy(d:IASTreeData):Boolean
		{
			var path:String = d.obj.url;
			var isDirectory:Boolean = d.obj.isDirectory;
			
			if(file_ls.indexOf(path)!=-1){
				d.tickSelected = true
			}else{
				d.tickSelected = false
			}
			
			var filter:Array = []
			filter.push(ProjectCache.getInstance().getBin()+File.separator+"com");
			filter.push(ProjectCache.getInstance().getBin()+File.separator+"theme");
			filter.push(ProjectCache.getInstance().getRelease()+File.separator+"com");
			filter.push(ProjectCache.getInstance().getRelease()+File.separator+"theme");
			
			for(var i:int=0;i<filter.length;i++){
				if(path.indexOf(filter[i])!=-1){
					return false;
				}
			}
			return true
		}
		 
		public function reactToSaveBtnClick(e:MouseEvent):void
		{
			addSourceList();
		}
		
		public function reactToFileBtnClick(e:MouseEvent):void
		{
			copyFiles();
		}
		
		private function copyFiles():void
		{
			if(StringTWLUtil.isWhitespace(get_ProjectPublishPopwinMediator().textTi.text)) return ;
			
			addSourceList()
			
			var a:Array = file_ls;
			var log_a:Array = [];
			var ba:Array = [];
			for(var i:int=0;i<a.length;i++){
				var path:String = file_ls[i];
				if(!StringTWLUtil.isWhitespace(path)){
					var fl:File = new File(path);
					if(fl.exists && !fl.isDirectory){
						var newFl:File;
						if(path.indexOf(ProjectCache.getInstance().getBin())!=-1){
							newFl = new File(get_ProjectPublishPopwinMediator().textTi.text+File.separator+path.substring(ProjectCache.getInstance().getBin().length,path.length));
							//WriteFile.copy(fl,newFl);
							ba.push({from:fl.nativePath,to:newFl.nativePath})
							log_a.push(newFl.nativePath);
						}
						if(path.indexOf(ProjectCache.getInstance().getRelease())!=-1){
							newFl = new File(get_ProjectPublishPopwinMediator().textTi.text+File.separator+path.substring(ProjectCache.getInstance().getRelease().length,path.length));
							//WriteFile.copy(fl,newFl);
							ba.push({from:fl.nativePath,to:newFl.nativePath})
							log_a.push(newFl.nativePath);
						}
					}
				}
			}
			BackgroundThreadCommand.instance.copyFiles(ba);
			resWin.setCopyFilesLog(log_a.join(StringTWLUtil.NEWLINE_SIGN2));
		}
		
		public var file_ls:Array = [];
		
		private function addSourceList():void
		{
			file_ls = null;file_ls = [];
			var a:Array = leftTree.tickSelect_ls;
			var b:Array = rightTree.tickSelect_ls;
			a = a.concat(b);
			for(var i:int=0;i<a.length;i++){
				var d:IASTreeData = a[i] as IASTreeData;
				if(d!=null){
					var path:String = d.obj.url;
					if(file_ls.indexOf(path)==-1 && !StringTWLUtil.isWhitespace(path)){
						file_ls.push(path);
					}
				}
			}
			get_ProjectPublishPopwinMediator().hash.put("files",file_ls.join(","));
		}
		
		private function leftTickChange(e:ASEvent):void
		{
			//get_ProjectPublishPopwinMediator().addSourceList();
		}
		
		private function rightTickChange(e:ASEvent):void
		{
			//get_ProjectPublishPopwinMediator().addSourceList();
		}
		
	}
}