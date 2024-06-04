extends Node

var gameStarted: bool

var playerBody: CharacterBody2D

var playerAlive: bool
var playerDamageZone: Area2D
var playerDamageAmount: int
var playerHitbox: Area2D
var playerHealth: int

signal interact_pressed

var enemyDamageZone: Area2D
var enemyDamageAmount : int
var enemyisdead: bool

var commanderDamamgeZone: Area2D
var commanderDamageAmount: int
var is_general_chase: bool

var generalDamageZone: Area2D
var generalDamageAmount: int

var health = 150

