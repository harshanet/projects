extends Node2D

@export var crewmates_win: Texture2D
@export var imposter_win: Texture2D
@export var true_icon: Texture2D
@export var false_icon: Texture2D
@export var zero_of_six: Texture2D
@export var one_of_six: Texture2D
@export var two_of_six: Texture2D
@export var three_of_six: Texture2D
@export var four_of_six: Texture2D
@export var five_of_six: Texture2D
@export var six_of_six: Texture2D

var question1 = true
var question2 = true
var question3 = true
var question4 = true
var question5 = true
var question6 = true
var question1_answer = false
var question2_answer = false
var question3_answer = true
var question4_answer = true
var question5_answer = false
var question6_answer = false

var winner = null
# Called when the node enters the scene tree for the first time.
func _ready():
	$Camera2D.make_current()
	winner = get_parent().winner 
	if winner == "imposter":
		$YouWinLose.texture = imposter_win
	else:
		$YouWinLose.texture = crewmates_win


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_start_quiz_button_pressed():
	$GameOver.visible = false
	$YouWinLose.visible = false
	$QuizQuestions.visible = true
	$QuizQuestions/Answer1.disabled = false
	$QuizQuestions/Answer2.disabled = false
	$QuizQuestions/Answer3.disabled = false
	$QuizQuestions/Answer4.disabled = false
	$QuizQuestions/Answer5.disabled = false
	$QuizQuestions/Answer6.disabled = false
	$SubmitAnswersButton.disabled = false
	$SubmitAnswersButton.visible = true
	$StartQuizButton.disabled = true
	$StartQuizButton.visible = false

func _on_answer_1_pressed():
	if question1 == true:
		$QuizQuestions/Answer1.icon = false_icon
		question1 = false
	else:
		$QuizQuestions/Answer1.icon = true_icon
		question1 = true

func _on_answer_2_pressed():
	if question2 == true:
		$QuizQuestions/Answer2.icon = false_icon
		question2 = false
	else:
		$QuizQuestions/Answer2.icon = true_icon
		question2 = true

func _on_answer_3_pressed():
	if question3 == true:
		$QuizQuestions/Answer3.icon = false_icon
		question3 = false
	else:
		$QuizQuestions/Answer3.icon = true_icon
		question3 = true

func _on_answer_4_pressed():
	if question4 == true:
		$QuizQuestions/Answer4.icon = false_icon
		question4 = false
	else:
		$QuizQuestions/Answer4.icon = true_icon
		question4 = true

func _on_answer_5_pressed():
	if question5 == true:
		$QuizQuestions/Answer5.icon = false_icon
		question5 = false
	else:
		$QuizQuestions/Answer5.icon = true_icon
		question5 = true

func _on_answer_6_pressed():
	if question6 == true:
		$QuizQuestions/Answer6.icon = false_icon
		question6 = false
	else:
		$QuizQuestions/Answer6.icon = true_icon
		question6 = true

func _on_submit_answers_button_pressed():
	$QuizQuestions.visible = false
	$QuizQuestions/Answer1.disabled = true
	$QuizQuestions/Answer2.disabled = true
	$QuizQuestions/Answer3.disabled = true
	$QuizQuestions/Answer4.disabled = true
	$QuizQuestions/Answer5.disabled = true
	$QuizQuestions/Answer6.disabled = true
	$SubmitAnswersButton.disabled = true
	$SubmitAnswersButton.visible = false
	
	# checking answers
	var num_correct = 0
	if question1 == question1_answer:
		num_correct += 1
	if question2 == question2_answer:
		num_correct += 1
	if question3 == question3_answer:
		num_correct += 1
	if question4 == question4_answer:
		num_correct += 1
	if question5 == question5_answer:
		num_correct += 1
	if question6 == question6_answer:
		num_correct += 1
	# set the correct sprite
	if num_correct == 0:
		$QuizResults.texture = zero_of_six
	if num_correct == 1:
		$QuizResults.texture = one_of_six
	if num_correct == 2:
		$QuizResults.texture = two_of_six
	if num_correct == 3:
		$QuizResults.texture = three_of_six
	if num_correct == 4:
		$QuizResults.texture = four_of_six
	if num_correct == 5:
		$QuizResults.texture = five_of_six
	if num_correct == 6:
		$QuizResults.texture = six_of_six
	
	# hide and reveal appropriate assets
	$QuizResults.visible = true
	$FinishButton.visible = true
	$FinishButton.disabled = false
	
func _on_finish_button_pressed():
	$QuizResults.visible = false
	$FinishButton.visible = false
	$FinishButton.disabled = true
	
	$CreditsScreen.visible = true
