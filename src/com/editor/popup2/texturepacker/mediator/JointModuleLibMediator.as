package com.editor.popup2.texturepacker.mediator
{
	
	import com.air.io.SelectFile;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UITextInput;
	import com.editor.component.controls.UIVlist;
	import com.editor.mediator.AppMediator;
	import com.editor.popup2.texturepacker.manager.JointModuleManager;
	import com.editor.popup2.texturepacker.view.JointModuleLib;
	import com.sandy.component.controls.SandyTree;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	
	public class JointModuleLibMediator extends AppMediator
	{
		public static const NAME:String = "JointModuleLibMediator";
		public function JointModuleLibMediator(viewComponent:*):void
		{
			super(NAME,viewComponent);
		}
		private function get win():JointModuleLib
		{
			return viewComponent as JointModuleLib;
		}
		public function get foldNameTi():UITextInput
		{
			return win.foldNameTi;
		}
		public function get addFoldBtn():UIButton
		{
			return win.addFoldBtn;
		}
		private function get tree():UIVlist
		{
			return win.tree;
		}
		
		
		override public function onRegister():void
		{
			super.onRegister();
			win.reflashBtn.addEventListener(MouseEvent.CLICK,reflash);
			win.addFoldBtn.addEventListener(MouseEvent.CLICK , addFoldBtnClick);
			
			var path:String = iManager.iSharedObject.find("","jointModule_selectFold");
			if(!StringTWLUtil.isWhitespace(path)){
				JointModuleManager.selectFold = new File(path);
				reflash();
			}
		}
		
		public function addFoldBtnClick(e:MouseEvent):void
		{
			SelectFile.selectDirectory("select img fold",selectResult);
		}
		
		private function selectResult(e:Event):void
		{
			JointModuleManager.selectFold = e.target as File;
			iManager.iSharedObject.put("","jointModule_selectFold",JointModuleManager.selectFold.nativePath);
			reflash();
		}
		
		public function reflash(e:*=null):void
		{
			tree.dataProvider = JointModuleManager.getInstance().getAllImage();
			JointModulePreviewMediator(retrieveMediator(JointModulePreviewMediator.NAME)).reflash();
		}
		
		
		
	}
}