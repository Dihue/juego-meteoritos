class_name Canion
extends Node2D


## ATRIBUTOS EXPORT
export var proyectil:PackedScene = null
export var cadencia_disparo:float = 0.8
export var velocidad_proyectil:int = 100
export var danio_proyectil:int = 1


## ATRIBUTOS ONREADY
onready var tiempo_enfriamiento:Timer = $TiempoEnfriamiento
onready var disparo_sfx:AudioStreamPlayer = $DisparoSFX
onready var esta_enfriado:bool = true
onready var esta_disparando:bool = false setget set_esta_disparando
onready var puede_disparar:bool = false setget set_puede_disparar


## ATRIBUTOS
var puntos_disparo: Array = []


## SETTERS Y GETTERS (encapsulamiento)
func set_esta_disparando(disparando: bool) -> void:
	esta_disparando = disparando


func set_puede_disparar(duenio_puede: bool) -> void:
	puede_disparar = duenio_puede


## METODOS
func _ready() -> void:
	almacenar_puntos_disparo()
	# Tiempo entre disparos (cadencia)
	tiempo_enfriamiento.wait_time = cadencia_disparo


func _process(delta: float) -> void:
	# Chequeo cuadro a cuadro de las condiciones para disparar
	if esta_disparando and esta_enfriado:
		disparar()


## METODOS CUSTOM
# Se guarda una lista, los puntos de disparo para su posterior uso al disparar
func almacenar_puntos_disparo() -> void:
	for nodo in get_children():
		if nodo is Position2D:
			puntos_disparo.append(nodo)


func disparar() -> void:
	esta_enfriado = false
	disparo_sfx.play()
	tiempo_enfriamiento.start()
	
	for punto_disparo in puntos_disparo:
		var new_proyectil:Proyectil = proyectil.instance()
		
		# Creacion de una instancia del proyectil
		new_proyectil.crear(
			punto_disparo.global_position,
			get_owner().rotation,
			velocidad_proyectil,
			danio_proyectil
		)
		# Emitir señal para disparo
		Eventos.emit_signal("disparo", new_proyectil)


## SEÑALES
func _on_TiempoEnfriamiento_timeout() -> void:
	esta_enfriado = true
