package com.editor.d3.object
{
	import com.editor.d3.cache.D3ComponentConst;
	import com.editor.d3.cache.D3ComponentProxy;
	import com.editor.d3.cache.D3ProjectFilesCache;
	import com.editor.d3.cache.D3ResChangeProxy;
	import com.editor.d3.object.base.D3ObjectBase;
	import com.editor.d3.process.D3ProccessMesh;
	import com.sandy.error.SandyError;
	import com.sandy.utils.StringTWLUtil;
	
	import flash.filesystem.File;

	public class D3ObjectMesh extends D3Object
	{
		public function D3ObjectMesh(from:int)
		{
			super(from);
			proccess = new D3ProccessMesh(this);
			compItem = D3ComponentProxy.getInstance().com_ls.getItemByGroup1(group);
		}
		
		override public function get group():int
		{
			return D3ComponentConst.comp_group7;
		}
		
		//project
		public function readMesh():void
		{
			if(!D3ResChangeProxy.getInstance().checkFile(file)){
				D3ResChangeProxy.getInstance().addFile(file,"");
			}
			if(configData != null){
				SandyError.error("configData is not null");
			}
			configData = D3ResChangeProxy.getInstance().getFile(file.nativePath,true);
			configData.comp = this;
			if(!StringTWLUtil.isWhitespace(name))configData.putAttri("name",name);
			configData.putAttri("path",D3ProjectFilesCache.getInstance().getProjectResPath(file))
			configData.readObject();
		}
		
	}
}