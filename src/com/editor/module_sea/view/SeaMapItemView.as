package com.editor.module_sea.view
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UILoader;
	import com.editor.module_sea.manager.SeaMapModuleManager;
	import com.editor.module_sea.mediator.SeaMapContentMediator;
	import com.editor.module_sea.popview.SeaMapInfoPopview;
	import com.editor.module_sea.popview.SeaMapSmallImgPopView;
	import com.editor.module_sea.proxy.SeaMapModuleProxy;
	import com.editor.module_sea.vo.SeaMapItemVO;
	import com.editor.module_sea.vo.res.SeaMapResInfoItemVO;
	import com.sandy.SandyEngineGlobal;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.core.SandyEngineManagerPool;
	import com.sandy.utils.BitmapDataUtil;
	import com.sandy.utils.ColorUtils;
	import com.sandy.utils.FilterTool;
	import com.sandy.utils.StringTWLUtil;
	import com.sandy.utils.UIComponentUtil;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	public class SeaMapItemView extends UICanvas
	{
		public function SeaMapItemView()
		{
			super();
			
		}
		
		public var item:SeaMapItemVO;
		public var loader:UILoader;
		public var needNext:Boolean=true;
		private var responder2:SeaMapItemViewResponder;
		private var imgCont:UICanvas;
		
		override public function poolChange(value:*):void
		{
			item = value;
			item.container = this;
			
			if(loader == null){
				
				responder2 = new SeaMapItemViewResponder()
				responder2.target = this;
				responder2.y_change = loaderY_change
				responder2.x_change = loaderX_change
				this.respond = responder2;
				
				imgCont = new UICanvas();
				addChild(imgCont);
				
				loader = new UILoader();
				loader.mouseEnabled = true;
				loader.complete_fun = loadComplete;
				//loader.respond = responder2
				imgCont.addChild(loader);
				loader.addEventListener(MouseEvent.MOUSE_OVER , onOverHandle);
				loader.addEventListener(MouseEvent.MOUSE_OUT , onOutHandle);
				loader.addEventListener(MouseEvent.MOUSE_DOWN , onDownHandle);
				loader.doubleClickEnabled = true;
				loader.addEventListener(ASEvent.DOUBLE_CLICK , onDoubleClick);
			}
			
			loader.load(item.resItem.getSwfURL(SeaMapModuleManager.currProject.resFold));
			
			visible = true;
			swapToTop();
			
			if(item.loc != null){
				if(item.loc.check()){
					this.moveByPoint(item.loc);
				}
			}
		}
		
		override public function set scaleX(value:Number):void
		{
			imgCont.scaleX = value;
		}
		
		override public function get scaleX():Number
		{
			return imgCont.scaleX;	
		}
		
		override public function set scaleY(value:Number):void
		{
			imgCont.scaleY = value;
		}
		
		override public function get scaleY():Number
		{
			return imgCont.scaleY;	
		}
		
		private var text:UILabel;
		
		private function createText():void
		{
			if(text == null){
				text = new UILabel();
				//text.width =50
				text.color = ColorUtils.white;
				text.background_red = true
				text.selectable = false;
				text.mouseChildren = false;
				text.mouseEnabled = false;
				text.enabledFliter = true;
				addChild(text);
			}
		}
		
		private function get bitmap():Bitmap
		{
			return loader.content as Bitmap;
		}
		
		public function get contentHolderWidth():int
		{
			return loader.contentHolderWidth;
		}
		
		public function get contentHolderHeight():int
		{
			return loader.contentHolderHeight;
		}
		
		private function loaderX_change(v:*=null):void
		{
			if(SeaMapInfoPopview.instance.selectMapItem!=null){
				if(SeaMapInfoPopview.instance.selectMapItem.uid == this.uid){
					SeaMapInfoPopview.instance.reflashInfo();
				}
			}
		}
		  
		private function loaderY_change(v:*):void
		{
			loaderX_change(v);
		}
		
		private function loadComplete():void
		{
			if(parent is SeaMapLevelView && needNext){
				SeaMapLevelView(parent).loadNext();
			}
			if(parent is SeaMapLevelView){
				SeaMapSmallImgPopView.instance.loadDrawImg()
			}
			
			if(!isNaN(item.scaleX)) scaleX = item.scaleX;
			if(!isNaN(item.scaleY)) scaleY = item.scaleY;
			
			loader.x -= bitmap.bitmapData.width/2;
			loader.y -= bitmap.bitmapData.height/2;
			setText(item.expend);
		}
		
		public function setText(s:String):void
		{
			if(!StringTWLUtil.isWhitespace(s)){
				createText();
				text.text = s
				text.visible = true;
			}else{
				if(text!=null) text.visible = false;
			}
		}
		
		private function get_SeaMapModuleProxy():SeaMapModuleProxy
		{
			return iManager.retrieveProxy(SeaMapModuleProxy.NAME) as SeaMapModuleProxy;
		}
		
		private function onOverHandle(e:MouseEvent):void
		{
			
		}
		
		private function onOutHandle(e:MouseEvent):void
		{
			
		}
		
		override public function select():void
		{
			if(loader.content is Bitmap){
				FilterTool.setGlow(loader.content,0xcc0000,10);	
			}
		}
		
		override public function noSelect():void
		{
			(loader.content as Bitmap).filters = null;
		}
		
		private var drag:Boolean;
		private function onDownHandle(e:MouseEvent):void
		{
			SeaMapModuleManager.downMapItem = this;
			this.stage.addEventListener(MouseEvent.MOUSE_UP,onUpHandle);
			this.stage.addEventListener(Event.MOUSE_LEAVE , onUpHandle);
			drag = false
			get_SeaMapContentMediator().mapEditCanvas.addEventListener(Event.ENTER_FRAME , onEnterFrame);
		}
		
		private var time_u:uint;
		private function onEnterFrame(e:Event):void
		{
			time_u = setTimeout(function():void{drag=true;},500)
			if(drag){
				if((loader.content as Bitmap).filters == null || 
					((loader.content as Bitmap).filters.length == 0)){
					select()
					onDoubleClick()
				}
				this.x = get_SeaMapContentMediator().mapEditCanvas.mouseX;
				this.y = get_SeaMapContentMediator().mapEditCanvas.mouseY;
			}
		}
		
		public function onUpHandle(e:*=null):void
		{
			clearTimeout(time_u);
			this.stage.removeEventListener(MouseEvent.MOUSE_UP,onUpHandle);
			this.stage.removeEventListener(Event.MOUSE_LEAVE , onUpHandle);
			get_SeaMapContentMediator().mapEditCanvas.removeEventListener(Event.ENTER_FRAME , onEnterFrame);
			this.stopDrag();
			loaderX_change();
			SeaMapSmallImgPopView.instance.loadDrawImg();
		}
		
		private function onDoubleClick(e:*=null):void
		{
			SeaMapInfoPopview.instance.setMapItem(this);
			SeaMapInfoPopview.instance.visible = true;
		}
		
		override public function dispose():void
		{
			if(SeaMapInfoPopview.instance.selectMapItem!=null){
				if(SeaMapInfoPopview.instance.selectMapItem.uid == this.uid){
					SeaMapInfoPopview.instance.visible = false;
				}
			}
			if(loader!=null){
				loader.dispose();
			}
			loader = null;
			UIComponentUtil.removeMovieClipChild(null,this);
		}
		
		private function get_SeaMapContentMediator():SeaMapContentMediator
		{
			return iManager.retrieveMediator(SeaMapContentMediator.NAME) as SeaMapContentMediator;
		}
		
	}
}