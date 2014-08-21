package com.editor.component.expand
{
	import com.editor.component.containers.UIHBox;
	import com.editor.component.controls.UIImage;
	import com.sandy.asComponent.vo.ASComponentConst;
	
	import flash.events.MouseEvent;

	/**
	 * 文件管理工具，新建，删除。。。
	 */ 
	public class UIFileManagerToolBar extends UIHBox
	{
		public function UIFileManagerToolBar()
		{
			super();
			create_init();
		}
		
		private var newBtn:UIImage;
		private var delBtn:UIImage;
		private var uploadBtn:UIImage;
		private var downloadBtn:UIImage;
		private var reflashBtn:UIImage;
		private var backBtn:UIImage;
		
		public function set uploadBtnVisible(value:Boolean):void
		{
			uploadBtn.visible = value;
		}
		
		public function set downloadBtnVisible(value:Boolean):void
		{
			downloadBtn.visible = value;
		}
		
		private function create_init():void
		{
			styleName = "uicanvas"
			this.height = 26;
			horizontalGap =5;
			verticalAlign = ASComponentConst.verticalAlign_middle;
			
			newBtn = new UIImage();
			newBtn.source = "newFile_a"
			newBtn.width = 24;
			newBtn.height = 24;
			addChild(newBtn);
			newBtn.toolTip = "新建目录"
			newBtn.buttonMode = true;
			newBtn.addEventListener(MouseEvent.CLICK,on_newBtn_handle)
			
			delBtn = new UIImage();
			delBtn.source = "delFile_a"
			delBtn.width = 24;
			delBtn.height = 24;
			addChild(delBtn);
			delBtn.toolTip = "删除目录或者文件"
			delBtn.buttonMode = true;
			delBtn.addEventListener(MouseEvent.CLICK,on_delBtn_handle)
				
			backBtn = new UIImage();
			backBtn.source = "back_a"
			backBtn.width = 24;
			backBtn.height = 24;
			addChild(backBtn);
			backBtn.toolTip = "返回上一级"
			backBtn.buttonMode = true;
			backBtn.addEventListener(MouseEvent.CLICK,on_backBtn_handle)
				
			reflashBtn = new UIImage();
			reflashBtn.source = "reflash_a"
			reflashBtn.width = 24;
			reflashBtn.height = 24;
			addChild(reflashBtn);
			reflashBtn.toolTip = "刷新"
			reflashBtn.buttonMode = true;
			reflashBtn.addEventListener(MouseEvent.CLICK,on_reflashBtn_handle)
			
			uploadBtn = new UIImage();
			uploadBtn.source = "uploadFile_a"
			uploadBtn.width = 24;
			uploadBtn.height = 24;
			addChild(uploadBtn);
			uploadBtn.toolTip = "上传"
			uploadBtn.buttonMode = true;
			uploadBtn.addEventListener(MouseEvent.CLICK,on_uploadBtn_handle)
				
			downloadBtn = new UIImage();
			downloadBtn.source = "downFile_a"
			downloadBtn.width = 24;
			downloadBtn.height = 24;
			addChild(downloadBtn);
			downloadBtn.toolTip = "下载"
			downloadBtn.buttonMode = true;
			downloadBtn.addEventListener(MouseEvent.CLICK,on_downloadBtn_handle)
		}
		
		public var newFun:Function;
		public var delFun:Function;
		public var uploadFun:Function;
		public var downloadFun:Function;
		public var reflashFun:Function;
		public var backFun:Function;
		
		private function on_backBtn_handle(e:MouseEvent):void
		{
			if(backFun!=null) backFun();
		}
		
		private function on_newBtn_handle(e:MouseEvent):void
		{
			if(newFun!=null) newFun();
		}
		
		private function on_delBtn_handle(e:MouseEvent):void
		{
			if(delFun!=null) delFun();
		}
		
		private function on_reflashBtn_handle(e:MouseEvent):void
		{
			if(reflashFun!=null) reflashFun();
		}
		
		private function on_uploadBtn_handle(e:MouseEvent):void
		{
			if(uploadFun!=null) uploadFun();
		}
		
		private function on_downloadBtn_handle(e:MouseEvent):void
		{
			if(downloadFun!=null) downloadFun();
		}
	}
}