package com.editor.project_pop.publish.mediator
{
	import com.air.io.FileUtils;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.modules.cache.ProjectCache;
	import com.editor.project_pop.publish.component.ProjectPubTab2ItemRenderer;
	import com.editor.project_pop.publish.view.ProjectPubTab2;
	import com.editor.tool.project.jsfl.CompileFla;
	import com.editor.view.popup.AppDestroyPopupwinMediator;
	
	import flash.events.MouseEvent;
	import flash.filesystem.File;

	public class ProjectPubTab2Mediator extends AppDestroyPopupwinMediator
	{
		public static const NAME:String = "ProjectPubTab2Mediator"
		public function ProjectPubTab2Mediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get resWin():ProjectPubTab2
		{
			return viewComponent as ProjectPubTab2
		}
		public function get leftTree():UIVBox
		{
			return resWin.leftTree;
		}
		public function get selectBtn():UIButton
		{
			return resWin.selectBtn;
		}
		public function get allBtn():UIButton
		{
			return resWin.allBtn;
		}
		public function get allBtn2():UIButton
		{
			return resWin.allBtn2;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			var swf:File = new File(ProjectCache.getInstance().getAssetsPath()+File.separator+"swf");
			var a:Array = FileUtils.getDirectoryListing(swf);
			var b:Array = [];
			for(var i:int=0;i<a.length;i++){
				var fl:File = a[i] as File;
				if(fl.name.indexOf("loading_e")==-1){
					if(fl.extension == "fla"){
						b.push(fl);
					}
				}
			}
			
			swf = new File(ProjectCache.getInstance().getThemeAssetsPath()+File.separator+"swf");
			a= FileUtils.getDirectoryListing(swf);
			for(i=0;i<a.length;i++){
				fl= a[i] as File;
				if(fl.name.indexOf("loading_e")==-1){
					if(fl.extension == "fla"){
						b.push(fl);
					}
				}
			}
			
			leftTree.dataProvider = b.sortOn("name");
		}
		
		private var select_ls:Array = [];
		
		public function addSwf(fl:File):void
		{
			if(select_ls.indexOf(fl.nativePath)==-1){
				select_ls.push(fl.nativePath);
			}
		}
		
		public function delSwf(fl:File):void
		{
			var n:int = select_ls.indexOf(fl.nativePath);
			if(n >= 0){
				select_ls.splice(n,1);
			}
		}
		
		public function reactToSelectBtnClick(e:MouseEvent):void
		{
			var a:Array = [];
			var n:int = select_ls.length;
			for(var i:int=0;i<n;i++){
				var obj:Object = {};
				obj.fla = new File(select_ls[i]);
				obj.swf = getBinSwfFile(obj.fla.name.split(".")[0],File(obj.fla).nativePath.indexOf(getThemeSwfFile().nativePath)!=-1);
				a.push(obj);
			}
			var c:CompileFla = new CompileFla();
			c.compile(a)
		}
		
		public function reactToAllBtn2Click(e:MouseEvent):void
		{
			select_ls = null;select_ls = [];
			var n:int = leftTree.numChildren;
			for(var i:int=0;i<n;i++){
				ProjectPubTab2ItemRenderer(leftTree.getChildAt(i)).select2();
			}
		}
		
		public function reactToAllBtnClick(e:MouseEvent):void
		{
			var a:Array = [];
			var n:int = leftTree.numChildren;
			for(var i:int=0;i<n;i++){
				var obj:Object = {};
				obj.fla = ProjectPubTab2ItemRenderer(leftTree.getChildAt(i)).data as File;
				obj.swf = getBinSwfFile(obj.fla.name.split(".")[0],File(obj.fla).nativePath.indexOf(getThemeSwfFile().nativePath)!=-1);
				a.push(obj);
			}
			var c:CompileFla = new CompileFla();
			c.compile(a)			
		}
		
		private function getThemeSwfFile():File
		{
			return new File(ProjectCache.getInstance().getThemeAssetsPath()+File.separator+"swf");
		}
				
		private function getBinSwfFile(n:String,isInTheme:Boolean):File
		{
			var bin_swf:File;
			if(!isInTheme){
				bin_swf = new File(ProjectCache.getInstance().getBin()+File.separator+"assets"+File.separator+"swf");
			}else{
				bin_swf = new File(ProjectCache.getInstance().getBin()+File.separator+"theme"+File.separator+"assets"+File.separator+"swf");
			}
			var fl:File = new File(bin_swf.nativePath+File.separator+n+".swf");
			return fl;
		}
		
	}
}