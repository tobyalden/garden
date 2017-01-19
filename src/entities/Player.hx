package entities;

import flash.system.System;
import com.haxepunk.utils.*;
import com.haxepunk.*;
import com.haxepunk.graphics.*;

class Player extends ActiveEntity
{

  public static inline var SPEED = 1;
  public static inline var GRAVITY = 0.15;
  public static inline var BAT_GRAVITY = 0.06;
  public static inline var TERMINAL_VELOCITY = 2;
  public static inline var BAT_TERMINAL_VELOCITY = 4;
  public static inline var JUMP_POWER = 2;
  public static inline var FLAP_POWER = 1.5;

  private var isBat:Bool;

	public function new(x:Int, y:Int)
	{
		super(x, y);
    sprite = new Spritemap("graphics/player.png", 32, 16);
    sprite.add("idle", [0]);
    sprite.add("run", [0, 1], 6);
    sprite.add("attack", [2, 3], 6, false);
    sprite.add("bat", [5]);
    sprite.add("batflap", [6], 12, false);
    setHitbox(10, 16, -11, 0);
    isBat = false;
		finishInitializing();
	}

  public override function update()
  {
    if(isOnGround() && isBat) {
      velocity.x = 0;
    }
    else if(Input.check(Key.LEFT)) {
      velocity.x = -SPEED;
    }
    else if(Input.check(Key.RIGHT)) {
      velocity.x = SPEED;
    }
    else {
      velocity.x = 0;
    }

    if(isOnGround()) {
      velocity.y = 0;
    }
    else {
      if(isBat) {
        velocity.y = Math.min(BAT_TERMINAL_VELOCITY, velocity.y + BAT_GRAVITY);
        velocity.y = Math.max(-BAT_TERMINAL_VELOCITY, velocity.y);
      }
      else {
        velocity.y = Math.min(TERMINAL_VELOCITY, velocity.y + GRAVITY);
        velocity.y = Math.max(-TERMINAL_VELOCITY, velocity.y);
      }
    }

    if(Input.pressed(Key.UP)) {
      if(isBat) {
        velocity.y -= FLAP_POWER;
        sprite.play("batflap");
      }
      else if(isOnGround()) {
        velocity.y -= JUMP_POWER;
      }
    }

    if(Input.pressed(Key.Z)) {
      isBat = !isBat;
    }

    if(Input.pressed(Key.X)) {
      sprite.play("attack", false);
    }

    moveBy(velocity.x, velocity.y, "walls");

    if(isOnCeiling()) {
      velocity.y = -velocity.y/2.8;
    }

    if(Input.check(Key.ESCAPE)) {
      System.exit(0);
    }

    animate();

    super.update();
  }

  private function animate()
  {
    if(isBat) {
        if(sprite.currentAnim == "batflap" && !sprite.complete) {
          sprite.play("batflap");
        }
        else {
          sprite.play("bat");
        }
        return;
    }
    if(sprite.currentAnim == "attack" && !sprite.complete) {
      return;
    }
    if(velocity.x > 0) {
      sprite.play("run");
      sprite.flipped = false;
    }
    else if(velocity.x < 0) {
      sprite.play("run");
      sprite.flipped = true;
    }
    else {
      sprite.play("idle");
    }
  }
}
