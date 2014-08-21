package com.editor.module_ui.ui
{
	import com.air.io.WriteFile;
	import com.editor.component.containers.UICanvas;
	import com.editor.component.controls.UIImage;
	import com.editor.manager.DataManager;
	import com.editor.module_ui.app.ui.UIEditorTopBarMediator;
	import com.editor.module_ui.event.UIEvent;
	import com.editor.module_ui.view.uiAttri.ComAlignCell;
	import com.editor.module_ui.view.uiAttri.ComSystemAttriCell;
	import com.editor.module_ui.vo.CSSComponentData;
	import com.editor.module_ui.vo.ComponentData;
	import com.editor.module_ui.vo.UIComponentData;
	import com.editor.module_ui.vo.UITreeNode;
	import com.editor.proxy.AppComponentProxy;
	import com.editor.tool.project.create.CreatePopupwinTool;
	import com.sandy.asComponent.core.ASComponent;
	import com.sandy.asComponent.vo.ASComponentConst;
	import com.sandy.event.SandyExternalEvent;
	import com.sandy.gameTool.transform.TransformSizeTool;
	import com.sandy.gameTool.transform.TransformTool;
	import com.sandy.manager.data.SandyDragSource;
	import com.sandy.math.SandyPoint;
	import com.sandy.utils.ColorUtils;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.text.TextField;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	public class UIShowContainer extends UICanvas
	{
		public function UIShowContainer()
		{
			super();
			create_init();
		}
		
		//////////////////////////  compoennt ///////////////////////
		public var background:UIImage;
		private var backgroundCanvas:UICanvas;
		public var content:UICanvas;
		public var cache:UIEditCache = new UIEditCache();
		
		//////////////////////// tool ///////////////////////////
		public var createFile:CreateUIFile = new CreateUIFile();
		public var createXML:CreateUIXML = new CreateUIXML();
		//编辑的ui文件
		public var uiData:UIComponentData;
		//选中的编辑的组件
		public var selectedUI:UIShowCompProxy;
		public var backgImageClick:UIImage;
		public var selectRect_sp:UIShowRectSpr;
		
		private function create_init():void
		{
			mouseEnabled = true
			name = "UIShowContainer";
			enabledMouseWheel = false;
			verticalScrollPolicy = ASComponentConst.scrollPolicy_on;
			horizontalScrollPolicy = ASComponentConst.scrollPolicy_on;
			enabledPercentSize = true;
			dragAndDrop = true;
			this.addEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
			this.addEventListener(MouseEvent.MOUSE_DOWN , contMouseDown);
			
			backgroundCanvas = new UICanvas();
			backgroundCanvas.backgroundColor = ColorUtils.black;
			backgroundCanvas.width = 1500;
			backgroundCanvas.height = 1000;
			backgroundCanvas.mouseEnabled = true;
			backgroundCanvas.mouseChildren = false;
			backgroundCanvas.addEventListener(MouseEvent.CLICK,onBackgroundClick);
			addChild(backgroundCanvas);
			
			background = new UIImage();
			background.mouseChildren = false
			background.mouseEnabled = true;
			background.addEventListener(MouseEvent.MOUSE_DOWN , onBackMouseDown);
			background.addEventListener(MouseEvent.MOUSE_OUT , onBackMouseUp);
			background.addEventListener(MouseEvent.MOUSE_UP,onBackMouseUp);
			addChild(background);
				
			content = new UICanvas();
			content.width = 1500;
			content.height = 1000;
			content.name = "UIShowContainer_content"
			content.mouseChildren = true;
			content.mouseEnabled  = false;
			addChild(content);
			
			selectRect_sp = new UIShowRectSpr();
			selectRect_sp.width = 1500;
			selectRect_sp.height = 1000;
			addChild(selectRect_sp);
						
			var node:UITreeNode = new UITreeNode();
			node.name = "stage";
			node.obj = this;
			node.id = uid;
			node.top = node;
			node.addAllChild(node);
			cache.tree = node;
		}
		
		public function getSelect():ASComponent
		{
			if(selectedUI == null){
				return backgImageClick;
			}
			return selectedUI.target;
		}
		
		private function onMouseOut(e:MouseEvent):void
		{
			
		}
		
		private function contMouseDown(e:MouseEvent):void
		{
			if(background.content!=null){
				get_UIEditorTopBarMediator().pickBackgroundColor(Bitmap(background.content).bitmapData.getPixel(background.mouseX,background.mouseY));
			}
		}
		
		private var later_n:uint;
		private var draged:Boolean;
		private function onBackMouseDown(e:MouseEvent):void
		{
			if(lockBackground){
				draged = false;
				clearTimeout(later_n);
				return ;
			}
			backgImageClick = background;
			draged = false;
			later_n = setTimeout(checkMouseDown,100);
			onBackgroundClick();
		}
		
		private function checkMouseDown():void
		{
			background.startDrag();
		}
		
		private function onBackMouseUp(e:MouseEvent):void
		{
			if(lockBackground) return ;
			clearTimeout(later_n);
			draged = false;
			background.stopDrag();	
			ComSystemAttriCell.instance.reflashBackImgLoc();
		}
		
		public function setValue(d:UIComponentData):void
		{
			uiData = d;
			//create fold
			CreatePopupwinTool.createUserPopupwinFold();
			//
			createFile.target = this;
			createFile.loadBackgroundImage();
			createXML.target = this;
			//
			createFile.parserXML();
			sendAppNotification(UIEvent.selectUI_inUI_event);
		}
		
		public function setBackgroundVisible(value:Boolean):void
		{
			background.visible = value;
		}
		
		private var _lockBackground:Boolean;
		public function get lockBackground():Boolean
		{
			return _lockBackground;
		}
		public function set lockBackground(value:Boolean):void
		{
			_lockBackground = value;
			
		}
		
		
		public function setBackgroundColor(col:uint):void
		{
			backgroundCanvas.backgroundColor = col;
			backgroundCanvas.backgroundAlpha = 1;
		}
		
		public function loadBackground(bit:Bitmap,f:File=null):void
		{
			background.source = bit;
			if(f!=null){
				createFile.copyBackgroundImage(f);
			}
		}
				
		override protected function onDragEnterHandle():Boolean
		{
			var ds:SandyDragSource = getDragSource() as SandyDragSource;
			if(ds == null) return false;
			if(ds.type == DataManager.dragAndDrop_comList){
				return true;
			}
			return false;
		}
		
		override protected function registerDrag_mouseDown():void{}
		
		override protected function onDragDropHandle(e:Event):void
		{
			e.stopImmediatePropagation();
			e.preventDefault();
			
			addComp(getDragSource().data as ComponentData);
			iManager.iDragAndDrop.endDrag(true);
		}
		
		public function addComp(dd:ComponentData,fromXML:Boolean=false,loc:SandyPoint=null):UIShowCompProxy
		{
			var d:ComponentData = dd.cloneObject() as ComponentData;
			
			var ui:ASComponent;
			if(dd.item.isExpandComp() || dd.item.isVirtualComp()){
				ui = UIEditManager.getUIComponent("Canvas")
			}else{
				ui = UIEditManager.getUIComponent(d.name)
			}
			if(ui!=null){
				//d.item = AppComponentProxy.instance.com_ls.getItemByName(d.name);
				ui.data = d;
				
				var comp:UIShowCompProxy = new UIShowCompProxy();
				comp.uiShowContainer = this;
				if(fromXML){
					comp.addCompFormXML(ui);
				}else{
					comp.addComp(ui,cache.tree,loc);
				}
				
				if(comp.parent.id == cache.tree.id){
					content.addChild(ui);
				}
				if(!fromXML){
					setTransToolTarget(comp);
				}
				cache.reflashTreeNodeInitAttri();
				return comp;
			}else{
				trace("no component at:" + d.name);
			}
			return null;
		}
		
		public function swapToAddChild(ui:UIShowCompProxy):void
		{
			if(content.containChild(ui.target)) return ;
			
			//删除原来的
			ui.node.branch.removeItem(ui.node);
			//添加到现在的
			ui.parent = cache.tree;
			cache.tree.addItem(ui.node);
			content.addChild(ui.target);
			
			UIEditCache.reflashCompOutline();
			ui.selectedThis();
		}
		
		public function removeComp(p:UIShowCompProxy):void
		{
			setTransToolTarget(null);
			p.remove();
		}
		
		private function onBackgroundClick(e:MouseEvent=null):void
		{
			setTransToolTarget(null);
			ComAlignCell.instance.showSelectComp(false);
		}
		
		public function setTransToolTarget(d:UIShowCompProxy,_dispatch:Boolean=true,drag:Boolean=true):void
		{
			if(get_UIEditorTopBarMediator().isInPickColor()) return ;
			if(selectedUI != null){
				if(selectedUI.target == null) return ;
			}
			
			if(d!=null){
				backgImageClick = null;
				if(selectedUI!=null){
					selectedUI.target.showBorderInUIEdit(true,ColorUtils.white)
				}
				if(selectedUI == d){
					setTransformTool(d);
					if(drag){
						trans.startToolDrag();
					}
				}
				selectedUI = d;
				selectedUI.target.showBorderInUIEdit(true,ColorUtils.red)
				
				if(trans!=null && trans.data!=null){
					if(trans.data != d){
						setTransformTool(null);
					}
				}
				
			}else{
				if(selectedUI!=null){
					selectedUI.target.showBorderInUIEdit(true,ColorUtils.white)
				}
				selectedUI = null;
				setTransformTool(null);
			}
			
			if(_dispatch){
				dispatchTarget(d);
			}
		}
		
		public function dispatchTarget(d:UIShowCompProxy):void
		{
			iManager.sendAppNotification(SandyExternalEvent.close_menuBar_menu_event,this)
			iManager.sendAppNotification(SandyExternalEvent.close_systemMenu_event,this)
			iManager.sendAppNotification(SandyExternalEvent.close_toolTip_event)
			if(d != null){
				sendAppNotification(UIEvent.selectUI_inUI_event,d.data);
			}else{
				sendAppNotification(UIEvent.selectUI_inUI_event);
			}
		}
		
		private var trans:TransformSizeTool;
		public function setTransformTool(target:UIShowCompProxy):void
		{
			if(trans == null){
				trans = new TransformSizeTool();
				trans.resize_f 	= trans_resize;
				trans.move_f 	= trans_move;
				trans.addEventListener(MouseEvent.MOUSE_DOWN , onTransDown);
				trans.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN,onTransRightDown)
				addChild(trans)
			}
			if(target == null){
				trans.target = null;
				trans.data = null
			}else{
				trans.target = target.target;
				trans.data = target;
			}
		}
		
		private function onTransRightDown(e:MouseEvent):void
		{
			e.stopImmediatePropagation();
			e.preventDefault();
			setTransformTool(null);
		}
		
		private function trans_move():void
		{
			UIShowCompProxy(trans.data).reflashCompAttri();
		}
		
		private function trans_resize():void
		{
			UIShowCompProxy(trans.data).reflashCompAttri();
		}
		
		private function onTransDown(e:MouseEvent):void
		{
			setTransToolTarget(trans.data as UIShowCompProxy);
		}
				
		public function get_AppComponentProxy():AppComponentProxy
		{
			return iManager.retrieveProxy(AppComponentProxy.NAME) as AppComponentProxy;
		}
		
		private function get_UIEditorTopBarMediator():UIEditorTopBarMediator
		{
			return iManager.retrieveMediator(UIEditorTopBarMediator.NAME) as UIEditorTopBarMediator
		}
		
		
	}
}