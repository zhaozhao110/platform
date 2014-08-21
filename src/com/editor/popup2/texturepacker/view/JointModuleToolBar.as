package com.editor.popup2.texturepacker.view
{
	import com.editor.component.containers.UIHBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UICombobox;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UITextInput;
	import com.editor.popup2.texturepacker.component.UIPanel;
	import com.editor.popup2.texturepacker.manager.JointModuleManager;
	
	public class JointModuleToolBar extends UIPanel
	{
		private var isDragInComplete:Boolean;
		public var t:UIButton;
		
		public var sb:UIButton;
		public var mwl:UILabel;
		public var mw:UITextInput;
		public var mhl:UILabel;
		public var mh:UITextInput;
		public var rf:UIButton;
		
		private var fml:UILabel;
		public var fmb:UICombobox;
		public var packType_cb:UICombobox;
		
		private function creatCom():void
		{
			var hb:UIHBox = new UIHBox();
			hb.enabledPercentSize = true;
			hb.verticalAlignMiddle = true;
			hb.horizontalGap = 2;
			hb.paddingLeft = 10
			addChild(hb);
			
			t = new UIButton();
			t.label = "新建";
			t.toolTip = "新建工作环境，清空所有缓存"
			hb.addChild(t);
			
			sb = new UIButton();
			sb.label = "保存";
			sb.toolTip = "保存环境，下次继续编辑"
			hb.addChild(sb);
			
			mwl = new UILabel;
			mwl.width       = 60;
			mwl.height       = 22;
			mwl.text       = "最大宽度:";
			mwl.color       = 0x000000;
			hb.addChild(mwl);
			
			mw  = new UITextInput;
			mw.width  	= 60;
			mw.onlyNumber = true;
			mw.text  	= JointModuleManager.img_w.toString(); 
			hb.addChild(mw);
			
			mhl = new UILabel;
			mhl.width       = 60;
			mhl.height       = 22;
			mhl.text       = "最大高度:";
			mhl.color       = 0x000000;
			hb.addChild(mhl);
			
			mh  = new UITextInput;
			mh.width = 60;
			mh.onlyNumber = true;
			mh.text  = JointModuleManager.img_h.toString()
			hb.addChild(mh);
			
			rf= new UIButton;
			rf.label = "刷新大小";
			hb.addChild(rf);
			
			fml = new UILabel;
			fml.width       = 40;
			fml.height       = 22;
			fml.text = "格式：";
			hb.addChild(fml);
			
			fmb = new UICombobox;
			fmb.width = 80;
			fmb.height = 25;
			hb.addChild(fmb);
			fmb.dataProvider = [".png",".jpg"];
			fmb.selectedIndex = 0;
			
			fml = new UILabel;
			fml.width    = 40;
			fml.height   = 22;
			fml.text = "打包类型：";
			hb.addChild(fml);
			
			packType_cb = new UICombobox();
			packType_cb.width = 100;
			hb.addChild(packType_cb);
			packType_cb.height = 22;
			packType_cb.dataProvider = ["1","2","3","4","5"];
			packType_cb.selectedIndex = 2;
		}
		
		public function JointModuleToolBar()
		{
			super();
			
			percentWidth = 100
			this.height = 50;
			
			creatCom();
			poolChange(null);
		}
		
	}
}