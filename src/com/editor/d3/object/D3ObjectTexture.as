package com.editor.d3.object
{
	import com.editor.d3.cache.D3ComponentConst;
	import com.editor.d3.cache.D3ComponentProxy;
	import com.editor.d3.cache.D3ProjectFilesCache;
	import com.editor.d3.cache.D3ResChangeProxy;
	import com.editor.d3.object.base.D3ObjectBase;
	import com.editor.d3.process.D3ProccessTexture;
	import com.sandy.error.SandyError;
	import com.sandy.utils.StringTWLUtil;

	public class D3ObjectTexture extends D3ObjectBase
	{
		public function D3ObjectTexture(from:int)
		{
			super(from);
			proccess = new D3ProccessTexture(this);
			compItem = D3ComponentProxy.getInstance().com_ls.getItemByGroup1(group)
		}
		
		override public function get group():int
		{
			return D3ComponentConst.comp_group6;
		}
		
		//texture
		public function readXml(c:String):void
		{
			if(!D3ResChangeProxy.getInstance().checkFile(file)){
				D3ResChangeProxy.getInstance().addFile(file,"");
			}
			configData = D3ResChangeProxy.getInstance().getFile(file.nativePath,true);
			configData.comp = this;
			if(!StringTWLUtil.isWhitespace(name))configData.putAttri("name",name);
			configData.putAttri("path",D3ProjectFilesCache.getInstance().getProjectResPath(file))
			configData.readXML(c);
			
			compItem = D3ComponentProxy.getInstance().com_ls.getItemById(int(configData.getAttri("compId")));
			if(compItem == null){
				SandyError.error("D3ObjectTexture compItem is null");
			}
		}
		
		
	}
}