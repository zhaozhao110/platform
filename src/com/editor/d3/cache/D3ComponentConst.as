package com.editor.d3.cache
{
	import com.editor.d3.object.D3Object;
	import com.editor.vo.stacks.StackDataVO;

	public class D3ComponentConst
	{
		//D3CompItemVO -- group
		/**空物体**/
		public static const comp_group1:int = 1;
		/**光**/
		public static const comp_group2:int = 2;
		/**地形**/
		public static const comp_group3:int = 3;
		/**材质 -- Material**/
		public static const comp_group4:int = 4;
		/**folder**/
		public static const comp_group5:int = 5;
		/**素材 -- Texture**/
		public static const comp_group6:int = 6;
		/**网格 - mesh**/
		public static const comp_group7:int = 7;
		/**动画 - anim**/
		public static const comp_group8:int = 8;
		/**bindingTag**/
		public static const comp_group9:int = 9;
		/**粒子,**/
		public static const comp_group10:int = 10;
		/** 几何体 **/
		public static const comp_group11:int = 11;
		/** 线框 **/
		public static const comp_group12:int = 12;
		/** 天空 **/
		public static const comp_group13:int = 13;
		/** 相机 **/
		public static const comp_group14:int = 14;
		
		
		public static const sign_1:String = "3dmat"
		public static const sign_2:String = ".3dpro"
		public static const sign_3:String = "md5mesh"
		public static const sign_4:String = "md5anim"
		public static const sign_5:String = "particle"
		public static const sign_6:String = "awp"
		public static const sign_7:String = "3dscene"
		public static const sign_8:String = "3dtex"
		public static const sign_9:String = "3dter"
		
		public static const from_outline:int = 1;
		public static const from_project:int = 2;
		
		//需要不停的刷新的，比如x,y,z 
		public static var d3CompToReflashAttri_ls:Array;
		
		public static var d3Stack_ls:Array;
		
		//3d scene
		public static const stack3d_scene:int = 21;
		//3d particle
		public static const stack3d_particle:int = 23;
		//3d game
		public static const stack3d_game:int = 24;
		
		public static function init():void
		{
			if(d3Stack_ls != null) return ;
			
			d3Stack_ls = [];
			
			var d:StackDataVO = new StackDataVO();
			d.name = "scene"
			d.id = stack3d_scene;
			d3Stack_ls.push(d);
			
			d = new StackDataVO();
			d.name = "particle"
			d.id = stack3d_particle
			d3Stack_ls.push(d);
			
			/*d = new StackDataVO();
			d.name = "particle2"
			d.id = stack3d_particle2
			d3Stack_ls.push(d);*/
						
			/*d = new StackDataVO();
			d.name = "game"
			d.id = stack3d_game;
			d3Stack_ls.push(d);*/
		}
		
		
		
	}
}