package com.editor.module_gdps.login
{
	import com.air.popupwin.data.AIRPopOptions;
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UICheckBox;
	import com.editor.component.controls.UICombobox;
	import com.editor.component.controls.UIForm;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UITextInput;
	import com.editor.mediator.AppProjectMediator;
	import com.editor.model.OpenPopwinData;
	import com.editor.model.PopupwinSign;
	import com.editor.module_gdps.pop.project.LoginProjectPopwin;
	import com.editor.view.preloader.AppPreLoaderContainerMediator;
	import com.sandy.popupwin.data.OpenPopByAirOptions;
	
	import flash.desktop.NativeApplication;
	import flash.display.NativeWindowType;
	import flash.display.Screen;
	import flash.events.MouseEvent;

	public class GDPSLoginPopwin extends UICanvas
	{
		public function GDPSLoginPopwin()
		{
			super();
			create_init();
		}		
		
		public var loginCell:GdpsLoginCell;
		public var projectCell:LoginProjectPopwin;
		
		private function create_init():void
		{
			width = 500;
			height = 400;
			
			loginCell = new GdpsLoginCell();
			this.addChild(loginCell);
			
			projectCell = new LoginProjectPopwin();
			this.addChild(projectCell);
			
			initComplete();
		}
		
		override public function set visible(value:Boolean):void
		{
			super.visible = value;
			if(value){
				loginCell.visible = true;
			}
		}
	}
}