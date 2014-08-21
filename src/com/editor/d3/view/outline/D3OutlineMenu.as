package com.editor.d3.view.outline
{
	import com.editor.d3.cache.D3ComponentConst;
	import com.editor.d3.cache.D3ComponentProxy;
	import com.editor.d3.cache.D3ProjectCache;
	import com.editor.d3.cache.data.D3TreeNode;
	import com.editor.d3.vo.comp.D3CompItemVO;
	import com.editor.modules.proxy.AppModuleProxy;
	import com.editor.vo.global.AppMenuConfig;
	import com.sandy.asComponent.controls.interfac.IASMenuButton;
	import com.sandy.component.expand.data.SandyMenuData;
	import com.sandy.event.SandyExternalEvent;
	import com.sandy.manager.SandyManagerBase;
	import com.sandy.utils.ToolUtils;
	
	import flash.filesystem.File;

	public class D3OutlineMenu extends SandyManagerBase
	{
		private static var instance:D3OutlineMenu ;
		public static function getInstance():D3OutlineMenu{
			if(instance == null){
				instance =  new D3OutlineMenu();
			}
			return instance;
		}
		
		private var act_xml:XML = <menuitem label="功能" data="-4">
										<menuitem label="删除" data="100"/>
										<menuitem label="剪切" data="101"/>
										<menuitem label="复制" data="103"/>
										<menuitem label="黏贴" data="102"/>
									</menuitem>
		
		
			
		//打开右键菜单
		//outline
		public function openRightMenu(f:D3TreeNode,fromFile:Boolean):void
		{
			D3ProjectCache.disabledDataChange = false;
			var a:Array = [];
			var x:XML = <root/>;
			if(f.object!=null){
				if(f.object.group == D3ComponentConst.comp_group1 ||
					f.object.group == D3ComponentConst.comp_group5){
					x = ToolUtils.originalClone(AppMenuConfig.instance.outlineMenu_xml);
				}
			}else{
				x = ToolUtils.originalClone(AppMenuConfig.instance.outlineMenu_xml);
			}
			x.appendChild(act_xml);
			
			var dat:SandyMenuData = new SandyMenuData();
			dat.xml  		= XML(x);
			dat.click_f  	= onMenuHandler;
			dat.data 		= f;
			iManager.sendAppNotification(SandyExternalEvent.open_system_menu_event ,dat);
		}
		
		private function onMenuHandler(btn:IASMenuButton):void
		{
			var evt:XML = btn.getMenuXML()
			var f:D3TreeNode = btn.getMenuData();
			var d:int = int(evt.@data);
			
			var dd:D3CompItemVO = D3ComponentProxy.getInstance().com_ls.getItemById(d);
			if(d == 100){
				get_D3OutlinePopViewMediator().delFile(btn.getMenuData());
				return ;
			}else if(d == 101){
				f.cut();
				return ;
			}else if(d == 102){
				f.paste();
				return ;
			}else if(d == 103){
				
				return ;
			}
			
			get_D3OutlinePopViewMediator().popButtonChange(dd);
		}
		
		private function get_D3OutlinePopViewMediator():D3OutlinePopViewMediator
		{
			return iManager.retrieveMediator(D3OutlinePopViewMediator.NAME) as D3OutlinePopViewMediator;
		}
		
		private function get_AppModuleProxy():AppModuleProxy
		{
			return iManager.retrieveProxy(AppModuleProxy.NAME) as AppModuleProxy 
		}
		
		private function get_AppMenuConfigProxy():AppMenuConfig
		{
			return AppMenuConfig.instance;
		}
	}
}