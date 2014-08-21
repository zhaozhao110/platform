package com.editor.module_ui.ui
{
	import com.air.io.ReadFile;
	import com.editor.manager.DataManager;
	import com.editor.module_ui.css.CreateCSSFileItemVO;
	import com.editor.module_ui.css.PaserCSSXML;
	import com.editor.module_ui.event.UIEvent;
	import com.editor.module_ui.ui.vo.CreateUIFileCompAttri;
	import com.editor.module_ui.ui.vo.InvertedGroupVO;
	import com.editor.module_ui.view.uiAttri.ComAlignCell;
	import com.editor.module_ui.view.uiAttri.com.ComBase;
	import com.editor.module_ui.view.uiAttri.itemRenderer.TabNavViewBox;
	import com.editor.module_ui.view.uiAttri.vo.IComBaseVO;
	import com.editor.module_ui.vo.ComponentData;
	import com.editor.module_ui.vo.UITreeNode;
	import com.editor.module_ui.vo.attri.ComAttriItemVO;
	import com.editor.modules.cache.ProjectCache;
	import com.editor.proxy.AppComponentProxy;
	import com.sandy.SandyEngineGlobal;
	import com.sandy.asComponent.containers.ASCanvas;
	import com.sandy.asComponent.containers.ASViewStack;
	import com.sandy.asComponent.controls.ASTabNavigator;
	import com.sandy.asComponent.controls.loader.ASAssetsSymbol;
	import com.sandy.asComponent.controls.loader.ASLoader;
	import com.sandy.asComponent.core.ASComponent;
	import com.sandy.asComponent.core.ASContainer;
	import com.sandy.asComponent.core.AbstractASText;
	import com.sandy.asComponent.vo.ASComponentConst;
	import com.sandy.core.SandyEngineManagerPool;
	import com.sandy.error.SandyError;
	import com.sandy.gameTool.transform.TransformTool;
	import com.sandy.manager.SandyManagerBase;
	import com.sandy.math.SandyPoint;
	import com.sandy.style.SandyStyleManager;
	import com.sandy.style.SandyStyleNameData;
	import com.sandy.utils.ColorUtils;
	import com.sandy.utils.FilterTool;
	import com.sandy.utils.StringTWLUtil;
	import com.sandy.utils.UIComponentUtil;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.geom.Point;
	import flash.geom.Transform;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	public class UIShowCompProxy
	{
		public function UIShowCompProxy()
		{
			super();
			//target.inventedGroup
		}
				
		//操作的组件
		public var target:ASComponent;
		public var parent:UITreeNode;
		public var node:UITreeNode;
		public var uiShowContainer:UIShowContainer;
		
		public function checkIsMultView():Boolean
		{
			if(target is ASTabNavigator || target as ASViewStack){
				return true;
			}
			return false;
		}
		
		public function get parentComp():ASComponent
		{
			if(parent.obj is UIShowCompProxy){
				return UIShowCompProxy(parent.obj).target;
			}
			return null;
		}
		
		public function get isStageComp():Boolean
		{
			return node.id == uiShowContainer.cache.tree.id;
		}
		
		public function get data():ComponentData
		{
			return target.data as ComponentData;
		}
		
		public function remove():void
		{
			var a:Array = node.getList();
			for(var i:int=0;i<a.length;i++){
				var nd:UITreeNode = a[i] as UITreeNode;
				UIShowCompProxy(nd.obj).remove();
			}
			
			if(target!=null){
				target.removeEventListener(MouseEvent.MOUSE_DOWN , onMouseDown);
				target.removeEventListener(MouseEvent.MOUSE_UP , onMouseUp);
				target.removeEventListener(MouseEvent.RIGHT_CLICK,targetRightClick);
				target.stage.removeEventListener(Event.MOUSE_LEAVE,onMouseUp);
			}
			
			target.dispose();
			UIComponentUtil.removeMovieClipChild(target.parent,target);
			target = null;
			uiShowContainer.cache.removeComp(node);
		}
		
		public function addComp(c:ASComponent,_parent:UITreeNode,loc:SandyPoint=null):void
		{
			target = c;
			parent = _parent;
			data.proxy = this;
			
			if(loc != null){
				target.x = loc.x;
				target.y = loc.y;
			}else{
				target.x = UIEditManager.currEditShowContainer.content.mouseX;
				target.y = UIEditManager.currEditShowContainer.content.mouseY;
			}
			
			setAttri("id","");
			initCompAttri();
			
			if(c is ASContainer || checkIsMultView()){
				(c as ASComponent).showBorderInUIEdit();
				if(c  is ASTabNavigator){
					ASTabNavigator(c).creationPolicy = ASComponentConst.creationPolicy_all;
					ASTabNavigator(c).tabHeight = 30;
					ASTabNavigator(c).tabWidth = 80;
				}
				if(data.item.isExpandComp()){
					data.item.initExpandCompAttri();
					(c as ASComponent).borderColor = ColorUtils.red;
				}
			}else if(c is AbstractASText){
				AbstractASText(target).text = "textField";
			}else if(c is ASLoader){
				(c as ASLoader).showUIEditIcon();
			}
			
			_addInit();
		}
		
		public function addCompFormXML(c:ASComponent):void
		{
			target = c;
			var parent_nm:String = data.getAttri("parent");
			if(parent_nm == "stage"){
				parent = uiShowContainer.cache.tree;	
			}else{
				parent = uiShowContainer.cache.findCompById(parent_nm);
			}
			if(parent == null){
				SandyError.error("not find the parent,"+parent_nm);
			}
			data.proxy = this;
						
			var elements:Array = data.attriObj;
			var key:String;
			for(key in elements){
				if(!StringTWLUtil.isWhitespace(key)){
					if(target.hasOwnProperty(key)){
						if(checkSetTargetAttri(key)){
							if(!setTargetAttri(key,elements[key])){
								target[key] = elements[key];
							}
						}
					}
				}
			}
			
			if(c is ASContainer || checkIsMultView()){
				(c as ASComponent).showBorderInUIEdit();
				if(data.item.isExpandComp()){
					(c as ASComponent).borderColor = ColorUtils.red;
				}
			}
			
			initCompAttri()
			_addInit(false);
			
			if(!isStageComp && parentComp!=null){
				parentComp.addChild(target);
			}
		}
		
		private function checkSetTargetAttri(key:String):Boolean
		{
			if(key == "parent") return false;
			return true;
		}
		
		private function _addInit(_reflash:Boolean=true):void
		{
			target.mouseEnabled = true;
			target.mouseChildren = false;
			
			target.showBorderInUIEdit();
			
			target.addEventListener(MouseEvent.MOUSE_DOWN , onMouseDown,false,10000);
			target.addEventListener(MouseEvent.MOUSE_UP , onMouseUp);
			target.addEventListener(MouseEvent.RIGHT_CLICK,targetRightClick);
			
			node = new UITreeNode();
			node.obj = this;
			node.name = name;
			node.branch = parent;
			node.id = target.uid;
			uiShowContainer.cache.addComp(node,_reflash);
			
			_addInit2()
		}
		
		private function _addInit2():void
		{
			if(checkIsMultView()){
				target.removeAllChildren();
				if(data.compAttriItem == null) return ;
				var s:String = data.compAttriItem.attri_ls[CreateUIFileCompAttri.tabNav_url];
				var ss:String = data.compAttriItem.attri_ls[CreateUIFileCompAttri.tabNav_label];
				if(!StringTWLUtil.isWhitespace(s)){
					var a:Array = s.split(",") as Array;
					var aa:Array = ss.split(",") as Array;
					if(a!=null){
						for(var i:int=0;i<a.length;i++){
							var box:TabNavViewBox = new TabNavViewBox();
							box.label = aa[i];
							box.fileURL = a[i];
							target.addChild(box);
						}
					}
				}
			}
		}
		
		private function targetRightClick(e:MouseEvent):void
		{
			e.stopImmediatePropagation();
			e.preventDefault();
			UIEditManager.getInstance().openRightMenu(this);
		}
		
		public function get name():String
		{
			if(target == null) return "";
			return data.name+"/id:"+target.$id+"/name:"+target.name+"/index:"+index;
		}
		
		public function get toolTip():String
		{
			if(target == null) return "";
			return target.toolTip;
		}
		
		public function get index():int
		{
			if(target == null) return 0;
			if(target.parent == null) return 0;
			return target.parent.getChildIndex(target);
		}
		
		public function get x():Number
		{
			return target.x;
		}
		
		public function get y():Number
		{
			return target.y;
		}
		
		//每次鼠标点击都会刷新
		private function initCompAttri():void
		{
			setAttri("uid",target.uid);
			setAttri("alpha",target.alpha);
			setAttri("x",target.x);
			setAttri("y",target.y);
			setAttri("width",target.width);
			setAttri("height",target.height);
		}
		
		public function getLoc():SandyPoint
		{
			return new SandyPoint(target.x,target.y);
		}
		
		private var pre_loc:SandyPoint ;
		private function onMouseDown(e:MouseEvent):void
		{
			if(target == null) return ;
			if(e.shiftKey){
				//多选
				iManager.sendAppNotification(UIEvent.selectUI_inUI_event,null);
				ComAlignCell.instance.showSelectComp(true,false);
				ComAlignCell.instance.addSelectComp(this);
				target.showBorderInUIEdit(true,ColorUtils.red);
				return ;
			}
			ComAlignCell.instance.showSelectComp(false);
			UIEditManager.currEditShowContainer.setTransToolTarget(this);
		}
		
		private function onMouseUp(e:Event):void
		{
			if(target == null) return ;
			if(UIEditManager.currEditShowContainer.selectedUI == this){
				if(ComAlignCell.instance.actionIsOpen) return ;
				reflashCompAttri();
			}
		}
		
		public function reflashCompAttri():void
		{
			initCompAttri();
			var curr:SandyPoint = new SandyPoint(target.x,target.y);
			if(!SandyPoint.equalsPoint(curr,pre_loc)){
				if(uiShowContainer.selectedUI == this){
					UIEditManager.currEditShowContainer.dispatchTarget(this);
				}else{
					UIEditManager.currEditShowContainer.setTransToolTarget(this);
				}
			}
		}
		
		private function setTargetAttri(key:String,v:*):Boolean
		{
			if(target.hasOwnProperty(key)){
				if(v == "true"){
					target[key] = true;
					return true
				}else if(v == "false"){
					target[key] = false;
					return true
				}else if(key == "inventedGroup"){
					var pre_g:String = getAttri("inventedGroup");
					if(!StringTWLUtil.isWhitespace(pre_g) && uiShowContainer.cache.getInvertedGroup(pre_g)!=null){
						uiShowContainer.cache.getInvertedGroup(pre_g).boxGroup.removeChild(target);
					}
					if(v is InvertedGroupVO){
						target.inventedGroup = InvertedGroupVO(v).boxGroup;
					}else{
						if(!StringTWLUtil.isWhitespace(v)){
							var gv:InvertedGroupVO = uiShowContainer.cache.getInvertedGroup(v);
							if(gv!=null){
								target.inventedGroup = gv.boxGroup;
							}else{
								target.inventedGroup = null;
							}
						}else{
							target.inventedGroup = null;
						}
					}
					return true;
				}else if(CreateCSSFileItemVO.isFilters(key)){
					target.filters = CreateCSSFileItemVO.convertToFilterArray(v);
					return true
				}
			}else if(key == "info"){
				//也是组件的注释
				target.toolTip = v;
			}
			return false;
		}
		
		//刷新组件的样式
		public function reflashRender(d:ComBase,reflash:Boolean=true):void
		{
			var vo:IComBaseVO = d.getValue();
			if(vo == null) return ;
			var v:* = vo.value;
			if(reflash){
				if(vo.key == "id" || vo.key == "name"){
					reflash = true;
				}else{
					reflash = false;
				}
			}
			
			reflashAttri(d.item.key,v);
			
			if(reflash){
				reflashUIEditor()
			}
		}
		
		public function reflashUIEditor():void
		{
			UIEditManager.currEditShowContainer.cache.reflashTreeNodeInitAttri();
			//刷新组件大纲
			UIEditCache.reflashCompOutline();
			//重新选中
			selectedThis();
		}
		
		public function reflashAttri(key:String,v:*):void
		{
			var _setAttri:Boolean = setTargetAttri(key,v);
			var _addToCache:Boolean=true;
			
			if(!_setAttri){
				if(target.hasOwnProperty(key)){
					if(key == "styleName"){
						addToStyleManager(v);
						_addToCache =false
					}else if(key == "parent"){
						if(v is UITreeNode){
							if(UITreeNode(v).obj is UIShowContainer){
								UIShowContainer(UITreeNode(v).obj).swapToAddChild(this);
								setAttri(key,"stage");
								return ;
							}else{
								UIShowCompProxy(UITreeNode(v).obj).addChild(this);
								setAttri(key,UIShowCompProxy(UITreeNode(v).obj).target.id);
							}
						}
						_addToCache = false
					}else if(key == "source"){
						if(String(v).indexOf("/")!=-1 || String(v).indexOf(File.separator)!=-1){
							target[key] = ProjectCache.getInstance().getProjectOppositePath(String(v));		
						}else{
							target[key] = v;
						}
					}else if(key == "play"){
						if(target is ASAssetsSymbol){
							(target as ASAssetsSymbol).playAll();
						}
						return ;
					}else if(key == "stop"){
						if(target is ASAssetsSymbol){
							(target as ASAssetsSymbol).stopAll();
						}
						return ;
					}else{
						target[key] = v;
					}
				}
			}
			
			//保存组件的属性
			if(_addToCache){
				if(v is InvertedGroupVO){
					setAttri(key,InvertedGroupVO(v).id);	
				}else{
					setAttri(key,v);
				}
			}
		}
		
		public function setAttri(key:String,v:*):void
		{
			data.setAttri(key,v);
		}
		
		public function createEventCode():String
		{
			var evt:String = getAttri("event");
			if(!StringTWLUtil.isWhitespace(evt)){
				var s:String = "";
				var uiid:String = getAttri("id");
				if(StringTWLUtil.isWhitespace(uiid)) return "";
				s += "public"+createSpace()+"function"+createSpace()+"reactTo"+StringTWLUtil.setFristUpperChar(uiid)+StringTWLUtil.setFristUpperChar(evt)+"(e:*=null):void"+NEWLINE_SIGN;
				s += "{"+NEWLINE_SIGN;
				s += createSpace()+NEWLINE_SIGN;
				s += "}"+NEWLINE_SIGN;
				return s;
			}
			return "";
		}
		
		private function get NEWLINE_SIGN():String
		{
			return StringTWLUtil.NEWLINE_SIGN
		}
		
		private function createSpace(n:int=1):String
		{
			return StringTWLUtil.createSpace_en(n)
		}
		
		public function reflashCompIndex():void
		{
			setAttri("index",index);
		}
		
		public function selectedThis():void
		{
			UIEditManager.currEditShowContainer.setTransToolTarget(null,false);
			UIEditManager.currEditShowContainer.setTransToolTarget(this);
		}
		
		private function addToStyleManager(v:*):void
		{
			var styleName2:String = v;
			if(v is File){
				var fl:File = v as File;
				if(fl == null){
					data.setAttri("styleName","");
					target.styleName = null;
					return ;
				}
				var d:SandyStyleNameData = CreateUIFile.parserStyleName(fl);
				if(d == null){
					data.setAttri("styleName","");
					target.styleName = null;
					SandyManagerBase.getInstance().showError("没有找到样式:"+fl.nativePath);
					return ;
				}
				styleName2 = d.styleName;
			}
			target.styleName = styleName2
			data.setAttri("styleName",styleName2);
		}
		
		public function addChild(ui:UIShowCompProxy):void
		{
			if(target.containChild(ui.target)) return ;
			if(target.parent.name != "UIShowContainer_content"){
				UIEditManager.uiEditor.logCont.addLog("只允许向下有一层的容器");
			}
			
			//init
			ui.target.x = 0;
			ui.target.y = 0;
			setAttri("x",0);
			setAttri("y",0);
			//删除原来的
			ui.node.branch.removeItem(ui.node);
			//添加到现在的
			ui.parent = node;
			node.addItem(ui.node);
			target.addChild(ui.target);
			
			_addInit2()
			
			UIEditCache.reflashCompOutline();
			selectedThis();
		}
		
		public function removeChild(ui:DisplayObject):void
		{
			
		}
		
		public function getAttri(key:String):*
		{
			return data.getAttri(key);
		}
		
		public static var addTab_index:int;
		
		public function tabNav_addTab():void
		{
			if(target is ASTabNavigator){
				var box:TabNavViewBox = new TabNavViewBox();
				box.label = "tab"+ (++addTab_index);
				ASTabNavigator(target).addChild(box);
			}else if(target is ASViewStack){
				box = new TabNavViewBox();
				box.label = "view"+ (++addTab_index);
				ASViewStack(target).addStack(box);
			}
		}
		
		public function tabNav_removeTab(lb:String):void
		{
			if(target is ASTabNavigator){
				var n:int = ASTabNavigator(target).getTabLength();
				for(var i:int=0;i<n;i++){
					if(ASComponent(ASTabNavigator(target).getViewByIndex(i)).label == lb){
						ASTabNavigator(target).removeChildAt(i);
						break;
					}
				}
			}else if(target is ASViewStack){
				n = ASViewStack(target).numChildren;
				for(i=0;i<n;i++){
					if(ASComponent(ASViewStack(target).getChildAt(i)).label == lb){
						ASViewStack(target).removeChildAt(i);
						break;
					}
				}
			}
		}
		
		protected function get iManager():SandyEngineManagerPool
		{
			return SandyEngineGlobal.iManager;
		}
	}
}