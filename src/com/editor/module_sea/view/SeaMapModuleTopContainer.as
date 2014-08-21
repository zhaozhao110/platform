package com.editor.module_sea.view
{
	import com.editor.component.containers.UIHBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UIMenuBar;
	import com.sandy.asComponent.vo.ASComponentConst;
	
	public class SeaMapModuleTopContainer extends UIHBox
	{
		public function SeaMapModuleTopContainer()
		{
			super();
			create_init()
		}
		
		public var menuBar:UIMenuBar;
		public var visiLogButton:UIButton;
		public var infoTxt:UILabel;
		public var infoTxt2:UILabel;
		
		private var menu_xml:XML = <root>
			<menuitem label="文件">
				<menuitem label="选择地图" data="1"/>
				<menuitem label="添加配置资源" data="2"/>
				<menuitem label="保存" data="saveMapBtn"/>
			</menuitem>
			<menuitem label="视图" >
				<menuitem label="缩略图" data="12"/>
				<menuitem label="资源库" data="imageLibBtn"/>
				<menuitem label="分层信息" data="mouseInfoBtn"/>
				<menuitem label="鼠标信息" data="mouseInfoBtn2"/>
				<menuitem label="物体列表" data="mouseInfoBtn3"/>
			</menuitem>
		</root>
		
		//<menuitem label="取消点或物体" data="alphaBtn"/>
		
		private function create_init():void
		{
			styleName = "uicanvas";
			verticalAlign = ASComponentConst.verticalAlign_middle;
			percentWidth=100
			paddingLeft=20
			height = 30;
			horizontalGap = 10;
			
			menuBar = new UIMenuBar()
			menuBar.width = 400;
			menuBar.height = 25;
			menuBar.dataProvider = menu_xml;
			addChild(menuBar);
			
			visiLogButton = new UIButton();
			visiLogButton.label = "隐藏LOG";
			addChild(visiLogButton);
			
			infoTxt = new UILabel();
			infoTxt.text = ""
			addChild(infoTxt);
			
			infoTxt2 = new UILabel();
			addChild(infoTxt2);
		}
	}
}