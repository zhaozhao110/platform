package com.editor.d3.view.particle.prop.material
{
	import com.air.io.SelectFile;
	import com.air.io.WriteFile;
	import com.editor.component.containers.UIHBox;
	import com.editor.component.controls.UIButton;
	import com.editor.component.controls.UILabel;
	import com.editor.component.controls.UIText;
	import com.editor.d3.cache.D3ComponentProxy;
	import com.editor.d3.cache.D3ProjectCache;
	import com.editor.d3.cache.D3ProjectFilesCache;
	import com.editor.d3.view.attri.com.D3ComBase;
	import com.editor.d3.view.attri.com.D3ComBaseVO;
	import com.editor.d3.view.particle.ParticleAttriCellBase;
	import com.editor.d3.vo.particle.SubPropObj;
	import com.editor.event.AppEvent;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.net.FileFilter;

	public class PropTextureMater extends ParticleAttriCellBase
	{
		public function PropTextureMater()
		{
			super();
		}
		
		public var cell:PropMaterialCell;
		
		override protected function create_init():void
		{
			super.create_init();
			
			var b:Array = D3ComponentProxy.getInstance().particle_group_ls.getItem(4).expend1.split(",");
			var a:Array = D3ComponentProxy.getInstance().particle_attri_ls.getArray(b);
			createCompByGroup(a);
			
			var h:UIHBox = new UIHBox();
			h.verticalAlignMiddle = true;
			h.height = 25;
			h.percentWidth = 100;
			addChild(h);
			
			var lb:UILabel = new UILabel();
			lb.text = "texture:"
			h.addChild(lb);
			lb.width = 110;
			
			openBtn = new UIButton();
			openBtn.label = "选择图片"
			h.addChild(openBtn);
			openBtn.addEventListener(MouseEvent.CLICK ,onOpen);
			
			var preBtn:UIButton = new UIButton();
			preBtn.label = "预览图片"
			h.addChild(preBtn);
			preBtn.addEventListener(MouseEvent.CLICK ,onPre);
			
			pathTI = new UIText();
			pathTI.width = 250;
			pathTI.text = ""
			addChild(pathTI);
		}
		
		private var openBtn:UIButton;
		private var pathTI:UIText;
		
		private function onPre(e:MouseEvent):void
		{
			var f:File = new File(D3ProjectFilesCache.getInstance().addProjectResPath(pathTI.text))
			if(f == null) return ;
			sendAppNotification(AppEvent.preImage_event,f.nativePath);
		}
		
		private function onOpen(e:MouseEvent):void
		{
			var f:FileFilter = new FileFilter("texture", "*.jpg;*.png")
			SelectFile.select("texture",[f],result_f);
		}
		
		private function result_f(e:Event):void
		{
			var f:File = e.target as File;
			var newF:File;
			if(D3ProjectFilesCache.getInstance().getProjectFold() != null){
				newF = new File(D3ProjectFilesCache.getInstance().getProjectFold().nativePath+File.separator+"particle"+File.separator+"texture"+File.separator+f.name);
			}else{
				newF = f;
			}
			WriteFile.copy(f,newF);
			pathTI.text = D3ProjectFilesCache.getInstance().getProjectResPath(newF);
			
			saveObject()
		}
		
		override protected function comReflash(b:D3ComBase):void
		{
			var d:D3ComBaseVO = b.getValue();
			var k:String = b.key;
			saveObject();
		}
		
		override protected function getCompValue(d:D3ComBase):*
		{
			if(currAnimationData.data.material.id != "TextureMaterialSubParser") return null;
			var k:String = d.key;
			return currAnimationData.data.material.getAttri(k);
		}
		
		public function getObject():SubPropObj
		{
			var obj:SubPropObj = new SubPropObj();
			obj.id = "TextureMaterialSubParser"
			obj.data = {};
			for each(var d:D3ComBase in attri_ls){
				obj.data[d.key] = d.getValue().data;
			}
			obj.data.url = D3ProjectFilesCache.getInstance().addProjectResPath(pathTI.text);
			//obj.data.url = pathTI.text;
			return obj;
		}
		
		public function saveObject():void
		{
			if(cell.isReseting) return ;
			currAnimationData.data.material = null;
			currAnimationData.data.material = getObject();
		}
		
		override public function changeAnim():void
		{
			super.changeAnim();
			pathTI.text = "";
			var u:String = currAnimationData.data.material.getAttri("url");
			if(StringTWLUtil.isWhitespace(u)){
				pathTI.text = "";
			}else{
				try{
					var f:File = new File(u);
					if(f.exists){
						pathTI.text = D3ProjectFilesCache.getInstance().getProjectResPath(f);
					}
				}catch(e:Error){
					pathTI.text = "error:"+ u
				}
				//pathTI.text = u
			}
		}
		
	}
}