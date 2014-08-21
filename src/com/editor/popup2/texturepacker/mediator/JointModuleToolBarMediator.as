package com.editor.popup2.texturepacker.mediator
{
	import com.air.io.DeleteFile;
	import com.air.io.FileUtils;
	import com.air.io.ReadFile;
	import com.air.io.SelectFile;
	import com.air.io.WriteFile;
	import com.air.utils.ZipPack;
	import com.editor.component.containers.UICanvas;
	import com.editor.component.controls.UICombobox;
	import com.editor.component.controls.UITextInput;
	import com.editor.mediator.AppMediator;
	import com.editor.popup2.texturepacker.manager.JointModuleManager;
	import com.editor.popup2.texturepacker.view.JointModuleToolBar;
	import com.sandy.common.zip.ZIP;
	import com.sandy.common.zip.ZIPFileVO;
	import com.sandy.popupwin.data.OpenMessageData;
	
	import flash.events.Event;
	import flash.events.FileListEvent;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.net.FileFilter;
	import flash.sampler.getSavedThis;
	import flash.utils.ByteArray;

	public class JointModuleToolBarMediator extends AppMediator
	{
		public static const NAME:String = "JointModuleToolBarMediator";
		public function JointModuleToolBarMediator(viewComponent:*):void
		{
			super(NAME,viewComponent);
		}
	
		public function get win():JointModuleToolBar
		{
			return viewComponent as JointModuleToolBar;
		}
		public function get mw():UITextInput
		{
			return win.mw as UITextInput;
		}
		public function get mh():UITextInput
		{
			return win.mh as UITextInput;
		}
		public function get fmb():UICombobox
		{
			return win.fmb;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			
			win.t.addEventListener(MouseEvent.CLICK ,      newHandle)
			win.sb.addEventListener(MouseEvent.CLICK,      saveProjectHandler);
			
			win.rf.addEventListener(MouseEvent.CLICK , 		sizeHandle)
			
		}
		
		///////////////////////////////新建///////////////////////////////
		private function newHandle(e:MouseEvent):void
		{
			var m:OpenMessageData = new OpenMessageData();
			m.info = "将清除所有缓存?"
			m.okButtonLabel = "新建";
			m.okFunction = openNew;
			showConfirm(m);
		}
		
		private function openNew():Boolean
		{
			mw.text  = JointModuleManager.img_w.toString(); 
			mh.text  = JointModuleManager.img_h.toString(); 
			get_JointModulePreviewMediator().resetSize();
			JointModuleManager.getInstance().clear();
			return true;
		}
		
		private function get_JointModulePreviewMediator():JointModulePreviewMediator
		{
			return retrieveMediator(JointModulePreviewMediator.NAME) as JointModulePreviewMediator;
		}
		
		
		///////////////////////////////保存///////////////////////////////
		private function saveProjectHandler(e:MouseEvent):void
		{
			if(JointModuleManager.getInstance().get_JointModulePreviewMediator().bma_ls.length == 0) return
			JointModuleManager.getInstance().publish();
		}
		
		///////////////////////////////刷新大小///////////////////////////////
		private function sizeHandle(e:MouseEvent):void
		{
			JointModuleManager.img_w = int(mw.text);
			JointModuleManager.img_h = int(mh.text);
			if(JointModuleManager.img_w==0){
				JointModuleManager.img_w = 512
			}
			if(JointModuleManager.img_h==0){
				JointModuleManager.img_h = 512
			}
			JointModuleManager.getInstance().get_JointModulePreviewMediator().reflash();
		}
		
		private function get_JointModuleLibMediator():JointModuleLibMediator
		{
			return retrieveMediator(JointModuleLibMediator.NAME) as JointModuleLibMediator;
		}
	}
}