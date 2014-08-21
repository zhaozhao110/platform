package com.editor.d3.process
{
	import away3d.materials.ColorMaterial;
	import away3d.materials.MaterialBase;
	import away3d.materials.TextureMaterial;
	import away3d.materials.methods.EffectMethodBase;
	import away3d.utils.Cast;
	
	import com.air.io.FileUtils;
	import com.air.io.ReadFile;
	import com.air.io.WriteFile;
	import com.editor.d3.app.manager.D3SceneManager;
	import com.editor.d3.cache.D3ComponentConst;
	import com.editor.d3.cache.D3ComponentProxy;
	import com.editor.d3.cache.D3DisplayListCache;
	import com.editor.d3.cache.D3ProjectCache;
	import com.editor.d3.cache.D3ProjectFilesCache;
	import com.editor.d3.cache.D3ResChangeProxy;
	import com.editor.d3.cache.data.D3ResData;
	import com.editor.d3.event.D3Event;
	import com.editor.d3.object.D3Object;
	import com.editor.d3.object.D3ObjectMaterial;
	import com.editor.d3.object.D3ObjectMethod;
	import com.editor.d3.object.D3ObjectTexture;
	import com.editor.d3.pop.preList.App3DPreListWin;
	import com.editor.d3.pop.preTexture.App3DPreTextureWin;
	import com.editor.d3.process.base.D3CompProcessBase;
	import com.editor.d3.tool.D3ReadFile;
	import com.editor.d3.tool.D3ReadImage;
	import com.editor.d3.tool.D3WriteFile;
	import com.editor.d3.view.attri.ID3ComBase;
	import com.editor.d3.view.attri.com.D3ComBase;
	import com.editor.d3.view.attri.com.D3ComBaseVO;
	import com.editor.d3.view.attri.com.D3ComFile;
	import com.editor.d3.view.attri.preview.MaterialPreview;
	import com.editor.d3.vo.attri.D3ComAttriItemVO;
	import com.sandy.math.HashMap;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.filesystem.File;

	//材质，直接修改数据
	public class D3ProccessMaterial extends D3CompProcessBase
	{
		public function D3ProccessMaterial(d:D3ObjectMaterial)
		{
			super(d);
		}
		
		override public function get compType():int
		{
			return D3ComponentConst.comp_group4;
		}
		
		override public function get suffix():String
		{
			return D3ComponentConst.sign_1;
		}
		
		override public function comReflash(d:ID3ComBase):void
		{
			super.comReflash(d);
			
			var dd:D3ComBaseVO = d.getValue();
			if(d.key == "name"){
				changeName(d,dd);
				saveAttri(d,dd);
				reflashAttriNow();
				reflashLeftTree();
			}else if(d.item.expand == "method"){
				var md:D3ObjectMethod = new D3ObjectMethod(comp.fromUI);
				md.parentObject = comp;
				md.readObject();
				md.compItem = Object(dd.data).cloneObject();
				comp.configData.putAttri(d.key,md);
				save();
			}else{
				saveAttri(d,dd);
				reflashPreview(d,dd);
			}
		}

		public function getMaterial():MaterialBase
		{
			var compId:int = int(comp.configData.getAttri("compId"));
			if(compId == 28){
				return create_TextureMaterial();
			}else if(compId == 26){
				return create_ColorMaterial();
			}
			return null;
		}
		
		//TextureMaterial
		private function create_TextureMaterial():TextureMaterial
		{
			var tm:TextureMaterial = new TextureMaterial();
			var s1:String = comp.configData.getAttri("texture");
			var f:File = new File(D3ProjectFilesCache.getInstance().addProjectResPath(s1));
			if(!f.exists) return null;
			if(f.extension == D3ComponentConst.sign_8){
				var d:D3ObjectTexture = D3SceneManager.getInstance().displayList.convertObject(f,false) 
				tm.texture = D3ProccessTexture(d.proccess).getTexture();
			}else{
				if(D3ReadImage.checkIsImage(f)){
					tm.texture = Cast.bitmapTexture(D3ResChangeProxy.getInstance().getFile(f.nativePath).content);		
				}
			}
			_reflashAttris(tm);
			return tm;
		}
		
		private function _reflashAttris(t:*):void
		{
			var obj:Object = comp.configData.getAttriObj();
			for(var key:String in obj) {
				var element:* = obj[key];
				if(t.hasOwnProperty(key)){
					var setA:Boolean=true
					var d:D3ComAttriItemVO = D3ComponentProxy.getInstance().attri_ls.getItemByKey(key);
					if(d!=null){
						if(d.value == "file"){
							setA = false;
						}
						if(d.expand == "method"){
							if(StringTWLUtil.isWhitespace(element)){
								setA = false;
							}
						}
					}
					if(setA){
						if(d.expand == "method"){
							var v:* = create_method(element);
							if(v!=null){
								t[key] = v;
							}
						}else{
							t[key] = obj[key];
						}
					}
				}
			}
		}
		
		private function create_method(obj:Object):*
		{
			if(obj is D3ObjectMethod){
				obj = D3ObjectMethod(obj).configData.getAttriObj();
			}
			var md:D3ObjectMethod = new D3ObjectMethod(comp.fromUI);
			md.parentObject = comp;
			md.readObjectXML(obj);
			md.compItem = D3ComponentProxy.getInstance().method_ls.getItemById(md.configData.getAttri("compId")).cloneObject();
			return md.medthodProccess.getMethod();
		}
		
		//ColorMaterial
		private function create_ColorMaterial():ColorMaterial
		{
			var tm:ColorMaterial = new ColorMaterial();
			_reflashAttris(tm);
			return tm;
		}
		
		override protected function saveAttri(d:ID3ComBase,v:D3ComBaseVO):void
		{
			comp.configData.putAttri(d.key,v.data);
			comp.configData.putAttri("path",D3ProjectFilesCache.getInstance().getProjectResPath(d.comp.file))
			save();
		}
				
		public function save():void
		{
			if(!comp.enSave) return ;
			var f:File = getFile();
			var x:String = comp.configData.getXMLString();
			var w:D3WriteFile = new D3WriteFile();
			w.write(f,x);
			D3ResChangeProxy.getInstance().changeContent(f.nativePath,x);
			
			//更新场景里所有用到的对象
			D3SceneManager.getInstance().displayList.reflashAllNodeMaterial(comp as D3ObjectMaterial)
		}
		
		public function getFile():File
		{
			return comp.file;
		}
		
		override public function createComp(checkSame:Boolean=false):Boolean
		{
			var f:File = getFile();
			if(f.exists){
				comp.file = f;
				var r:D3ReadFile = new D3ReadFile();
				(comp as D3ObjectMaterial).readXml(r.read(f.nativePath));
				return true;
			}
			var w:D3WriteFile = new D3WriteFile();
			w.write(f,"");
			comp.file = f;
			(comp as D3ObjectMaterial).readXml("");
			save();
			return true;
		}
				
		override public function openSource():void
		{
			get_D3SourcePopViewMediator().openText(D3ResChangeProxy.getInstance().getFile(getFile().nativePath).content);
		}
		
		override public function getPreList(c:D3ComFile):Array
		{
			var a:Array = D3ProjectFilesCache.getInstance().getAllTexture2();
			return a.concat(D3ProjectFilesCache.getInstance().getAllTextureAssets());
		}
		
		override public function reflashMethod(k:String, v:D3ProccessMethod=null):void
		{
			save()
		}
		
		
	}
}