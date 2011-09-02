package 
{
    [SWF(width=465,height=465,backgroundColor=0xffffff,frameRate=30)]
    
    import alternativa.engine3d.containers.ConflictContainer;
    import alternativa.engine3d.controllers.SimpleObjectController;
    import alternativa.engine3d.core.Camera3D;
    import alternativa.engine3d.core.Object3D;
    import alternativa.engine3d.core.View;
    import alternativa.engine3d.materials.FillMaterial;
    import alternativa.engine3d.objects.Sprite3D;
    import alternativa.engine3d.primitives.GeoSphere;
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.ui.Mouse;
    
    /**
     * Moving by mouse
     * @author Demy
     */
    public class MovingByMouse extends Sprite {
        private var camera:Camera3D;
        private var container:ConflictContainer;
        private var controller:SimpleObjectController;
        private var arr:Sprite;
        private var null_mouse:Sprite;
        private var null_zone:Sprite;
        private var speedX:Number = 0;  
        private var speedZ:Number = 0;  
        private var maxSpeed:Number = 0.05;
        private var stop_move:Boolean = true;
                
        public function MovingByMouse():void {
            if (stage) init();
            else addEventListener(Event.ADDED_TO_STAGE, init);
        }
        
        private function init(e:Event = null):void {
            removeEventListener(Event.ADDED_TO_STAGE, init);
            
            // Scene organization            
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.TOP_LEFT;
            
            container = new ConflictContainer();
            camera = new Camera3D();
            controller = new SimpleObjectController(stage, camera, 70);
            
            camera.view = new View(465, 465);
            container.addChild(camera);
            addChild(camera.view);
            
            var sphere:GeoSphere = new GeoSphere(50);
            sphere.setMaterialToAllFaces(new FillMaterial(0xA8E5D9));
            container.addChild(sphere);            
            
            camera.x = -45;
            camera.y = 222;
            camera.z = -50;
            camera.rotationX = -1.64;
            camera.rotationZ = -2.77;
            ///
            
            // Cursors and center zone
            arr = new Sprite();
            arr.graphics.lineStyle(1, 0x999999);
            arr.graphics.beginFill(0xCCCCCC);
            arr.graphics.moveTo( -6, -7);
            arr.graphics.lineTo( 8, 0);
            arr.graphics.lineTo( -6, 7);
            arr.graphics.lineTo( -3, 0);
            arr.graphics.lineTo( -6, -7);
            arr.graphics.endFill();
            
            null_mouse = new Sprite();
            null_mouse.graphics.lineStyle(1, 0x999999);
            null_mouse.graphics.beginFill(0xCCCCCC);
            null_mouse.graphics.drawCircle(0, 0, 4.5);
            null_mouse.graphics.endFill();
            
            null_zone = new Sprite();
            null_zone.graphics.beginFill(0x000000, 0);
            null_zone.graphics.drawCircle(232.5, 232.5, 110); // Circle (or ellipse) zone where mouse rotation stops
            null_zone.graphics.endFill();
            
            addChild(null_zone);
            addChild(null_mouse);
            addChild(arr);
            ///
            // To enable MouseEvent and MouseEvent3D
            arr.mouseEnabled = false;
            null_mouse.mouseEnabled = false;
            ///
            
            addEventListener(MouseEvent.MOUSE_MOVE, changeSpeed, true);
            addEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
            addEventListener(MouseEvent.MOUSE_DOWN, startMove);
            addEventListener(MouseEvent.MOUSE_UP, stopMove);
        }
        
        private function startMove(event:MouseEvent) {
            // Moving forward
            controller.moveForward(true);
        }
        
        private function stopMove(event:MouseEvent) {
            controller.moveForward(false);
        }
        
        private function changeSpeed(event:MouseEvent) {  
            // Stoping SimpleObjectController's MouseLook
            // to avoid additional rotation
            controller.stopMouseLook();
            if (!stop_move) {
                // Counting cursor's rotation
                var new_x = arr.x - (465)/2;  
                var new_y = 465 / 2 - arr.y;
                // if it's not in the center
                if (!null_zone.hitTestPoint(arr.x, arr.y)) {  
                    var corner = Math.atan(new_y / new_x) * 180 / Math.PI;  
                    if (new_x < 0) {  
                        arr.rotation = 180 - corner;  
                    } else {  
                        arr.rotation = -corner;  
                    }  
                    arr.alpha = 1;  
                    null_mouse.alpha = 0;  
                      
                    speedZ = new_x * Math.abs(new_x) / Math.pow((465 / 2 - 110), 2) * maxSpeed;  
                    speedX = -new_y / (465 / 2 - 110) * maxSpeed;  
                } else {
                    // In the center
                    arr.alpha = 0;  
                    null_mouse.alpha = 1;  
                    speedX = 0;  
                    speedZ = 0;  
                }
                // to hide OS cursor
                Mouse.hide();
            } else {  
                // If mouse leaved scene, cursor stays center
                // and stops camera moving
                Mouse.show();  
                arr.x = 465 / 2;  
                arr.y = 465 / 2;  
                null_mouse.x = arr.x;  
                null_mouse.y = arr.y;  
                  
                arr.alpha = 0;  
                null_mouse.alpha = 0;  
                speedX = 0;  
                speedZ = 0;  
            } 
        }  
        
        private function onEnterFrameHandler(event:Event) {    
            stop_move = false;  
            // On leaving scene
            if (mouseX < 0 || mouseY < 0) {  
                stop_move = true;  
            }  
            if (mouseX > 465 || mouseY > 465) {  
                stop_move = true;  
            }  
            // Cursors follow mouse
            if(!stop_move) {  
                arr.x = mouseX;  
                arr.y = mouseY;  
                null_mouse.x = mouseX;  
                null_mouse.y = mouseY;  
            }   
            // To limit vertical rotation
            camera.rotationZ = camera.rotationZ - speedZ / 4;  
            camera.rotationX = Math.max( -2, Math.min(camera.rotationX - speedX / 4, -1)); 
            
            controller.updateObjectTransform(); // I just leave it here in case of transforming objects or camera position
            controller.update();
            camera.render();
        }
        
    }
    
}