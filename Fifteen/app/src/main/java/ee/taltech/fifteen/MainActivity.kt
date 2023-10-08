    package ee.taltech.fifteen

    import android.os.Bundle
    import android.os.Handler
    import android.view.View
    import android.widget.Button
    import android.widget.TextView
    import androidx.appcompat.app.AppCompatActivity
    import androidx.constraintlayout.widget.ConstraintLayout
    import androidx.core.content.ContextCompat
    import java.lang.Exception
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
                    handleTileClick(idString);
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

        private fun handleTileClick(tileId: String) {
            increaseMoveCount();

            println("Button ID clicked: $tileId");

            val clickedTile = findButtonById(tileId);
            lateinit var emptyTile: Button;
            val clickedTileNumber = tileId.split("tile")[1].toInt();
            val directions = listOf("Up", "Down", "Left", "Right")
//            val centerTileNumbers =  listOf(6, 7, 10, 11);
//            val cornerTileNumber = listOf(1, 4, 13, 16);
//            var otherTileNumbers = listOf(2, 3, 5, 8, 9, 12, 14, 15);
//
//            lateinit var tileUp: Button;
//            lateinit var tileDown: Button;
//            lateinit var tileLeft: Button;
//            lateinit var tileRight: Button;

//            if (tileNumber in centerTileNumbers) {
//                tileUp = findButtonById("tile${tileNumber-4}")
//                tileDown = findButtonById("tile${tileNumber+4}")
//                tileLeft = findButtonById("tile${tileNumber-1}")
//                tileRight = findButtonById("tile${tileNumber+1}")
//            } else if (tileNumber in cornerTileNumber) {
//                tileUp = findButtonById("tile${tileNumber-4}")
//                tileDown = findButtonById("tile${tileNumber+4}")
//                tileLeft = findButtonById("tile${tileNumber-1}")
//                tileRight = findButtonById("tile${tileNumber+1}")
//            } else {
//                tileUp = findButtonById("tile${tileNumber-4}")
//                tileDown = findButtonById("tile${tileNumber+4}")
//                tileLeft = findButtonById("tile${tileNumber-1}")
//                tileRight = findButtonById("tile${tileNumber+1}")
//            }

            for (i in 1..4) {
                val neighbourTileNumber = when (i) {
                    1 -> clickedTileNumber - 4 // upper neighbour tile
                    2 -> clickedTileNumber + 4 // lower neighbour tile
                    3 -> clickedTileNumber - 1 // left neighbour tile
                    else -> clickedTileNumber + 1 // right neighbour tile
                }

                val neighbourTileId = "tile$neighbourTileNumber"

                try {
                    val neighbourTile = findButtonById(neighbourTileId)
                    val direction = directions[i - 1]
                    println("Clicked Tile: $tileId, Direction: $direction, Neighbor Tile: $neighbourTileId, Neighbor Tile Text: ${neighbourTile.text}")
                } catch (e: Exception) {
                    println(e)
                }
            }
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

        private fun increaseMoveCount() {
            moveCount++;
            movesMadeView.text = moveCount.toString();
        }

        private fun findButtonById(tileName: String): Button {
            val resourceId = resources.getIdentifier(tileName, "id", packageName);
            return findViewById(resourceId);
        }
    }