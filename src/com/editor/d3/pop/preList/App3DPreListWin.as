package com.editor.d3.pop.preList
{
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIAssetsSymbol;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UITextInput;
	import com.editor.component.controls.UIVlist;
	import com.editor.d3.cache.D3ComponentConst;
	import com.editor.d3.cache.D3ProjectCache;
	import com.editor.d3.cache.D3ProjectFilesCache;
	import com.editor.d3.object.D3Object;
	import com.editor.d3.object.base.D3ObjectBase;
	import com.editor.d3.process.D3ProccessAnim;
	import com.editor.d3.process.D3ProccessMaterial;
	import com.editor.d3.process.D3ProccessMesh;
	import com.editor.d3.process.D3ProccessParticle;
	import com.editor.d3.view.attri.com.D3ComFile;
	import com.editor.manager.DataManager;
	import com.sandy.asComponent.containers.ASDataGridColumn;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.asComponent.vo.ASComponentConst;
	import com.sandy.utils.ColorUtils;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;

	
	public class App3DPreListWin extends UIVBox
	{
		public function App3DPreListWin()
		{
			super();
			create_init();
		}
		
		public var searchTI:UITextInput;
		public var closeBtn:UIAssetsSymbol;
		public var contList:UIVlist;
		
		public static var dataChange:Boolean = true;
		
		private function create_init():void
		{
			styleName = "uicanvas"
			width = 468;
			height = 632;
			padding = 4;
			verticalGap = 3;
			
			var hb:UIHBox = new UIHBox();
			hb.height = 30;
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
						
			
			var v:UIVBox = new UIVBox();
			v.enabledPercentSize = true;
			v.backgroundColor = DataManager.def_col;
			v.styleName = "uicanvas";
			addChild(v);
			
			contList = new UIVlist();
			contList.styleName = "list"
			contList.doubleClickEnabled = true
			contList.enabledPercentSize = true
			contList.enabeldSelect = true;
			contList.addEventListener(ASEvent.CHANGE,onChange);
			contList.verticalScrollPolicy = ASComponentConst.scrollPolicy_auto;
			v.addChild(contList);
			
			addEventListener(Event.ADDED_TO_STAGE,onAddStage);
		}
		
		override protected function uiHide():void
		{
			
		}
		
		override protected function uiShow():void
		{
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
		
		public var comp:D3ObjectBase;
		public var comFile:D3ComFile;
		private var confirm_f:Function;
		public function setValue(c:D3ObjectBase,f:Function):void
		{
			comp = c;
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
			
			var a:Array = comp.proccess.getPreList(comFile);
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
			if(e.isDoubleClick){
				selectFile(contList.selectedItem as File);
			}
		}
	}
}