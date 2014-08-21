package com.editor.d3.pop.preMaterial
{
	import com.air.component.SandyAIRImage;
	import com.editor.component.containers.UICanvas;
	import com.editor.component.containers.UIVBox;
	import com.editor.component.controls.UIImage;
	import com.editor.component.controls.UILabel;
	import com.editor.d3.app.manager.D3SceneManager;
	import com.editor.d3.cache.D3DisplayListCache;
	import com.editor.d3.cache.D3ProjectCache;
	import com.editor.d3.cache.D3ProjectFilesCache;
	import com.editor.d3.object.D3Object;
	import com.editor.d3.object.base.D3ObjectBase;
	import com.editor.d3.tool.D3AIRImage;
	import com.sandy.asComponent.event.ASEvent;
	import com.sandy.asComponent.itemRenderer.ASListItemRenderer;
	import com.sandy.component.itemRenderer.SandyBoxItemRenderer;
	import com.sandy.utils.ColorUtils;
	import com.sandy.utils.FilterTool;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.utils.setTimeout;

	public class App3DPreMaterialWinItemRenderer extends SandyBoxItemRenderer
	{
		public function App3DPreMaterialWinItemRenderer()
		{
			super();
		
			create_init();
			
		}
		
		private var img:D3AIRImage;
		private var txt:UILabel;
		
		private function create_init():void
		{
			width = 75;
			height = 90 ;
			backgroundColor = 0x333333;
			
			img = new D3AIRImage();
			img.width = 75;
			img.height = 75;
			addChild(img);
			
			txt = new UILabel();
			addChild(txt);
			txt.width = 75;
			txt.color = ColorUtils.white;
			txt.textAlign = "center";
			txt.y = 76;
			
		}
		
		public function getBitmap():Bitmap
		{
			return img.content as Bitmap;
		}
		
		private var file:File;
		public var comp:D3ObjectBase;
		
		override public function poolChange(value:*):void
		{
			super.poolChange(value);
			
			file = value as File;
			//img.source = file;
			txt.text = file.name.split(".")[0];
			
			comp = D3SceneManager.getInstance().displayList.convertObject(file,false);
			
			var texture:String = comp.configData.getAttri("texture");
			if(!StringTWLUtil.isWhitespace(texture)){
				img.source = new File(D3ProjectFilesCache.getInstance().addProjectResPath(texture)); 
			}
		}
		
		override public function select():void
		{
			super.select();
			FilterTool.setGlow(this);
		}
		
		override public function noSelect():void
		{
			super.noSelect();
			this.filters = null;
		}
		
	}
}