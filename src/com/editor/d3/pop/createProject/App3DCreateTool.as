package com.editor.d3.pop.createProject
{
	import com.air.io.WriteFile;
	import com.editor.d3.cache.D3ComponentConst;
	import com.editor.d3.cache.D3ProjectCache;
	import com.editor.d3.event.D3Event;
	import com.editor.d3.tool.D3WriteFile;
	import com.editor.event.App3DEvent;
	import com.editor.model.AppMainModel;
	import com.editor.vo.global.AppGlobalConfig;
	import com.sandy.SandyEngineGlobal;
	import com.sandy.core.SandyEngineManagerPool;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.filesystem.File;

	public class App3DCreateTool
	{
		public function App3DCreateTool()
		{
		}
		
		public function create(f:File,n:String):void
		{
			//create dirt
			var c:D3WriteFile = new D3WriteFile();
			WriteFile.createDirectory(f.nativePath);
			
			//create 3dPro
			var ff:File = new File(f.nativePath + File.separator + D3ComponentConst.sign_2);
			
			var x:Object = {};
			
			//name
			var project:File = f
			x.name = project.name;
			var w:D3WriteFile = new D3WriteFile();
			w.write(ff,JSON.stringify(x));			
			
			//scene
			ff = new File(f.nativePath+File.separator+"scenes");
			WriteFile.createDirectory(ff.nativePath);
			
			//materials
			ff = new File(f.nativePath+File.separator+"assets"+File.separator+"materials");
			WriteFile.createDirectory(ff.nativePath);
			
			//meshes
			ff = new File(f.nativePath+File.separator+"assets"+File.separator+"meshes");
			WriteFile.createDirectory(ff.nativePath);
			
			//shaders
			ff = new File(f.nativePath+File.separator+"assets"+File.separator+"shaders");
			WriteFile.createDirectory(ff.nativePath);
			
			//terrains
			ff = new File(f.nativePath+File.separator+"assets"+File.separator+"terrains");
			WriteFile.createDirectory(ff.nativePath);
			
			//anim
			ff = new File(f.nativePath+File.separator+"assets"+File.separator+"anim");
			WriteFile.createDirectory(ff.nativePath);
			
			//textures
			ff = new File(f.nativePath+File.separator+"assets"+File.separator+"textures");
			WriteFile.createDirectory(ff.nativePath);
			
			ff = new File(f.nativePath+File.separator+"assets"+File.separator+"textures_assets");
			WriteFile.createDirectory(ff.nativePath);
			
			//particle
			ff = new File(f.nativePath+File.separator+"assets"+File.separator+"particle");
			WriteFile.createDirectory(ff.nativePath);
			
			D3ProjectCache.dataChange = true;
			D3ProjectCache.getInstance().createXML(f.nativePath);
			
			iManager.sendAppNotification(D3Event.change3DProject_event,new File(f.nativePath+File.separator+D3ComponentConst.sign_2));
		}
				
		private function getTemple(id:int):String
		{
			return AppGlobalConfig.instance.temple_vo.getTemple(id).data;
		}
		
		private function get iManager():SandyEngineManagerPool
		{
			return SandyEngineGlobal.iManager;
		}
		
	}
}