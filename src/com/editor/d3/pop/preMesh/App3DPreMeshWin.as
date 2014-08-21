package com.editor.d3.pop.preMesh
{
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIAssetsSymbol;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UITextInput;
	import com.editor.component.controls.UIVlist;
	import com.editor.d3.cache.D3ProjectCache;
	import com.editor.d3.cache.D3ProjectFilesCache;
	import com.editor.manager.DataManager;
	import com.sandy.asComponent.containers.ASDataGridColumn;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.asComponent.vo.ASComponentConst;
	import com.sandy.utils.ColorUtils;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;

	//在object选择mesh
	public class App3DPreMeshWin extends UIVBox
	{
		public function App3DPreMeshWin()
		{
			super();
			create_init();
		}
		
		public var searchTI:UITextInput;
		public var closeBtn:UIAssetsSymbol;
		public var contList:UIVlist;
		public var preview:App3DPreMeshPreview;
		public static var dataChange:Boolean = true;
		
		private function create_init():void
		{
			width = 468;
			height = 632;
			padding = 4;
			verticalGap = 3;
			
			var hb:UIHBox = new UIHBox();
			hb.height = 22;
			hb.percentWidth = 100;
			hb.verticalAlignMiddle = true
			hb.horizontalGap = 4;
			hb.styleName = "uicanvas"
			hb.backgroundColor = DataManager.def_col;
			hb.addEventListener(MouseEvent.MOUSE_DOWN , onMouseDown);
			addChild(hb);
			
			var lb:UILabel = new UILabel();
			lb.text = "搜索："
			lb.width = 50;
			//lb.color = ColorUtils.white;
			hb.addChild(lb);
			
			searchTI = new UITextInput();
			searchTI.height = 22;
			searchTI.percentWidth = 100;
			hb.addChild(searchTI);
			
			closeBtn = new UIAssetsSymbol();
			closeBtn.source = "delFile_a"
			closeBtn.buttonMode = true;
			closeBtn.width = 24;
			closeBtn.height = 24;
			closeBtn.addEventListener(MouseEvent.CLICK , onCloseHandle);
			hb.addChild(closeBtn);
						
			
			preview = new App3DPreMeshPreview(this);
			preview.width = 460
			addChild(preview);
			
			var v:UIVBox = new UIVBox();
			v.enabledPercentSize = true;
			v.backgroundColor = DataManager.def_col;
			v.styleName = "uicanvas";
			addChild(v);
			
			contList = new UIVlist();
			contList.styleName = "list"
			contList.enabledPercentSize = true
			contList.enabeldSelect = true;
			contList.addEventListener(ASEvent.CHANGE,onChange);
			contList.verticalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			v.addChild(contList);
			
			addEventListener(Event.ADDED_TO_STAGE,onAddStage);
		}
		
		override protected function uiHide():void
		{
			preview.visible = false;
		}
		
		override protected function uiShow():void
		{
			preview.visible = true;
			reflashData();
		}
		
		private function onAddStage(e:Event):void
		{
			onResize();
		}
		
		private function onMouseDown(e:MouseEvent):void
		{
			this.startDrag();
			this.stage.addEventListener(MouseEvent.MOUSE_UP , onMouseUp);
			this.addEventListener(Event.MOUSE_LEAVE , onMouseUp);
		}
		
		private function onMouseUp(e:*=null):void
		{
			this.stopDrag();	
			
			this.stage.removeEventListener(MouseEvent.MOUSE_UP , onMouseUp);
			this.removeEventListener(Event.MOUSE_LEAVE , onMouseUp);
		}
		
		private function onCloseHandle(e:MouseEvent):void
		{
			visible = false;
		}
		
		private var confirm_f:Function;
		public function setValue(f:Function):void
		{
			confirm_f = f;
			reflashData();
		}

		public function selectFile(f:File):void
		{
			confirm_f(f);
			visible = false;
		}
		
		private function reflashData():void
		{
			onResize();
			
			var a:Array = D3ProjectFilesCache.getInstance().getAllMesh();
			contList.labelFunction = contListLabelFun;
			contList.dataProvider = a;
			dataChange = false;
			visible = true;
		}
		
		private function contListLabelFun(d:*,c:ASDataGridColumn):String
		{
			return D3ProjectFilesCache.getInstance().getProjectResPath((d as File));
		}
		
		private function onResize():void
		{
			if(this.stage == null) return ;
			this.x = this.stage.stageWidth/2 - this.width/2;
			this.y = this.stage.stageHeight/2 - this.height/2
		}
		
		private function onChange(e:ASEvent):void
		{
			preview.setData(contList.selectedItem as File);
		}
	}
}