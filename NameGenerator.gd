extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	#print(generate_name())
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

var surname = "赵 李 王 张 杨 陈 孙 刘 黄 郭 何".split(" ")

var name1 = "大 小 伟 建 志 泽 宇 明 俊 天 昊 浩 明 博 思 心 若 诗 春 秋 雨 子 文 德 家".split(" ")

var name2 = "伟 国 民 昊 浩 轩 宁 航 心 春 秋 杰 俊 文 泽 睿 豪 虎 刚 强 翔 哲".split(" ")

func choice(arr):
	return arr[randi() % arr.size()]
	
func generate_name():
	return choice(surname) + choice(name1) + choice(name2)
