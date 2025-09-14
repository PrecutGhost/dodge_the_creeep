extends RigidBody2D

func _ready() -> void:
# 声明变量储存mob类型，为数组，数组值取自animatedsprite2D的frames中的名字
	var mob_types = Array($AnimatedSprite2D.sprite_frames.get_animation.names())
# 设置动画播放为mob类型变量中随机选择
	$AnimatedSprite2D.animation = mob_types.pick_random()
# 设置动画播放
	$AnimatedSprite2D.play()
	
# 设置mob屏幕中不可见的时候，消失，利用visible信号传递
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
