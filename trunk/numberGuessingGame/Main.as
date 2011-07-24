package
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;

	public class Main extends MovieClip
	{
		private var startMessage:String;
		private var mysteryNumber:uint;
		private var previousGuess:String;
		private var currentGuess:uint;
		private var guessesRemaining:uint;
		private var guessesMade:uint;
		private var gameStatus:String;
		private var gameWon:Boolean;
		
		public function Main()
		{
			init();
		}
		
		private function init():void
		{
			//Initialize variable
			startMessage = "I am thinking of a number between 1 to 100";
			mysteryNumber = Math.ceil(Math.random() * 100);
			guessesRemaining = 10;
			guessesMade = 0;
			gameStatus = "";
			gameWon = false;
			
			//Trace the mystery number
			trace("The mystery number: " + mysteryNumber);
			
			//Initialize text fields
			output.text = startMessage;
			input.text = "";
			input.backgroundColor = 0xFFCCCCCC;
			input.restrict = "0-9";
			stage.focus = input;
			
			previousGuess = "Your guesses: ";
			guessHistory.text = previousGuess;
			
			guessButton.enabled = true;
			guessButton.alpha = 1;
			playAgainButton.visible = false;
			
			guessButton.addEventListener(MouseEvent.CLICK, onGuessButtonClick);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyPress);
		}
		
		private function onGuessButtonClick(event:MouseEvent):void
		{
			gameEvents();
			
		}
		private function onKeyPress(event:KeyboardEvent):void
		{
			trace("keyCode: " + event.keyCode);
			
			if(Keyboard.ENTER == event.keyCode)
			{
				gameEvents();
				input.text = "";
			}
		}
		
		private function gameEvents():void
		{
			currentGuess = uint(input.text);
			if(uint("") == currentGuess)
			{
				output.text = "Please enter a number!";
				return;
			}
			
			guessesRemaining--;
			guessesMade++;
			gameStatus = "Guesses Remaining: " + guessesRemaining + ", Guesses Made: " + guessesMade;
			previousGuess += currentGuess + " ";
			guessHistory.text = previousGuess;
			
			if(currentGuess > mysteryNumber)
			{
				output.text = "That's too hight." + "\n" + gameStatus;
				checkGameOver();
			}
			else if(currentGuess < mysteryNumber)
			{
				output.text = "That's too low." + "\n" + gameStatus;
				checkGameOver();
			}
			else
			{
				//output.text = "You got it!";
				gameWon = true;
				endGame();
			}	
		}
		
		private function checkGameOver():void
		{
			if(guessesRemaining < 1)
			{
				endGame();
			}
		}
		
		private function endGame():void
		{
			if(gameWon)
			{
				output.text = "Yes,it's " + mysteryNumber + "!" + "\n" + "It only took you " + guessesMade + " guesses.";
			}
			else
			{
				output.text = "I'm sorry, you've run out of guesses." + "\n" + "The correct number waw " + mysteryNumber + ".";
			}
			
			//Disable the guess button
			guessButton.removeEventListener(MouseEvent.CLICK, onGuessButtonClick);
			guessButton.enabled = false;
			guessButton.alpha = 0.3;
			
			playAgainButton.visible = true;
			playAgainButton.addEventListener(MouseEvent.CLICK, onPlayAgainButtonClick);
		}
		
		private function onPlayAgainButtonClick(event:MouseEvent):void
		{
			init();
			playAgainButton.removeEventListener(MouseEvent.CLICK, onPlayAgainButtonClick);			
		}
	}
}