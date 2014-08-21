package com.editor.module_ui.ui
{
	import com.air.net.CallCMDProccess;
	import com.editor.module_ui.app.css.CSSEditor;
	import com.editor.module_ui.app.ui.UIEditor;
	import com.editor.module_ui.view.uiAttri.ComAttriCell;
	import com.editor.module_ui.view.uiAttri.ComSystemAttriCell;
	import com.editor.module_ui.view.uiAttri.com.ComBase;
	import com.editor.module_ui.vo.ComponentData;
	import com.editor.module_ui.vo.component.ComItemVO;
	import com.editor.proxy.AppComponentProxy;
	import com.sandy.SandyEngineGlobal;
	import com.sandy.asComponent.ASComponentInitialize;
	import com.sandy.asComponent.controls.ASButton;
	import com.sandy.asComponent.controls.ASCheckBox;
	import com.sandy.asComponent.controls.ASComboBox;
	import com.sandy.asComponent.controls.ASLabel;
	import com.sandy.asComponent.controls.ASTextArea;
	import com.sandy.asComponent.controls.interfac.IASMenuButton;
	import com.sandy.asComponent.core.ASComponent;
	import com.sandy.asComponent.core.AbstractASText;
	import com.sandy.component.expand.data.SandyMenuData;
	import com.sandy.core.SandyEngineManagerPool;
	import com.sandy.event.SandyExternalEvent;
	import com.sandy.manager.SandyManagerBase;
	import com.sandy.math.SandyPoint;
	import com.sandy.popupwin.data.OpenMessageData;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	public class UIEditManager extends SandyManagerBase
	{
		private static var instance:UIEditManager ;
		public static function getInstance():UIEditManager{
			if(instance == null){
				instance =  new UIEditManager();
				instance.startCMD()
			}
			return instance;
		}
		
		public static var currEditShowContainer:UIShowContainer;
		public static var uiEditor:UIEditor;
		public static var currShowUIAttri:ComAttriCell;
		public static var cssEditor:CSSEditor;
		
		/**获取实例 */ 
		public static function getUIComponent(nm:String):ASComponent
		{
			var ui:ASComponent;
			var cl:Class;
			try{
				cl = getDefinitionByName( ASComponentInitialize.getClassPath("AS"+nm) ) as Class;
			}catch(e:Error){
				
			}
			ui = new cl() as ASComponent;
			var item:ComItemVO = AppComponentProxy.instance.com_ls.getItemByName(nm);
			if(item.size!=null){
				ui.width = item.size.width;
				ui.height = item.size.height;
			}else{
				trace("add component ui at:",nm,"noSize")
			}
			return ui as ASComponent;
		}
		
		private static var menu_xml:XML = <root>
												<menuitem label="变形" data="8" tip="拉伸和移动"/>
												<menuitem label="复制" data="7" tip="本窗口中的复制"/>
												<menuitem label="全局复制" data="9" tip="不同窗口之间的复制"/>
  												<menuitem label="只显示该组件" data="2"/>
												<menuitem label="上移一层" data="3"/>
												<menuitem label="下移一层" data="4"/>
												<menuitem label="最上层" data="5"/>
												<menuitem label="最下层" data="6"/>
												<menuitem label="删除" data="1"/>
											</root>
		
		public function openRightMenu(file:UIShowCompProxy):void
		{
			if(file == null) return ;
			
			var clone_menu_xml:XML = menu_xml.copy();
			/*if(checkShowCopy(file.target)){
				clone_menu_xml.appendChild();
			}*/
			
			var n_xml:XML = <menuitem />
			n_xml.@label = "name:"+file.target.name;
			n_xml.@data = 100;
			clone_menu_xml.appendChild(n_xml);
			
			n_xml = <menuitem />
			n_xml.@label = "id:"+file.target.$id
			n_xml.@data = 101;
			clone_menu_xml.appendChild(n_xml);
			
			n_xml = <menuitem />
			n_xml.@label = "type:"+file.data.name;
			n_xml.@data = 100;
			clone_menu_xml.appendChild(n_xml);
			
			var dat:SandyMenuData = new SandyMenuData();
			dat.xml  		= clone_menu_xml
			dat.click_f  	= onMenuHandler;
			dat.data 		= file
			iManager.sendAppNotification(SandyExternalEvent.open_system_menu_event ,dat);
		}
		
		public function checkShowCopy(target:ASComponent):Boolean
		{
			if(target is ASButton || target is AbstractASText || target is ASTextArea
				|| target is ASCheckBox || target is ASComboBox){
				return true
			}
			return false;
		}
		
		private function onMenuHandler(btn:IASMenuButton):void
		{
			var evt:XML = btn.getMenuXML()
			var args:UIShowCompProxy = btn.getMenuData() as UIShowCompProxy;
						
			if(evt.@data == "1"){ 
				delComp(args);
			}else if(evt.@data == "2"){
				UIEditManager.currEditShowContainer.cache.hideAllComp(args);
			}else if(evt.@data == "3"){
				UIEditManager.currEditShowContainer.selectedUI.target.swapToUpLevel();
			}else if(evt.@data == "4"){
				UIEditManager.currEditShowContainer.selectedUI.target.swapToDownLevel();
			}else if(evt.@data == "5"){
				UIEditManager.currEditShowContainer.selectedUI.target.swapToTop();
			}else if(evt.@data == "6"){
				UIEditManager.currEditShowContainer.selectedUI.target.swapToBottom();
			}else if(evt.@data == "7"){
				copyUI(args);
			}else if(evt.@data == "8"){
				UIEditManager.currEditShowContainer.setTransformTool(args);
			}else if(evt.@data == "9"){
				globalCacheUI(args);
			}
		}
		
		private function globalCacheUI(args:UIShowCompProxy):void
		{
			UIEditCache.addCacheUI(args);
			ComSystemAttriCell.instance.reflashCacheVBox();
		}
		
		public function globalParse(args:UIShowCompProxy):void
		{
			if(args == null) return ;
			var m:OpenMessageData = new OpenMessageData();
			m.info = "您确定要从缓存中新建ID为:"+args.target.id+"的组件？"
			m.okFunction = _globalParse;
			m.okFunArgs = {global:1,data:args};
			iManager.iPopupwin.showConfirm(m);
		}
		
		private function _globalParse(obj:Object):Boolean
		{
			var args:UIShowCompProxy = obj.data;
			var pt:SandyPoint = args.getLoc();
			if(int(obj.global)==0){
				pt.x += 30;
				pt.y += 30;
			}
			var db:ComponentData = (args.target.data as ComponentData).cloneObject()
			db.setAttri("parent","stage");
			var clone_ui:UIShowCompProxy = currEditShowContainer.addComp(db,false,pt);
			for(var i:int=0;i<clone_ls.length;i++){
				var attr_key:String = clone_ls[i];
				if(Object(args.target).hasOwnProperty(attr_key) && !StringTWLUtil.isWhitespace(args.target[attr_key])){
					clone_ui.reflashAttri(attr_key,args.target[attr_key]);	
				}
			}
			clone_ui.reflashUIEditor();	
			return true;
		}
		
		public function copyUI(args:UIShowCompProxy):void
		{
			var m:OpenMessageData = new OpenMessageData();
			m.info = "您确定要复制ID为:"+args.target.id+"的组件？"
			m.okFunction = _globalParse;
			m.okFunArgs = {global:0,data:args};
			iManager.iPopupwin.showConfirm(m);
		}
		
		public static const clone_ls:Array = ["label","styleName",
												"scaleX","scaleY",
												"width","height",
												"text","textAlign","fontSize",
												"rotation","alpha","color"];
		
		public function delComp(args:UIShowCompProxy):void
		{
			var w:OpenMessageData = new OpenMessageData();
			w.info = "您确定删除"+args.target.id+"该组件吗?,并且会删除所有子组件!"
			w.okFunction = confirmDel;
			w.okFunArgs = args;
			iManager.iPopupwin.showConfirm(w);
		}
		
		private function confirmDel(p:UIShowCompProxy):Boolean
		{
			currEditShowContainer.removeComp(p);
			return true;
		}
		
		
		private static const attri_xml:XML = <root>
														<menuitem label="删除" data="1"/>
													</root>
		
		public function openAttriCellRightMenu(base:ComBase):void
		{
			var dat:SandyMenuData = new SandyMenuData();
			dat.xml  		= attri_xml
			dat.click_f  	= onMenuHandler2;
			dat.data 		= base
			iManager.sendAppNotification(SandyExternalEvent.open_system_menu_event ,dat);
		}
		
		private function onMenuHandler2(btn:IASMenuButton):void
		{
			var evt:XML = btn.getMenuXML()
			var args:ComBase = btn.getMenuData() as ComBase;
			
			if(evt.@data == "1"){ 
				delCompAttri(args);
			}
		}
		
		private function delCompAttri(args:ComBase):void
		{
			var w:OpenMessageData = new OpenMessageData();
			w.info = "您确定删除"+args.key+"属性吗?"
			w.okFunction = confirmDel2;
			w.okFunArgs = args;
			iManager.iPopupwin.showConfirm(w);
		}
		
		private function confirmDel2(p:ComBase):Boolean
		{
			UIEditManager.currEditShowContainer.cache.removeExpandCompAttri(p.key,UIEditManager.currEditShowContainer.selectedUI.data.name);
			UIEditManager.currEditShowContainer.selectedUI.selectedThis();
			return true;
		}
		
		public function writeCmd(s:String):void
		{
			cmd.write(s);
		}
		
		private var cmd:CallCMDProccess;
		public function startCMD():void
		{
			if(cmd == null){
				cmd = new CallCMDProccess();
				cmd.start();
			}
		}
		
	}
}