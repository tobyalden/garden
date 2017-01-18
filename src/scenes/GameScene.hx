package scenes;

import com.haxepunk.*;
import com.haxepunk.graphics.*;
import entities.*;

class GameScene extends Scene
{

	public function new()
	{
		super();
	}

	public override function begin()
	{
    var level:Level = new Level("levels/cave.tmx");
		var background:Image = new Image("graphics/background.png");
		addGraphic(background);
		add(level);
		for (entity in level.entities) {
			add(entity);
		}
	}

}
