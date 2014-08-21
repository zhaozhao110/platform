package com.editor.project_pop.publish
{
	import com.air.io.HashMapFile;
	import com.air.io.ReadFile;
	import com.air.io.SelectFile;
	import com.air.io.WriteFile;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UITextInput;
	import com.editor.modules.cache.ProjectCache;
	import com.editor.view.popup.AppDestroyPopupwinMediator;
	import com.sandy.asComponent.vo.IASTreeData;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import com.editor.project_pop.publish.view.ProjectPubTab1;
	import com.editor.project_pop.publish.view.ProjectPubTab2;
	import com.editor.project_pop.publish.mediator.ProjectPubTab1Mediator;
	import com.editor.project_pop.publish.mediator.ProjectPubTab2Mediator;

	public class ProjectPublishPopwinMediator extends AppDestroyPopupwinMediator
	{
		public static const NAME:String = "ProjectPublishPopwinMediator"
		public function ProjectPublishPopwinMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get resWin():ProjectPublishPopwin
		{
			return viewComponent as ProjectPublishPopwin
		}
		public function get tab1():ProjectPubTab1
		{
			return resWin.tab1;
		}
		public function get tab2():ProjectPubTab2
		{
			return resWin.tab2;
		}
		public function get textTi():UITextInput
		{
			return resWin.textTi;
		}
		public function get selectBtn():UIButton
		{
			return resWin.selectBtn;
		}
		
		private var tab1_m:ProjectPubTab1Mediator
		private var tab2_m:ProjectPubTab2Mediator
		
		override public function onRegister():void
		{
			super.onRegister();
			
			hash = new HashMapFile(getStorageFileURL());
			textTi.text = hash.find("directory");
			registerMediator(tab1_m = new ProjectPubTab1Mediator(tab1));
			registerMediator(tab2_m = new ProjectPubTab2Mediator(tab2));
		}
				
		public function reactToSelectBtnClick(e:MouseEvent):void
		{
			SelectFile.selectDirectory("选择服务器目录",resultFile);
		}
		
		private function resultFile(e:Event):void
		{
			textTi.text = (e.target as File).nativePath;
			hash.put("directory",textTi.text);
		}
				
		public var hash:HashMapFile;
			
		public static function getStorageFileURL():String
		{
			return File.applicationStorageDirectory.nativePath+File.separator+"publish.txt"
		}
		
	}
}