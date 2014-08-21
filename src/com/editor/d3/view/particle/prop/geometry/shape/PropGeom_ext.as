package com.editor.d3.view.particle.prop.geometry.shape
{
	import com.air.io.SelectFile;
	import com.air.io.WriteFile;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UILabel;
	import com.editor.d3.cache.D3ProjectCache;
	import com.editor.d3.cache.D3ProjectFilesCache;
	import com.editor.d3.view.particle.ParticleAttriCellBase;
	import com.editor.d3.vo.attri.D3ComAttriItemVO;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.net.FileFilter;

	public class PropGeom_ext extends ParticleAttriCellBase
	{
		public function PropGeom_ext()
		{
			super();
			
			var h:UIHBox = new UIHBox();
			h.verticalAlignMiddle = true;
			h.height = 25;
			h.percentWidth = 100;
			addChild(h);
			
			var lb:UILabel = new UILabel();
			lb.text = "external model:"
			h.addChild(lb);
			lb.width = 110;
			
			openBtn = new UIButton();
			openBtn.label = "选择模型"
			h.addChild(openBtn);
			openBtn.addEventListener(MouseEvent.CLICK ,onOpen);
			
			pathTI = new UILabel();
			addChild(pathTI);
		}
		
		public var pathTI:UILabel;
		public var openBtn:UIButton;
		
		private function onOpen(e:MouseEvent):void
		{
			var f:FileFilter = new FileFilter("model", "*.3ds;*.obj")
			SelectFile.select("model",[f],result_f);
		}
		
		private function result_f(e:Event):void
		{
			var f:File = e.target as File;
			var newF:File = new File(D3ProjectFilesCache.getInstance().getProjectFold().nativePath+File.separator+"particle"+File.separator+"model"+File.separator+f.name);
			WriteFile.copy(f,newF);
			pathTI.text = D3ProjectFilesCache.getInstance().getProjectResPath(newF);
			
			saveObject()
		}
		
		public function getObject():Object
		{
			var obj:Object = {};
			obj.id = "ExternalShapeSubParser"
			obj.data = {};
			obj.data.url = pathTI.text
			return obj;
		}
		
		public function saveObject():void
		{
			currAnimationData.data.geometry.createShape(getObject());
		}
		
		override public function changeAnim():void
		{
			pathTI.text = currAnimationData.data.geometry.shape.getAttri("url");
		}
		
	}
}