    package ee.taltech.fifteen

    import android.os.Bundle
    import android.os.Handler
    import android.widget.Button
    import android.widget.TextView
    import androidx.appcompat.app.AppCompatActivity
    import androidx.constraintlayout.widget.ConstraintLayout
    import androidx.core.content.ContextCompat
    import org.w3c.dom.Text
    import java.util.Stack
    import java.util.Timer

    class MainActivity : AppCompatActivity() {
        private var seconds = 0
        private lateinit var handler: Handler;
        private lateinit var runnable: Runnable;

        private lateinit var secondsElapsedView: TextView;
        private lateinit var movesMadeView: TextView;
        private var includedLayout: ConstraintLayout? = null;
        private var boardLayout: ConstraintLayout? = null;
        private lateinit var newGameButton: Button;
        private lateinit var undoButton: Button;

        private var gameStarted = false
        private var stack = Stack<String>();
        private var moveCount = 0;

        override fun onCreate(savedInstanceState: Bundle?) {
            super.onCreate(savedInstanceState);
            setContentView(R.layout.activity_main);

            val textColor = ContextCompat.getColor(this, R.color.textColorMain);
            val mainTileBGColor = ContextCompat.getColor(this, R.color.mainTileBGColor);
            val secondaryTileBGColor = ContextCompat.getColor(this, R.color.secondaryTileBGColor);
            val tertiaryTileBGColor = ContextCompat.getColor(this, R.color.tertiaryTileBGColor);

            secondsElapsedView = findViewById(R.id.secondsElapsedView);
            movesMadeView = findViewById(R.id.movesMadeView);
            newGameButton = findViewById(R.id.newGameButton);
            undoButton = findViewById(R.id.undoButton);

            val board = Board();
            val puzzleNumbers = board.createPuzzle();

            fun drawBoard() {
                for (i in 0 until 16) {
                    val buttonNumber = puzzleNumbers[i];

                    val button = findButtonById("tile${i+1}");
                    button.setTextColor(textColor);

                    if (buttonNumber == 16) {
                        button.setBackgroundColor(secondaryTileBGColor);
                        button.text = "";
                    } else {
                        button.setBackgroundColor(mainTileBGColor);
                        button.text = buttonNumber.toString();
                    }
                }

                movesMadeView.text = "0";
                secondsElapsedView.text = getString(R.string.zero_seconds)
            }

            drawBoard();
            newGameButton.setOnClickListener {
                if (gameStarted) {
                    resetGame() // Reset the timer and move count
                }
                startGame()
            }
        }

        private fun startGame() {
            if (!gameStarted) {
                gameStarted = true
                includedLayout = findViewById(R.id.include)
                boardLayout = includedLayout?.findViewById(R.id.boardLayout)
                startTimer()
                boardLayout?.setOnClickListener {
                    increaseMoveCount()
                }
            }
        }

        private fun resetGame() {
            // reset the stopper
            handler.removeCallbacks(runnable);
            seconds = 0 ;
            secondsElapsedView.text = "0 s";

            // Reset the move count
            moveCount = 0;
            movesMadeView.text = "0";

            println("here")
            gameStarted = false;
            startGame();
        }

        fun undo() {

        }

        private fun startTimer() {
            handler = Handler()
            runnable = Runnable {
                seconds++
                secondsElapsedView.text = "$seconds s"
                handler.postDelayed(runnable, 1000)
            }

            handler.post(runnable); // start counting when the activity starts
        }

        private fun increaseMoveCount() {
            moveCount++;
            movesMadeView.text = moveCount.toString();
        }

        private fun findButtonById(tileName: String): Button {
            val resourceId = resources.getIdentifier(tileName, "id", packageName);
            return findViewById(resourceId);
        }
    }