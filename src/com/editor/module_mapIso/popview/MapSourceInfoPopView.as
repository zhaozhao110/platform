package com.editor.module_mapIso.popview
{
	import com.editor.component.containers.UIHBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UIForm;
	import com.editor.component.controls.UITextInput;
	import com.editor.module_mapIso.manager.MapEditorIsoManager;
	import com.editor.module_mapIso.view.items.Building;
	
	import flash.events.MouseEvent;

	public class MapSourceInfoPopView extends MapIsoPopViewBase
	{
		public function MapSourceInfoPopView()
		{
			super();
			if(instance == null){
				instance = this;
			}
		}
		
		override protected function get titles():String
		{
			return "资源信息";	
		}
		
		public static var instance:MapSourceInfoPopView;
		
		private var id_ti:UITextInput;
		private var index_ti:UITextInput;
		private var x_ti:UITextInput;
		private var y_ti:UITextInput;
		private var cellX_ti:UITextInput;
		private var cellY_ti:UITextInput;
		private var expend_ti:UITextInput;
		
		override protected function create_init():void
		{
			width = 225;
			height = 300;
			super.create_init();
			
			var hb:UIForm = new UIForm();
			hb.leftWidth = 50;
			hb.enabledPercentSize = true;
			addContent(hb);
			
			var a:Array = [];
			
			id_ti = new UITextInput();
			id_ti.width = 150;
			id_ti.formLabel = "id:"
			id_ti.editable = false;
			a.push(id_ti);
			
			index_ti = new UITextInput();
			index_ti.width = 150;
			index_ti.formLabel = "index:"
			index_ti.editable = false;
			a.push(index_ti);
			
			x_ti = new UITextInput();
			x_ti.width = 150;
			x_ti.formLabel = "x:"
			x_ti.editable = false;
			a.push(x_ti);
			
			y_ti = new UITextInput();
			y_ti.width = 150;
			y_ti.formLabel = "y:"
			y_ti.editable = false;
			a.push(y_ti);
			
			cellX_ti = new UITextInput();
			cellX_ti.width = 150;
			cellX_ti.formLabel = "cellX:"
			cellX_ti.editable = false;
			a.push(cellX_ti);
			
			cellY_ti = new UITextInput();
			cellY_ti.width = 150;
			cellY_ti.formLabel = "cellY:"
			cellY_ti.editable = false;
			a.push(cellY_ti);
			
			expend_ti = new UITextInput();
			expend_ti.width = 150;
			expend_ti.formLabel = "expand:"
			expend_ti.toolTip = "用$分割,按回车键确定"
			expend_ti.enterKeyDown_proxy = expandEnter
			a.push(expend_ti);
			
			var hb2:UIHBox = new UIHBox();
			hb2.height = 30;
			hb2.percentWidth = 100;
			addContent(hb2);
			
			var delBtn:UIButton = new UIButton();
			delBtn.label = "删除"
			delBtn.addEventListener(MouseEvent.CLICK , onDel);
			hb2.addChild(delBtn);
			
			var gotoBtn:UIButton = new UIButton();
			gotoBtn.label = "显示在地图中间"
			gotoBtn.addEventListener(MouseEvent.CLICK , onGotoBtn);
			hb2.addChild(gotoBtn);
			
			hb.areaComponent = a;
		}
		
		private function expandEnter():void
		{
			currBuild.configXml.@exp = expend_ti.text;
		}
		
		private function onDel(e:MouseEvent):void
		{
			MapEditorIsoManager.bottomContainerMediator.removeBuild(currBuild);
		}
		
		private function onGotoBtn(e:MouseEvent):void
		{
			MapEditorIsoManager.bottomContainerMediator.mapEditOutCanvas.verticalScrollPosition = -(currBuild.y-MapEditorIsoManager.bottomContainerMediator.mapEditOutCanvas.height/2)
			MapEditorIsoManager.bottomContainerMediator.mapEditOutCanvas.horticalScrollPosition = -(currBuild.x-MapEditorIsoManager.bottomContainerMediator.mapEditOutCanvas.width/2)
		}
		
		public var currBuild:Building;
		
		public function showUI(bld:Building):void
		{
			currBuild = bld;
			id_ti.text = bld.getResId();
			index_ti.text = bld.index.toString();
			x_ti.text = bld.x.toString();
			y_ti.text = bld.y.toString();
			cellX_ti.text = bld.getCellPoint().x.toString();
			cellY_ti.text = bld.getCellPoint().y.toString();
			expend_ti.text = currBuild.configXml.@exp;
			visible = true;
		}
		
		
	}
}