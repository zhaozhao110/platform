package com.editor.module_avg.manager
{
	import com.editor.module_avg.popview.attri.AVGAttriCell;
	import com.editor.module_avg.vo.AVGResData;
	import com.editor.module_avg.vo.frame.AVGFrameItemVO;
	import com.editor.module_avg.vo.plot.AVGPlotItemVO;
	import com.editor.module_avg.vo.plot.AVGPlotListVO;
	import com.editor.module_avg.vo.project.AVGProjectItemVO;
	import com.editor.module_avg.vo.sec.AVGSectionItemVO;
	import com.editor.module_avg.vo.sec.AVGSectionListVO;
	import com.sandy.manager.SandyManagerBase;
	import com.sandy.media.SandySound;
	
	import flash.media.SoundMixer;

	public class AVGManager extends SandyManagerBase
	{
		private static var instance:AVGManager ;
		public static function getInstance():AVGManager{
			if(instance == null){
				instance =  new AVGManager();
				//instance.init_inject();
			}
			return instance;
		}
		
		public static var currProject:AVGProjectItemVO;
		public static var currPlot:AVGPlotItemVO;
		public static var currSection:AVGSectionItemVO;
		public static var currFrame:AVGFrameItemVO;
		public static var currAttriView:AVGAttriCell;
		
		public function clear():void
		{
			currSection = null;
			currFrame = null;
			currAttriView = null;
			SoundMixer.stopAll();
		}
		
		public var sectionList:AVGSectionListVO = new AVGSectionListVO();
		public var plotList:AVGPlotListVO; 
		
		public var sound1:SandySound;
		
		public function playSound(d:AVGResData):void
		{
			if(!d.isSound) return ;
			stopSound();
			
			if(sound1 == null){
				sound1 = new SandySound();
			}else{
				sound1.stop();
			}
			sound1.play(d.loadPath);
		}
		
		public function stopSound():void
		{
			if(sound1!=null)sound1.stop();
			sound1 = null;
		}
		
		
	}
}