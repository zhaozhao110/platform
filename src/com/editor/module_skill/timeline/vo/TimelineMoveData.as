package com.editor.module_skill.timeline.vo
{
	import com.editor.module_skill.battle.BattleContainer;
	import com.editor.module_skill.battle.role.RoleBase;
	import com.editor.module_skill.manager.EditSkillManager;
	import com.editor.module_skill.timeline.TimelineContainer;
	import com.editor.module_skill.timeline.TimelineRect;
	import com.sandy.math.SandyPoint;
	import com.sandy.utils.StringTWLUtil;

	public class TimelineMoveData extends TimelineDataBase
	{
		public function TimelineMoveData()
		{
		}
		
		public var x:Number;
		public var y:Number;
		
		public var scaleX:Number=1;
		public var scaleY:Number=1;
		
		public var visible:Boolean = true;
		
		private var _rotation:int;
		public function set rotation(value:int):void
		{
			_rotation = value;
		}
		public function get rotation():int
		{
			return _rotation;
		}
		
		public var alpha:Number = 1;
		
		override public function getData():String
		{
			return isKey.toString()
		}
		
		override public function getLabel():String
		{
			return "信息: "+"x:" + x + " / y:" + y + " / rotation: " + rotation + " / scaleX:" + scaleX + " / scaleY:"+scaleY + " /alpha:"+alpha ; 
		}
		
		override public function save():*
		{
			return frame+"$"+x+"|"+y+"|"+rotation+"|"+(visible==true?1:0)+"|"+scaleX+"|"+scaleY+"|"+alpha;
		}
		
		override public function parser(v:String):void
		{
			var a:Array = v.split("|");
			x = Number(a[0]);
			y = Number(a[1]);
			rotation = Number(a[2]);
			if(!StringTWLUtil.isWhitespace(a[3])){
				visible = int(a[3])==1?true:false;
			}else{
				visible = true;
			}
			scaleX = Number(a[4]);
			if(isNaN(scaleX)){
				if(row == EditSkillManager.row5){
					scaleX = -1
				}else{
					scaleX = 1;
				}
			}
			scaleY = Number(a[5]);
			if(isNaN(scaleY)){
				scaleY = 1;
			}
			alpha = Number(a[6]);
			if(isNaN(alpha)){
				alpha = 1;
			}
			
			if(row == EditSkillManager.row2 && frame ==1 ){
				EditSkillManager.attack_loc.x = x;
			}
			if(row == EditSkillManager.row5 && frame == 1){
				EditSkillManager.defend_loc.x = x;
			}
		}
		
		override public function reflash():void
		{
			super.reflash();
			
			var d:TimelineMoveData;
			var key_a:Array = EditSkillManager.timeDataList.getRow(row,true);
			
			//计算出该帧的前一帧和后一帧的之间的每一帧的位移
			var leftData:TimelineMoveData;
			var rightData:TimelineMoveData;
			for(var i:int=0;i<key_a.length;i++){
				d = key_a[i] as TimelineMoveData;
				if(d.frame < frame){
					leftData = d;
				}else if(d.frame > frame){
					if(rightData == null){
						rightData = d;
					}
				}
			}
			
			var xBet:int;
			var yBet:int;
			//角度
			var rotBet:int;
			var newFrame:int;
			var dat:TimelineMoveData;
			var i2:int;
			
			if(leftData!=null){
				xBet = (x-leftData.x)/(frame-leftData.frame);
				yBet = (y-leftData.y)/(frame-leftData.frame);
				rotBet = (rotation-leftData.rotation)/(frame-leftData.frame);
				for(i=leftData.frame;i<frame;i++){
					++i2;
					newFrame = leftData.frame+i2;
					dat = new TimelineMoveData();
					dat.x = xBet*i2+leftData.x;
					dat.y = yBet*i2+leftData.y;
					dat.rotation = rotBet*i2+leftData.rotation;
					dat.row = row;
					dat.scaleX = leftData.scaleX;
					dat.scaleY = leftData.scaleY;
					dat.alpha = leftData.alpha;
					dat.frame = newFrame;
					dat.visible = leftData.visible;
					if(EditSkillManager.timeDataList.getData(dat.row,dat.frame) != "true"){
						EditSkillManager.timeDataList.put2(dat);
					}
					
				}
			}
			i2=0;
			if(rightData!=null){
				xBet = (rightData.x-x)/(rightData.frame-frame)
				yBet = (rightData.y-y)/(rightData.frame-frame)
				rotBet = (rightData.rotation-rotation)/(rightData.frame-frame)
				for(i=frame;i<rightData.frame;i++){
					++i2;
					newFrame = frame+i2;
					dat = new TimelineMoveData();
					dat.x = xBet*i2+x;
					dat.y = yBet*i2+y;
					dat.rotation = rotBet*i2+rotation;
					dat.row = row;
					dat.scaleX = scaleX;
					dat.scaleY = scaleY;
					dat.alpha = alpha;
					dat.frame = newFrame;
					dat.visible = visible;
					if(EditSkillManager.timeDataList.getData(dat.row,dat.frame) != "true"){
						EditSkillManager.timeDataList.put2(dat);
					}
					
				}
			}
		}
		
		override public function remove():void
		{
			super.remove();
			
			var d:TimelineMoveData;
			var key_a:Array = EditSkillManager.timeDataList.getRow(row,true);
			var all_a:Array = EditSkillManager.timeDataList.getRow(row);
			var lastData:TimelineMoveData = all_a[all_a.length-1] as TimelineMoveData;
			
			//计算出该帧的前一帧和后一帧的之间的每一帧的位移
			var leftData:TimelineMoveData;
			var rightData:TimelineMoveData;
			for(var i:int=0;i<key_a.length;i++){
				d = key_a[i] as TimelineMoveData;
				if(d.frame < frame){
					leftData = d;
				}else if(d.frame > frame){
					if(rightData == null){
						rightData = d;
					}
				}
			}
			
			var xBet:int;
			var yBet:int;
			//角度
			var rotBet:int;
			var newFrame:int;
			var dat:TimelineMoveData;
			var i2:int;
			
			if(rightData==null){
				//右边没有关键帧了,删除上一个关键帧后面的所有帧
				if(leftData!=null){
					for(i=leftData.frame;i<lastData.frame;i++){
						++i2;
						newFrame = leftData.frame+i2;
						dat = new TimelineMoveData();
						dat.row = row;
						dat.frame = newFrame;
						EditSkillManager.timeDataList.remove2(dat);
					}
				}
			}
			else{
				//重新计算右边的关键帧和左边的关键帧之间的所有帧的位移
				if(leftData!=null){
					xBet = (rightData.x-leftData.x)/(rightData.frame-leftData.frame)
					yBet = (rightData.y-leftData.y)/(rightData.frame-leftData.frame)
					rotBet = (rightData.rotation-leftData.rotation)/(rightData.frame-leftData.frame)
					for(i=leftData.frame;i<rightData.frame;i++){
						++i2;
						newFrame = leftData.frame+i2;
						dat = new TimelineMoveData();
						dat.x = xBet*i2+leftData.x;
						dat.y = yBet*i2+leftData.y;
						dat.rotation = rotBet*i2+leftData.rotation;
						dat.row = row;
						dat.scaleX = leftData.scaleX;
						dat.scaleY = leftData.scaleY;
						dat.alpha = leftData.alpha;
						dat.frame = newFrame;
						dat.visible = leftData.visible;
						if(EditSkillManager.timeDataList.getData(dat.row,dat.frame) != "true"){
							EditSkillManager.timeDataList.put2(dat);
						}
					}
				}
			}
			
		}
		
		override public function play():void
		{
			//计算该选中帧前的所有帧的位移
			getPlayer().pixelLoc = new SandyPoint(x,y);
			getPlayer().scaleX = scaleX
			getPlayer().scaleY = scaleY
			getPlayer().alpha = alpha;
			getPlayer().rotation = rotation
			getPlayer().visible = visible;
		}
		
		override public function preview():void
		{
			getEditPlayer().pixelLoc = new SandyPoint(x,y);
			getEditPlayer().scaleX = scaleX
			getEditPlayer().scaleY = scaleY
			getEditPlayer().alpha = alpha;
			getEditPlayer().rotation = rotation;
			getEditPlayer().visible = visible;
		}
		
		public static function reset():void
		{
			var row:int = EditSkillManager.selectRect.getRow();
			var frame:int = EditSkillManager.selectRect.getFrame();
			
			var player:RoleBase;
			if(row == EditSkillManager.row2){
				if(BattleContainer.instace.battleItemContainer.attackPlayer!=null){
					player = BattleContainer.instace.battleItemContainer.attackPlayer;
					player.pixelLoc = EditSkillManager.attack_loc;
					player.scaleX = 1;
				}
			}else if(row == EditSkillManager.row5){
				if(BattleContainer.instace.battleItemContainer.defendPlayer!=null){
					player = BattleContainer.instace.battleItemContainer.defendPlayer;
					player.pixelLoc = EditSkillManager.defend_loc
					player.scaleX = -1;
				}
			}
			if(player!=null){
				player.scaleY = 1;
				player.alpha = 1;
				player.rotation = 0;
				player.visible = true;
			}
		}
		
	}
}