package com.editor.d3.vo.particle.sub
{
	import com.editor.d3.cache.D3ProjectCache;
	import com.editor.d3.view.particle.prop.geometry.model.PropModelEditor;
	import com.editor.d3.vo.particle.SubPropObj;
	import com.sandy.utils.StringTWLUtil;
	
	public class GeometryObj extends SubPropObj
	{
		public function GeometryObj()
		{
			super();
			
			assembler.id = "SingleGeometrySubParser"
			
			shape.id = "PlaneShapeSubParser"
			shape.putAttri("width",5);
			shape.putAttri("height",5);
			
			assembler.putAttri("shape",shape);
			assembler.putAttri("num",200);
		}
		
		public var embed:Boolean = true;
		public var assembler:SubPropObj = new SubPropObj();
		public var uvTransformValue:SubPropObj;
		public var shape:SubPropObj = new SubPropObj();
		public var vertexTransform:SubPropObj;
		
		override public function getObject():Object
		{
			var obj:Object = {};
			obj.embed = embed;
			obj.data = {};
			obj.data.assembler = {};
			obj.data.assembler.id = assembler.id;
			obj.data.assembler.data = {};
			obj.data.assembler.data.num = assembler.getAttri("num");
			if(uvTransformValue!=null&&uvTransformValue.enabled){
				obj.data.assembler.data.uvTransformValue = uvTransformValue.getObject();
			}
			obj.data.assembler.data.shape = shape.getObject();
			if(vertexTransform!=null&&vertexTransform.enabled){
				obj.data.assembler.data.vertexTransform = vertexTransform.getObject();
			}
			return obj;
		}
		
		public function createShape(obj:Object):void
		{
			shape = new SubPropObj();
			shape.parser(obj);
		}
		
		public function createUVtransform(r:Number,c:Number):void
		{
			if(uvTransformValue != null) return ;
			uvTransformValue = new SubPropObj();
			uvTransformValue.putAttri("numRows",r);
			uvTransformValue.putAttri("numColumns",c);
			uvTransformValue.id = "Matrix2DUVCompositeValueSubParser"
		}
		
		public function createVertex(a:Array):void
		{
			if(a == null) return ;
			if(vertexTransform==null){
				vertexTransform = new SubPropObj();
				vertexTransform.id = "Matrix3DCompositeValueSubParser"
			}
			
			var out2:Array = [];
			var out:Array = [];
			for(var i:int=0;i<a.length;i++){
				if(a[i] != null){
					out.push(SubPropObj(a[i]).getObject())
					out2.push(a[i]);
				}
			}
			
			vertex_obj_ls = out2;
			
			vertexTransform.putAttri("transforms",out);
		}
		
		public var vertex_obj_ls:Array = [];
		
		override public function parser(obj:Object):void
		{
			embed = obj.embed;
			assembler.id = obj.data.assembler.id;
			assembler.putAttri("num",obj.data.assembler.data.num);
			shape.parser(obj.data.assembler.data.shape);
			if(obj.data.assembler.data.uvTransformValue!=null){
				uvTransformValue = new SubPropObj();
				uvTransformValue.parser(obj.data.assembler.data.uvTransformValue);
			}
			if(obj.data.assembler.data.vertexTransform!=null){
				var a:Array = obj.data.assembler.data.vertexTransform.data.transforms as Array;
				if(a!=null){
					var out:Array = [];
					for(var i:int=0;i<a.length;i++){
						var d:SubPropObj = new SubPropObj();
						d.parser(a[i]);
						d.index = i;
						if(StringTWLUtil.isWhitespace(d.name)){
							d.name = createName(d)
						}
						out.push(d);
					}
					vertex_obj_ls = out;
					createVertex(out);
				}
			}
		}
		
		private function createName(d:SubPropObj):String
		{
			if(d.type == PropModelEditor.model_scale){
				return "scale"
			}else if(d.type == PropModelEditor.model_rotation){
				return "rotation"
			}else if(d.type == PropModelEditor.model_trans){
				return "translation"
			}
			return "";
		}
		
	}
}