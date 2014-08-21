package com.editor.modules.pop.projectHelp.view
{
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIImage;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UITextArea;
	import com.editor.component.controls.UITree;
	import com.editor.vo.global.AppGlobalConfig;
	import com.editor.vo.global.AppMenuConfig;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.asComponent.vo.ASTreeData;

	public class ProjectHelpTreeTab extends UIHBox
	{
		public function ProjectHelpTreeTab()
		{
			super();
			create_init();
		}
		
		public var tree:UITree;
		public var infoTi:UITextArea;
		public var infoTi2:UITextArea;
		public var img:UIImage;
		
		private function create_init():void
		{
			enabledPercentSize = true;
			styleName = "uicanvas";
			
			tree = new UITree();
			tree.width = 300;
			tree.labelField = "n"
			tree.percentHeight = 100;
			addChild(tree);
			tree.addEventListener(ASEvent.CHANGE,onTreeChange);
			tree.dataProvider = AppMenuConfig.instance.projectHelp_xml;
			tree.setAllOpen();
			
			var vb:UIVBox = new UIVBox();
			vb.padding = 5;
			vb.verticalGap =5;
			vb.enabledPercentSize = true;
			addChild(vb);
			
			var hb:UIHBox = new UIHBox();
			hb.height = 100;
			hb.percentWidth = 100;
			vb.addChild(hb);
			
			var lb:UILabel = new UILabel();
			lb.text = "注释："
			hb.addChild(lb);
			
			infoTi = new UITextArea();
			infoTi.percentWidth =100;
			infoTi.height = 100;
			hb.addChild(infoTi);
			
			hb = new UIHBox();
			hb.height = 100;
			hb.percentWidth = 100;
			vb.addChild(hb);
			
			lb = new UILabel();
			lb.text = "工具："
			hb.addChild(lb);
			
			infoTi2 = new UITextArea();
			infoTi2.percentWidth =100;
			infoTi2.height = 100;
			hb.addChild(infoTi2);
			
			hb = new UIHBox();
			hb.height = 350;
			hb.percentWidth = 100;
			vb.addChild(hb);
			
			lb = new UILabel();
			lb.text = "按钮位置："
			hb.addChild(lb);
			
			img= new UIImage();
			hb.addChild(img);
		}
		
		private function onTreeChange(e:ASEvent):void
		{
			var d:ASTreeData = e.addData as ASTreeData;
			var x:XML = XML(d.obj);
			infoTi.text = x.@t;
			infoTi2.text = x.@tt;
			if(int(x.@p)>0){
				img.source = AppGlobalConfig.instance.img_url+"project/"+int(x.@p)+".jpg";
			}else{
				img.unload();
			}
		}
		
	}
}