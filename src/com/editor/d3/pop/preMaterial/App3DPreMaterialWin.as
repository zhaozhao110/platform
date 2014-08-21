package com.editor.d3.pop.preMaterial
{
	import com.air.component.SandyAIRImage;
	import com.air.io.FileUtils;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UITile;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIAssetsSymbol;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UIText;
	import com.editor.component.controls.UITextInput;
	import com.editor.d3.cache.D3ProjectCache;
	import com.editor.d3.cache.D3ProjectFilesCache;
	import com.editor.d3.tool.D3AIRImage;
	import com.editor.event.AppEvent;
	import com.editor.manager.DataManager;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.math.SandyQueue;
	import com.sandy.utils.BitmapDataUtil;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;

	//在object选择material
	public class App3DPreMaterialWin extends UIVBox
	{
		public function App3DPreMaterialWin()
		{
			super();
			create_init();
		}
		
		public var searchTI:UITextInput;
		public var closeBtn:UIAssetsSymbol;
		public var tile:UITile;
		
		
		private function create_init():void
		{
			width = 468;
			height = 632;
			backgroundColor = DataManager.def_col;
			styleName = "uicanvas";
			padding = 2;
						
			var hb:UIHBox = new UIHBox();
			hb.height = 22;
			hb.percentWidth = 100;
			hb.verticalAlignMiddle = true
			hb.horizontalGap = 4;
			hb.addEventListener(MouseEvent.MOUSE_DOWN , onMouseDown);
			addChild(hb);
			
			var lb:UILabel = new UILabel();
			lb.text = "搜索："
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
			
			tile = new UITile();
			tile.padding = 15;
			tile.styleName = "uicanvas";
			tile.enabledPercentSize = true;
			tile.enabeldSelect = true;
			tile.doubleClickEnabled = true;
			tile.addEventListener(ASEvent.CHANGE,onTileChange);
			tile.tileWidth = 75;
			tile.tileHeight = 90;
			tile.horizontalGap = 15;
			tile.verticalGap = 15;
			tile.itemRenderer = App3DPreMaterialWinItemRenderer;
			addChild(tile);
			
			hb = new UIHBox();
			hb.paddingLeft = 10;
			hb.height = 85;
			hb.horizontalGap = 10;
			hb.percentWidth = 100;
			hb.styleName = "uicanvas";
			hb.verticalAlignMiddle = true
			addChild(hb);
			
			img = new D3AIRImage();
			img.width = 75;
			img.height = 75;
			hb.addChild(img);
			
			imgTxt = new UIText();
			imgTxt.multiline = true;
			imgTxt.width = 200;
			hb.addChild(imgTxt);
			
			var v:UIVBox = new UIVBox();
			v.width = 130;
			hb.addChild(v);
			
			okBtn = new UIButton();
			okBtn.label = "确定"
			okBtn.addEventListener(MouseEvent.CLICK , onOkBtn);
			v.addChild(okBtn);
			
			if(stage == null){
				addEventListener(Event.ADDED_TO_STAGE,reflashData);
			}
		}
		
		private var okBtn:UIButton;
		private var img:D3AIRImage;
		private var imgTxt:UIText;
		private var confirm_f:Function;
		public static var dataChange:Boolean = true;		
		
		override protected function uiShow():void
		{
			reflashData();
		}
		
		override protected function uiHide():void
		{
			tile.selectedIndex = -1;
			confirm_f = null;
			img.unload();
			imgTxt.htmlText = "";
		}
		
		private function onOpenImg(e:MouseEvent):void
		{
			var f:File = tile.selectedItem as File;
			if(f == null) return ;
			sendAppNotification(AppEvent.preImage_event,f.nativePath);
		}
		
		private function onOkBtn(e:MouseEvent=null):void
		{
			var f:File = tile.selectedItem as File;
			if(f == null) return ;
			if(confirm_f!=null) confirm_f(f,img.content as Bitmap);
			visible = false;
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
		
		private function onResize():void
		{
			if(this.stage == null) return ;
			this.x = this.stage.stageWidth/2 - this.width/2;
			this.y = this.stage.stageHeight/2 - this.height/2
		}
		
		public function setValue(f:Function):void
		{
			confirm_f = f;
			reflashData();
		}
		
		public static var loadQueue:SandyQueue = new SandyQueue();
		
		private function reflashData(e:*=null):void
		{
			onResize()
			
			var a:Array = D3ProjectFilesCache.getInstance().getAllMaterial();
			tile.dataProvider = a;
			dataChange = false;
			visible = true;
		}
		
		private function onTileChange(e:ASEvent):void
		{
			var b:Bitmap = App3DPreMaterialWinItemRenderer(e.component).getBitmap();
			if(b == null) return ;
			b = BitmapDataUtil.cloneBitmap(b);
			var f:File = tile.selectedItem as File;
			if(f == null) return ;
			
			if(e.isDoubleClick){
				if(confirm_f!=null) confirm_f(f,b);
				visible = false;
				return ;
			}
			
			img.source = b;
			imgTxt.htmlText = FileUtils.getFileSize(f.nativePath) + "K" + "<br>" + D3ProjectFilesCache.getInstance().getProjectResPath(f);
		}
		
		private function onCloseHandle(e:MouseEvent):void
		{
			visible = false;
		}
	}
}