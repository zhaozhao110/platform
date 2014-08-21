package com.editor.popup2.texturepacker.mediator
{
		
	import com.editor.popup2.texturepacker.manager.JointModuleManager;
	import com.editor.popup2.texturepacker.view.JointModule;
	import com.editor.popup2.texturepacker.view.JointModuleLib;
	import com.editor.popup2.texturepacker.view.JointModulePreview;
	import com.editor.popup2.texturepacker.view.JointModuleToolBar;
	import com.editor.view.popup.AppDestroyPopupwinMediator;
	
	import flash.desktop.Clipboard;
	import flash.desktop.ClipboardFormats;
	import flash.desktop.NativeDragManager;
	import flash.events.NativeDragEvent;
	import flash.filesystem.File;
	
	public class JointModuleMediator extends AppDestroyPopupwinMediator
	{
		public static const NAME:String = "JointModuleMediator";
		public function JointModuleMediator(viewComponent:*):void
		{
			super(NAME,viewComponent);
		}
		
		public function get win():JointModule
		{
			return viewComponent as JointModule;
		}
		
		public function get toolBar():JointModuleToolBar
		{
			return win.toolBar
		}
		
		public function get preview():JointModulePreview
		{
			return win.preview;
		}
		
		public function get lib():JointModuleLib
		{
			return win.lib;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			registerMediator(new JointModuleToolBarMediator(toolBar));
			registerMediator(new JointModulePreviewMediator(preview));
			registerMediator(new JointModuleLibMediator(lib));
			
		}
	}
}