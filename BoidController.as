package {
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.display.Sprite;

	public class BoidController extends MovieClip {
		//array to hold all the boids
		public var boidArray:Array = new Array();
		public var backgroundArray:Array = new Array();
		//width and height
		public const WH:Point = new Point(800, 800);
		public var pBoid:PlayerBoid;

		public function BoidController() {
			addEventListener(Event.ADDED_TO_STAGE, init);

		}
		public function init(evt:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			addEventListener(Event.ENTER_FRAME, update);
			
			//stage.addEventListener(MouseEvent.CLICK, playerMorph);
			
			
			var obs:Obstruction;
			
			for (var i:uint = 0; i < 20; i++){
				obs = new Obstruction(this, backgroundArray);
				backgroundArray.push(obs);
				var scale:Number = Math.random()*.3+.2;
				obs.scaleX *= scale;
				obs.scaleY *= scale;
				obs.alpha *= scale-.2;
				obs.x = Math.random()*(WH.x);
				obs.y = Math.random()*(WH.y);
				addChild(obs);
			}


			for (i = 0; i < 10; i++){
				obs = new Obstruction(this, boidArray);
			
				boidArray.push(obs);
				obs.x = Math.random()*(WH.x);
				obs.y = Math.random()*(WH.y);
				addChild(obs);
			}
			
			for ( i = 0; i < 100; i++) {
				boidArray.push(new Bird(this, Math.random()*360));
				boidArray[i].x = Math.random()*(WH.x);
				boidArray[i].y = Math.random()*(WH.y);
				var size:Number = 1.5;// Math.random()*Math.random() + 1; //varies between 1 and 2
				boidArray[i].mass = size;
				boidArray[i].scaleX = size;
				boidArray[i].scaleY = size;
				boidArray[i].sightRange *= size;
				boidArray[i].personalSpace *= size;
				addChild(boidArray[i]);
			}
		}
		public function playerMorph(evt:Event):void{
			pBoid.morph();
		}
		public function update(evt:Event):void{
			var neighbors:int = 0;
			for (var i:uint = 0; i < boidArray.length; i++){
				boidArray[i].update();
				neighbors += boidArray[i].neighbors;
			}
			for (i=0; i< backgroundArray.length; i++){
				backgroundArray[i].update();
			}
			trace(boidArray.length);
		}
		public function boidBirth(parentBoid:Boid){
			//remove the boid with the lowest health
			var lowestHealth:Number = 2;
			var lowestHealthIndex:Number = 0;
			for (var i:uint = 0; i < boidArray.length; i++){
				if (boidArray[i].mass < lowestHealth){
					lowestHealth == boidArray[i].mass;
					lowestHealthIndex = i;
				}
			}
			
			removeBoid(boidArray[lowestHealthIndex]);
			
			
			spawnBoid(parentBoid);
			spawnBoid(parentBoid);
			removeBoid(parentBoid);

		}
		public function boidDeath(weakBoid:Boid){
			//remove the weakBoid
			removeBoid(weakBoid);
			
			//split the boid with the highest health
			var highestHealth:Number = 0;
			var highestHealthIndex:Number = 0;
			for (var i:uint = 0; i < boidArray.length; i++){
				if (boidArray[i].mass > highestHealth){
					highestHealth == boidArray[i].mass;
					highestHealthIndex = i;
				}
			}
			
			var parentBoid:Boid = boidArray[highestHealthIndex];
			
			
			spawnBoid(parentBoid);
			spawnBoid(parentBoid);
			removeBoid(parentBoid);
	
		}
		
		public function removeBoid(boid:Boid):void{
			removeChild(boid);
			var boidIndex:int = boidArray.indexOf(boid);
			boidArray.splice(boidIndex, 1);
		}
		
		public function spawnBoid(parentBoid:Boid):void{
			//hue varies between 10 degrees difference from parent;
			var child1:Boid = new Bird(this, (parentBoid.hue + Math.random()*20 - 10)%360);
			var size:Number = 1.5; //varies between 1 and 2
			child1.mass = size;
			child1.x = parentBoid.x;
			child1.y = parentBoid.y;
			child1.scaleX = size;
			child1.scaleY = size;
			child1.sightRange *= size;
			child1.personalSpace *= size;
			addChild(child1);
			boidArray.push(child1);
		}
	}

}