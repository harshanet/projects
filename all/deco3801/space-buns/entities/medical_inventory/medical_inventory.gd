extends Control

signal item_selected(data: PackedScene)
signal exit

func propagate(scene: PackedScene):
	item_selected.emit(scene)

func cancel():
	exit.emit()
