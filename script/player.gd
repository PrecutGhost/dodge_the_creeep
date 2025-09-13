extends Area2D
# 创建碰撞信号
signal hit
# 声明两个变量，导出玩家速度、储存屏幕尺寸
@export var speed = 400
var screen_size
# 识别屏幕尺寸，用于限制玩家位置
func _ready() -> void:
	screen_size = get_viewport_rect().size
	hide()
# 监听玩家输入，控制方向变量变化
func _process(delta: float) -> void:
	var direction = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_up"):
		direction.y -= 1
	if Input.is_action_pressed("move_down"):
		direction.y += 1
		
	# 如果玩家产生了移动的长度，用normalized重置斜向速度，防止过快
	if direction.length() > 0:
		direction = direction.normalized()* speed
		# 此时播放动画
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	
	# 控制玩家位置发生变化，并限制在屏幕以内
	position += direction* delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	# 判断玩家移动的方向，选择播放动画的类型并且控制其动画是否翻转
	if direction.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = direction.x < 0
	elif direction.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = direction.y > 0
# 设置玩家被碰撞后效果：在最上面创建一个hit信号，在主场景中会使用，发射信号至主脚本
# 用“进入”信号链接脚本，控制角色受击消失、碰撞体消失、取消hit信号防止重复发生
func _on_body_entered(body: Node2D) -> void:
	hide()
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true)
# 创建一个函数，游戏开始的时候重置玩家的位置
func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
