package com.editor.module_sea.popview
{
	import com.editor.component.containers.UIHBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UICheckBox;
	import com.editor.component.controls.UIForm;
	import com.editor.component.controls.UINumericStepper;
	import com.editor.component.controls.UITextInput;
	import com.editor.component.controls.UIVlist;
	import com.editor.module_mapIso.popview.MapIsoPopViewBase;
	import com.editor.module_sea.mediator.SeaMapContentMediator;
	import com.editor.module_sea.view.SeaMapItemView;
	import com.sandy.asComponent.event.ASEvent;
	
	import flash.events.MouseEvent;

	public class SeaMapInfoPopview extends MapIsoPopViewBase
	{
		public function SeaMapInfoPopview()
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
		
		public static var instance:SeaMapInfoPopview;
		
		private var id_ti:UITextInput;
		private var x_ti:UITextInput;
		private var y_ti:UITextInput;
		private var scaleX_ti:UITextInput;
		private var scaleY_ti:UITextInput;
		private var expend_ti:UITextInput;
		private var alpha_ns:UINumericStepper
		
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
			
			x_ti = new UITextInput();
			x_ti.width = 150;
			x_ti.formLabel = "x:"
			//x_ti.editable = false;
			x_ti.enterKeyDown_proxy = setMapItemInfo
			a.push(x_ti);
			
			y_ti = new UITextInput();
			y_ti.width = 150;
			y_ti.formLabel = "y:"
			//y_ti.editable = false;
			y_ti.enterKeyDown_proxy = setMapItemInfo
			a.push(y_ti);
			
			scaleX_ti = new UITextInput();
			scaleX_ti.width = 150;
			scaleX_ti.formLabel = "scaleX:"
			//scaleX_ti.editable = false;
			scaleX_ti.text = "1"
			scaleX_ti.enterKeyDown_proxy = setMapItemInfo
			a.push(scaleX_ti);
			
			scaleY_ti = new UITextInput();
			scaleY_ti.width = 150;
			scaleY_ti.formLabel = "scaleY:"
			//scaleY_ti.editable = false;
			scaleY_ti.text = "1"
			scaleY_ti.enterKeyDown_proxy = setMapItemInfo
			a.push(scaleY_ti);
			
			expend_ti = new UITextInput();
			expend_ti.width = 150;
			expend_ti.formLabel = "expand:"
			expend_ti.toolTip = "用$分割,按回车键确定"
			expend_ti.enterKeyDown_proxy = expandEnter
			a.push(expend_ti);
			
			alpha_ns = new UINumericStepper();
			alpha_ns.minimum = 0;
			alpha_ns.maximum = 1;
			alpha_ns.stepSize = .1;
			alpha_ns.formLabel = "alpha:"
			alpha_ns.width = 150;
			alpha_ns.addEventListener(ASEvent.CHANGE , onVisibleChange);
			a.push(alpha_ns);
			
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
		
		public var selectMapItem:SeaMapItemView;
		
		public function setMapItem(v:SeaMapItemView):void
		{
			if(v == null) return ;
			if(selectMapItem!=null)selectMapItem.noSelect();
			selectMapItem = v;
			selectMapItem.select();
			reflashInfo()
		}
		   
		private function setMapItemInfo():void
		{
			selectMapItem.scaleX = Number(scaleX_ti.text);
			selectMapItem.scaleY = Number(scaleY_ti.text);
			selectMapItem.x = Number(x_ti.text);
			selectMapItem.y = Number(y_ti.text);
		}
		
		public function reflashInfo():void
		{
			id_ti.text = selectMapItem.item.name1;
			x_ti.text = selectMapItem.x.toString();
			y_ti.text = selectMapItem.y.toString();
			expend_ti.text = selectMapItem.item.expend;
			scaleX_ti.text = selectMapItem.scaleX.toString();
			scaleY_ti.text = selectMapItem.scaleY.toString()
			alpha_ns.value = selectMapItem.alpha;
		}
		
		private function onVisibleChange(e:ASEvent):void
		{
			selectMapItem.alpha = alpha_ns.value;
		}
		
		private function expandEnter():void
		{
			selectMapItem.item.expend = expend_ti.text;
			selectMapItem.setText(expend_ti.text);
		}
		   
		private function onDel(e:MouseEvent):void
		{
			selectMapItem.item.levelItem.revemoItem(selectMapItem.item);
			SeaMapResListPopview.instance.reflashMapInfo();
		}
		
		private function onGotoBtn(e:MouseEvent):void
		{
			get_SeaMapContentMediator().mapEditOutCanvas.verticalScrollPosition = -(selectMapItem.y-get_SeaMapContentMediator().mapEditOutCanvas.height/2)
			get_SeaMapContentMediator().mapEditOutCanvas.horticalScrollPosition = -(selectMapItem.x-get_SeaMapContentMediator().mapEditOutCanvas.width/2)
		}
		
		override protected function uiHide():void
		{
			selectMapItem = null;
		}
		
		private function get_SeaMapContentMediator():SeaMapContentMediator
		{
			return iManager.retrieveMediator(SeaMapContentMediator.NAME) as SeaMapContentMediator;
		}
		
	}
}