package com.editor.module_roleEdit.pop
{
	import	com.sandy.component.air.*;
	import	com.gdps.components.container.*;
	import	com.gdps.components.text.*;
	import flash.events.*;
	import flash.display.*;
	import flash.geom.*;
	import flash.utils.*;
	import com.rpg.utils.*;

	public class AppUploadSwfSystemTipWin extends SandyWindow
	{
		public function AppUploadSwfSystemTipWin()
		{
			super()
			create_init()
		}


		public var txt:GdpsRichText;

		//程序生成
		private function create_init():void
		{

			//主文件的属性
			this.width=300
			this.height=300
			this.addEventListener('creationComplete',function(e:*):void{create();});

			txt = new GdpsRichText();
			txt.id="txt"
			txt.percentWidth=100
			txt.left=10
			txt.top=20
			txt.right=10
			this.addChild(txt);

			//dispatchEvent creationComplete
			initComplete();
		}

		//原始文件里的script
			
			private function create():void
			{
				txt.setHtmlText(label)
				move(Capabilities.screenResolutionX-320,Capabilities.screenResolutionY-400)
			}
			
		
	}
}