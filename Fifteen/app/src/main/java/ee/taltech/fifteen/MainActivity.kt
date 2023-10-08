    package ee.taltech.fifteen

    import android.os.Bundle
    import android.os.Handler
    import android.view.View
    import android.widget.Button
    import android.widget.TextView
    import androidx.appcompat.app.AppCompatActivity
    import androidx.constraintlayout.widget.ConstraintLayout
    import androidx.core.content.ContextCompat
    import java.util.Stack
    import kotlin.properties.Delegates

    class MainActivity : AppCompatActivity() {
        private lateinit var secondsElapsedView: TextView;
        private lateinit var movesMadeView: TextView;
        private lateinit var boardLayout: ConstraintLayout;
        private lateinit var newGameButton: Button;
        private lateinit var undoButton: Button;

        private var textColor by Delegates.notNull<Int>();
        private var mainTileBGColor by Delegates.notNull<Int>();
        private var secondaryTileBGColor by Delegates.notNull<Int>();
        private var tertiaryTileBGColor by Delegates.notNull<Int>();

        private lateinit var board: Board;
        private var gameStarted = false;
        private var stack = Stack<String>();
        private var moveCount = 0;
        private var seconds = 0;
        private lateinit var handler: Handler;
        private lateinit var runnable: Runnable;

        override fun onCreate(savedInstanceState: Bundle?) {
            super.onCreate(savedInstanceState);
            setContentView(R.layout.activity_main);
//
            textColor = ContextCompat.getColor(this, R.color.textColorMain);
            mainTileBGColor = ContextCompat.getColor(this, R.color.mainTileBGColor);
            secondaryTileBGColor = ContextCompat.getColor(this, R.color.secondaryTileBGColor);
            tertiaryTileBGColor = ContextCompat.getColor(this, R.color.tertiaryTileBGColor);

            secondsElapsedView = findViewById(R.id.secondsElapsedView);
            movesMadeView = findViewById(R.id.movesMadeView);
            boardLayout = findViewById(R.id.boardLayout);
            newGameButton = findViewById(R.id.newGameButton);
            undoButton = findViewById(R.id.undoButton);

            movesMadeView.text = "0";
            secondsElapsedView.text = getString(R.string.zero_seconds);
            board = Board();
            drawBoard();

            newGameButton.setOnClickListener {
                if (gameStarted) {
                    resetGame();
                }
                startGame();
            }
        }

        private fun startGame() {
            if (!gameStarted) {
                gameStarted = true;

                startTimer();

                val tileOnClickListener = View.OnClickListener { view ->
                    val idString = resources.getResourceEntryName(view.id);
                    increaseMoveCount(idString);
                }

                for (i in 0 until boardLayout.childCount) {
                    val button = boardLayout.getChildAt(i);
                    button.setOnClickListener(tileOnClickListener);
                }
            }
        }

        private fun drawBoard() {
            val puzzle = board.createPuzzle();

            for (i in 0 until 16) {
                val buttonNumber = puzzle[i];

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
        }

        private fun resetGame() {
            handler.removeCallbacks(runnable);
            seconds = 0 ;
            secondsElapsedView.text = "0 s";

            moveCount = 0;
            movesMadeView.text = "0";

            gameStarted = false;
            drawBoard();
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

            handler.post(runnable);
        }

        private fun increaseMoveCount(tileId: String) {
            println("Button ID clicked: $tileId")

            moveCount++;
            movesMadeView.text = moveCount.toString();
        }

        private fun findButtonById(tileName: String): Button {
            val resourceId = resources.getIdentifier(tileName, "id", packageName);
            return findViewById(resourceId);
        }
    }