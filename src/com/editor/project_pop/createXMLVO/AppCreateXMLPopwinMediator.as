package com.editor.project_pop.createXMLVO
{
	import com.air.io.SelectFile;
	import com.editor.component.containers.UIDataGrid;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UITabBar;
	import com.editor.component.controls.UITextInput;
	import com.editor.modules.cache.ProjectCache;
	import com.editor.view.popup.AppDestroyPopupwinMediator;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.net.FileFilter;

	public class AppCreateXMLPopwinMediator  extends AppDestroyPopupwinMediator
	{
		public static const NAME:String = "AppCreateXMLPopwinMediator"
		public function AppCreateXMLPopwinMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		public function get createWin():AppCreateXMLPopwin
		{
			return viewComponent as AppCreateXMLPopwin
		}
		public function get pathButton():UIButton
		{
			return createWin.pathButton;
		}
		public function get pathForm():UITextInput
		{
			return createWin.pathForm;
		}
		public function get nameForm():UITextInput
		{
			return createWin.ti;
		}
		public function get tabBar():UITabBar
		{
			return createWin.tabBar;
		}
		public function get dg():UIDataGrid
		{
			return createWin.dg;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			tabBar.addEventListener(ASEvent.CHANGE,onTabBarChange)
			dg.addEventListener(ASEvent.CHANGE,onDataGridChange);
			nameForm.toolTip = "系统将会在"+ProjectCache.getInstance().getVOPath()+"该目录下生成";
			createWin.insertBtn.addEventListener(MouseEvent.CLICK , insertHandle);
		}
		
		public function reactToPathButtonClick(e:MouseEvent):void
		{
			var txtFilter:FileFilter = new FileFilter("xml", "*.xml");
			SelectFile.select("xml",[txtFilter],onREsult)
		}
		
		private var paser:ParserXMLVOTool;
		
		private function onREsult(e:Event):void
		{
			var fl:File = e.target as File;
			pathForm.text = fl.nativePath;
			nameForm.text = fl.name.split(".")[0];
			
			paser = new ParserXMLVOTool();
			ParserXMLVOTool.instance = paser;
			paser.parser(fl);
			var a:Array = [];
			if(paser.g_obj!=null){
				a.push("group");
			}
			if(paser.i_obj!=null){
				a.push("item");	
			}
			tabBar.dataProvider = a;
			tabBar.selectedIndex = 0;
		}
		
		private function onTabBarChange(e:ASEvent):void
		{
			var s:String = String(tabBar.selectedItem);
			if(s == "group"){
				dg.dataProvider = paser.getGroup();
			}else if(s == "item"){
				dg.dataProvider = paser.getItem();
			}
		}
		
		private function onDataGridChange(e:ASEvent):void
		{
			var obj:Object = dg.selectedItem;
		}
		
		override protected function okButtonClick():void
		{
			if(StringTWLUtil.isWhitespace(nameForm.text)){
				return ;
			}
			
			var c:CreateXMLVOTool = new CreateXMLVOTool();
			c.create(pathForm.text,nameForm.text);
			closeWin();
		}
		
		private function insertHandle(e:MouseEvent):void
		{
			var s:String = createWin.text.text;
			if(StringTWLUtil.isWhitespace(s)) return ;
			var b:Array = dg.dataProvider as Array;
			var a:Array = StringTWLUtil.splitNewline(s);
			for(var i:int=0;i<a.length;i++)
			{
				var ss:String = a[i];
				if(!StringTWLUtil.isWhitespace(ss)){
					var aa:Array = [];
					if(ss.indexOf(":")!=-1){
						aa = ss.split(":");
					}else if(ss.indexOf("：")!=-1){
						aa = ss.split("：");
					}
					var k:String = StringTWLUtil.trim(aa[0]);
					var v:String = StringTWLUtil.trim(aa[1]);
					for(var j:int=0;j<b.length;j++)
					{
						var d:PaserXMLVO = b[j] as PaserXMLVO;
						if(d.xml == k){
							d.vo = k;
							d.info = v;
						}
					}
				}
			}
			
			s = String(tabBar.selectedItem);
			if(s == "group"){
				dg.dataProvider = paser.getGroup();
			}else if(s == "item"){
				dg.dataProvider = paser.getItem();
			}
			
			createWin.textCan.visible = false;
		}
		
	}
}