package com.editor.module_gdps.pop.project
{
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UITile;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIImage;
	import com.editor.component.controls.UILabel;
	import com.editor.services.Services;
	
	import flash.desktop.NativeApplication;
	import flash.display.Screen;
	import flash.events.MouseEvent;

	public class LoginProjectPopwin extends UICanvas
	{
		public function LoginProjectPopwin()
		{
			super()
			create_init();
		}
		
		public var project_list:UITile;
		
		private function create_init():void
		{
			width = 500;
			height = 400;
			borderStyle = "solid";
			borderThickness = 1;
			borderColor = 0x898C95;
			backgroundColor = 0xEDEDED;
			visible = false;
			
			backgroundColor = 0xECECEC;
			
			var vb:UIVBox = new UIVBox();
			vb.verticalAlign = "middle";
			vb.horizontalAlign = "center";
			vb.verticalGap = 5;
			vb.horizontalGap = 2;
			vb.width = 500;
			vb.height = 400;
			addChild(vb);
			
			var tt:UILabel = new UILabel();
			tt.text = "项目选择";
			tt.width = 500;
			tt.textAlign = "center";
			tt.horizontalCenter = 0;
			tt.fontSize = 16;
			tt.bold = true;
			tt.color = 0x222222;
			vb.addChild(tt);
			
			var des:UILabel = new UILabel();
			des.text = "请在下列列表中选择您想进入的项目主页";
			des.width = 500;
			des.textAlign = "center";
			des.color = 0x323232;
			des.horizontalCenter = 0;
			vb.addChild(des);
			
			project_list = new UITile();
			project_list.width = 472;
			project_list.height = 332;
			project_list.padding = 10;
			project_list.color = 0xECECEC;
			project_list.verticalGap = 10;
			project_list.horizontalGap = 10;
			project_list.borderStyle = "solid";
			project_list.verticalScrollPolicy = "auto";
			project_list.horizontalScrollPolicy = "off";
			project_list.itemRenderer = LoginProjectItemRenderer;
			vb.addChild(project_list);
			
			var closeBtn:UIImage = new UIImage();
			closeBtn.buttonMode = true;
			closeBtn.width = 24;
			closeBtn.height = 24;
			closeBtn.right = 5;
			closeBtn.top = 5;
			closeBtn.source = Services.assets_fold_url + "img/close.png";
			closeBtn.toolTip = "关闭";
			closeBtn.addEventListener(MouseEvent.CLICK , onCloseBtnClick);
			this.addChild(closeBtn);
			
			initComplete();
		}
		
		override public function set visible(value:Boolean):void
		{
			if(value){
				engineEditor.instance.getNativeWindow().height=402;
				engineEditor.instance.getNativeWindow().width=502;
				engineEditor.instance.getNativeWindow().activate();
				engineEditor.instance.getNativeWindow().x = Screen.mainScreen.bounds.width/2-this.width/2;
				engineEditor.instance.getNativeWindow().y = Screen.mainScreen.bounds.height/2-this.height/2;
			}
			
			super.visible = value;
		}
		
		private function onCloseBtnClick(e:MouseEvent):void
		{
			NativeApplication.nativeApplication.exit();
		}
	}
}