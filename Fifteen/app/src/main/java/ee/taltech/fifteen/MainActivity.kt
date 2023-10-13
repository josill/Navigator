    package ee.taltech.fifteen

    import android.content.Intent
    import android.content.IntentFilter
    import android.os.Bundle
    import android.util.Log
    import android.view.View
    import android.widget.Button
    import android.widget.TextView
    import androidx.appcompat.app.AppCompatActivity
    import androidx.constraintlayout.widget.ConstraintLayout
    import androidx.core.content.ContextCompat
    import androidx.localbroadcastmanager.content.LocalBroadcastManager
    import com.google.android.material.switchmaterial.SwitchMaterial
    import ee.taltech.fifteen.databinding.ActivityMainBinding
    import java.lang.Exception
    import java.util.Stack
    import java.util.Timer
    import kotlin.math.roundToInt
    import kotlin.properties.Delegates

    class MainActivity : AppCompatActivity() {
        private lateinit var appLayout: ConstraintLayout
        private lateinit var secondsElapsedHeading: TextView
        private lateinit var secondsElapsedView: TextView
        private lateinit var movesMadeHeading: TextView
        private lateinit var movesMadeView: TextView
        private lateinit var boardLayout: ConstraintLayout
        private lateinit var newGameButton: Button
        private lateinit var undoButton: Button
        private lateinit var modeToggle: SwitchMaterial

        private var textColor by Delegates.notNull<Int>()
        private var lightMainTileBGColor by Delegates.notNull<Int>()
        private var lightSecondaryTileBGColor by Delegates.notNull<Int>()
        private var lightTertiaryTileBGColor by Delegates.notNull<Int>()
        private var darkMainTileBGColor by Delegates.notNull<Int>()
        private var darkSecondaryTileBGColor by Delegates.notNull<Int>()
        private var darkTertiaryTileBGColor by Delegates.notNull<Int>()
        private var lightBGColor by Delegates.notNull<Int>()
        private var darkBGColor by Delegates.notNull<Int>()

        private lateinit var board: Board
        private var firstStart = true
        private var stack = Stack<String>()
        private var moveCount = 0
        private var seconds = 0
        private var time = 0.0
        private val tileIds = intArrayOf(R.id.tile1, R.id.tile2, R.id.tile3, R.id.tile4, R.id.tile5, R.id.tile6, R.id.tile7, R.id.tile8,
            R.id.tile9, R.id.tile10, R.id.tile11, R.id.tile12, R.id.tile13, R.id.tile14, R.id.tile15, R.id.tile16)

        private lateinit var binding: ActivityMainBinding
        private var timerStarted = false
//        private lateinit var serviceIntent: Intent
//        private var timerReceiver = TimerReceiver()
//        private val timerIntentFilter = IntentFilter(TimerReceiver.TIMER_UPDATED)

        override fun onCreate(savedInstanceState: Bundle?) {
            super.onCreate(savedInstanceState)
            setContentView(R.layout.activity_main)

            textColor = ContextCompat.getColor(this, R.color.textColorMain)
            lightMainTileBGColor = ContextCompat.getColor(this, R.color.lightMainTileBGColor)
            lightSecondaryTileBGColor = ContextCompat.getColor(this, R.color.lightSecondaryTileBGColor)
            lightTertiaryTileBGColor = ContextCompat.getColor(this, R.color.lightTertiaryTileBGColor)
            darkMainTileBGColor = ContextCompat.getColor(this, R.color.darkMainTileBGColor)
            darkSecondaryTileBGColor = ContextCompat.getColor(this, R.color.darkSecondaryTileBGColor)
            darkTertiaryTileBGColor = ContextCompat.getColor(this, R.color.darkTertiaryTileBGColor)
            lightBGColor = ContextCompat.getColor(this, R.color.lightBackgroundColor)
            darkBGColor = ContextCompat.getColor(this, R.color.darkBackgroundColor)

            appLayout = findViewById(R.id.appLayout)
            secondsElapsedHeading = findViewById(R.id.secondsElapsedHeading)
            secondsElapsedView = findViewById(R.id.secondsElapsedView)
            movesMadeHeading = findViewById(R.id.movesMadeHeading)
            movesMadeView = findViewById(R.id.movesMadeView)
            boardLayout = findViewById(R.id.boardLayout)
            newGameButton = findViewById(R.id.newGameButton)
            undoButton = findViewById(R.id.undoButton)
            modeToggle = findViewById(R.id.modeToggle)

//            timerIntentFilter.addAction(TimerReceiver.TIMER_UPDATED)
//            LocalBroadcastManager.getInstance(this)
//                .registerReceiver(timerReceiver, timerIntentFilter)

            movesMadeView.text = "0"
            secondsElapsedView.text = getString(R.string.zero_seconds)
            board = Board()
            drawBoard()
            checkPosition()

            newGameButton.setOnClickListener {
                if (firstStart) buildGame()
                else resetGame()
            }

            modeToggle.setOnCheckedChangeListener { _, isChecked ->
                if (isChecked) {
                    appLayout.setBackgroundColor(darkBGColor)
                    window.navigationBarColor = darkBGColor

                    movesMadeHeading.setBackgroundColor(darkSecondaryTileBGColor)
                    movesMadeView.setBackgroundColor(darkSecondaryTileBGColor)
                    secondsElapsedHeading.setBackgroundColor(darkSecondaryTileBGColor)
                    secondsElapsedView.setBackgroundColor(darkSecondaryTileBGColor)
                    newGameButton.setBackgroundColor(darkSecondaryTileBGColor)
                    undoButton.setBackgroundColor(darkSecondaryTileBGColor)
                } else {
                    appLayout.setBackgroundColor(lightBGColor)
                    window.navigationBarColor = darkSecondaryTileBGColor

                    movesMadeHeading.setBackgroundColor(lightSecondaryTileBGColor)
                    movesMadeView.setBackgroundColor(lightSecondaryTileBGColor)
                    secondsElapsedHeading.setBackgroundColor(lightSecondaryTileBGColor)
                    secondsElapsedView.setBackgroundColor(lightSecondaryTileBGColor)
                    newGameButton.setBackgroundColor(lightSecondaryTileBGColor)
                    undoButton.setBackgroundColor(lightSecondaryTileBGColor)
                }
            }
        }

        override fun onDestroy() {
            super.onDestroy()
//            LocalBroadcastManager.getInstance(this)
//                .unregisterReceiver(timerReceiver)
        }

        private fun buildGame() {
            activateBoard(true)
            startTimer()
            firstStart = false
        }

        private fun resetGame() {
            Log.d("ABCDEFG", "0")
            clearCounters()
            Log.d("ABCDEFG", "1")
            drawBoard()
            Log.d("ABCDEFG", "2")
            checkPosition()
            Log.d("ABCDEFG", "3")
            buildGame()
            Log.d("ABCDEFG", "4")
        }

        private fun drawBoard() {
            val puzzle = board.createPuzzle()

            for ((i, tileId) in tileIds.withIndex()) {
                val buttonNumber = puzzle[i]

                val button = findViewById<Button>(tileId)
                button.setTextColor(textColor)

                if (buttonNumber == 16) {
                    if (modeToggle.isActivated) {
                        button.setBackgroundColor(darkSecondaryTileBGColor)
                    } else {
                        button.setBackgroundColor(lightSecondaryTileBGColor)
                    }
                    button.text = ""
                } else {
                    if (modeToggle.isActivated) {
                        button.setBackgroundColor(darkMainTileBGColor)
                    } else {
                        button.setBackgroundColor(lightMainTileBGColor)
                    }
                    button.text = buttonNumber.toString()
                }
            }
        }

        fun undo() {

        }

        private fun handleTileClick(tileId: String) {
            increaseMoveCount()

            val clickedTileNumber = tileId.split("tile")[1].toInt()
            val clickedTileR = tileIds[clickedTileNumber - 1]
            val clickedTile = findViewById<Button>(clickedTileR)
            val clickedTileValue = clickedTile.text

            for (i in 1..4) {
                val neighbourTileNumber = when (i) {
                    1 -> clickedTileNumber - 4 // upper neighbour tile
                    2 -> clickedTileNumber + 4 // lower neighbour tile
                    3 -> clickedTileNumber - 1 // left neighbour tile
                    else -> clickedTileNumber + 1 // right neighbour tile
                }
                
                try {
                    val neighbourTileR = tileIds[neighbourTileNumber - 1]
                    val neighbourTile = findViewById<Button>(neighbourTileR)

                    if (neighbourTile.text == "") {
                        neighbourTile.text = clickedTileValue
                        if (modeToggle.isActivated) {
                            neighbourTile.setBackgroundColor(darkMainTileBGColor)
                        } else {
                            neighbourTile.setBackgroundColor(lightMainTileBGColor)
                        }

                        clickedTile.text = ""
                        if (modeToggle.isActivated) {
                            clickedTile.setBackgroundColor(darkSecondaryTileBGColor)
                        } else {
                            clickedTile.setBackgroundColor(lightSecondaryTileBGColor)
                        }
                    }
                } catch (e: Exception) {
                    println(e)
                }
            }

            checkPosition()
        }

        private fun activateBoard(activate: Boolean) {
            lateinit var tileOnClickListener: View.OnClickListener

            if (activate) {
                tileOnClickListener = View.OnClickListener { view ->
                    val idString = resources.getResourceEntryName(view.id)
                    handleTileClick(idString)
                }
            }

            for (i in 0 until boardLayout.childCount) {
                val button = boardLayout.getChildAt(i)
                if (activate) button.setOnClickListener(tileOnClickListener)
                else button.setOnClickListener(null)
            }
        }

        private fun increaseMoveCount() {
            moveCount++
            movesMadeView.text = moveCount.toString()
        }

        private fun checkPosition() {
            var correctCount = 0

            for ((i, tileId) in tileIds.withIndex()) {
                val button = findViewById<Button>(tileId)

                if (button.text.toString().toIntOrNull() == i + 1) {
                    if (modeToggle.isActivated) {
                        button.setBackgroundColor(darkTertiaryTileBGColor)
                    } else {
                        button.setBackgroundColor(lightTertiaryTileBGColor)
                    }
                    correctCount++
                }
                else if (button.text == "") {
                    if (modeToggle.isActivated) {
                        button.setBackgroundColor(darkSecondaryTileBGColor)
                    } else {
                        button.setBackgroundColor(lightSecondaryTileBGColor)
                    }
                }
                else {
                    if (modeToggle.isActivated) {
                        button.setBackgroundColor(darkMainTileBGColor)
                    } else {
                        button.setBackgroundColor(lightMainTileBGColor)
                    }
                }
            }

            if (correctCount >= 4) handleWin()
        }

        private fun handleWin() {
            val moveCountString = getString(R.string.game_complete_moves, moveCount)
            val timeElapsedString = getString(R.string.game_complete_time_elapsed, seconds)
            activateBoard(false)
            clearCounters()
            val winDialog = WinDialog(moveCountString, timeElapsedString)
            winDialog.show(supportFragmentManager, "win_dialog")
        }

        private fun getTimerStringFromDouble(time: Double): String {
            val resultInt = time.roundToInt()
            val seconds = resultInt % 86400 % 3600 % 60

            return seconds.toString()
        }

        private fun startTimer() {
//            LocalBroadcastManager.getInstance(this)
//                .sendBroadcast(Intent(TimerReceiver.TIMER_STARTED))
            timerStarted = true
        }

        private fun stopTimer() {
//            LocalBroadcastManager.getInstance(this)
//                .sendBroadcast(Intent(TimerReceiver.TIMER_STOPPED))
            timerStarted = false
        }

        private fun clearCounters() {
            stopTimer()
            time = 0.0
            Log.d("ABCDEFG", "00")
//            binding.secondsElapsedView.text = getTimerStringFromDouble(time)
            Log.d("ABCDEFG", "000")
            moveCount = 0
            movesMadeView.text = "0"
        }

        private fun findButtonById(tileName: String): Button {
            val resourceId = resources.getIdentifier(tileName, "id", packageName)
            return findViewById(resourceId)
        }
    }