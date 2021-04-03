extends KinematicBody

export var Speed = 10
export var Acceleration = 5
export var Gravity = 0.98
export var Jump_power = 30
export var Mouse_sensitivity = 0.3

#Обращаемся к объектам
onready var Head = $Head
onready var Camera = $Head/Camera

var Velocity = Vector3()
var Camera_x_rotation = 0

var Mouse_Vidno = false
var Mouse_V_OKNE = false


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

#Реализовываем управление камерой
func _input(event):
	if Mouse_V_OKNE == false:
		if event is InputEventMouseMotion:
			Head.rotate_y(deg2rad(-event.relative.x * Mouse_sensitivity))
			var x_delta = event.relative.y * Mouse_sensitivity
			if Camera_x_rotation + x_delta > -90 and Camera_x_rotation + x_delta < 90: 
				Camera.rotate_x(deg2rad(-x_delta))
				Camera_x_rotation += x_delta
#Это предупреждение (если его убрать то будет мазолить глаза внизу)
# warning-ignore:unused_argument
func _process(delta):
	#Нажатие на "Esc"
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
	#Нажатие на "F1"
	if Input.is_action_just_pressed("Mouse_vidno"):
		
		if Mouse_Vidno == false:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			Mouse_Vidno = true
			Mouse_V_OKNE = true
			print('1')
			
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			Mouse_Vidno = false
			Mouse_V_OKNE = false

func _physics_process(delta):
	var Head_basis = Head.get_global_transform().basis
	
	var Direction = Vector3()
	#Нажатие на "W"
	if Input.is_action_pressed("ui_up"):
		Direction -= Head_basis.z
		
	#Нажатие на "S"
	elif Input.is_action_pressed("ui_down"):
		Direction += Head_basis.z
	
	#Нажатие на "A"
	if Input.is_action_pressed("ui_left"):
		Direction -= Head_basis.x
		
	#Нажатие на "D"
	elif Input.is_action_pressed("ui_right"):
		Direction += Head_basis.x
		
	
	Direction = Direction.normalized()
	
	Velocity = Velocity.linear_interpolate(Direction * Speed, Acceleration * delta)
	Velocity.y -= Gravity
	
	#Нажатие на "Space"
	if Input.is_action_pressed("ui_jump") and is_on_floor():
		Velocity.y += Jump_power
	
	Velocity = move_and_slide(Velocity, Vector3.UP)
