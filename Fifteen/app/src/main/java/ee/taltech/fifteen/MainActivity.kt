package ee.taltech.fifteen

import android.content.BroadcastReceiver
import android.content.Context
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
import com.google.android.material.switchmaterial.SwitchMaterial
import ee.taltech.fifteen.R.string.seconds_elapsed
import java.util.Stack
import kotlin.Exception
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

    private var lightTextColorMain by Delegates.notNull<Int>()
    private var lightTextColorSecondary by Delegates.notNull<Int>()
    private var darkTextColorMain by Delegates.notNull<Int>()
    private var darkTextColorSecondary by Delegates.notNull<Int>()
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
    private var movesMade = Stack<Int>()
    private var moveCount = 0
    private var seconds = 0
    private var time = 0.0
    private val tileIds = intArrayOf(
        R.id.tile1,
        R.id.tile2,
        R.id.tile3,
        R.id.tile4,
        R.id.tile5,
        R.id.tile6,
        R.id.tile7,
        R.id.tile8,
        R.id.tile9,
        R.id.tile10,
        R.id.tile11,
        R.id.tile12,
        R.id.tile13,
        R.id.tile14,
        R.id.tile15,
        R.id.tile16
    )
    private lateinit var tileMap: MutableMap<Int, String>

    private var timerStarted = false
    private lateinit var serviceIntent: Intent

    private val broadcastReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context?, intent: Intent?) {
            if (intent?.action == TimerService.timerUpdated) {
                val currentTime = intent.getIntExtra(TimerService.timerUpdated, 0)
                Log.d("MainActivityBroadcast", "Received update in mainActivity at $currentTime")
                updateTimer(currentTime)
            }
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        serviceIntent = Intent(this, TimerService::class.java)

        lightTextColorMain = ContextCompat.getColor(this, R.color.lightTextColorMain)
        lightTextColorSecondary = ContextCompat.getColor(this, R.color.lightTextColorSecondary)
        darkTextColorMain = ContextCompat.getColor(this, R.color.darkTextColorMain)
        darkTextColorSecondary = ContextCompat.getColor(this, R.color.darkTextColorSecondary)
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

        val filter = IntentFilter()
        filter.addAction(TimerService.timerUpdated)
        registerReceiver(broadcastReceiver, filter)

        board = Board()

        val tileIdsArray = savedInstanceState?.getIntArray("tileIds")
        val tileValuesArray = savedInstanceState?.getStringArray("tileValues")

        if (tileIdsArray != null && tileValuesArray != null) {
            tileMap = mutableMapOf<Int, String>().apply {
                for (i in tileIdsArray.indices) this[tileIdsArray[i]] = tileValuesArray[i]
            }

            drawBoard(false)
        } else {
            tileMap = mutableMapOf()

            drawBoard()
        }

        movesMadeView.text = savedInstanceState?.getString("movesMade") ?: "0"
        secondsElapsedView.text = resources.getString(seconds_elapsed, seconds)
        checkPosition()

        newGameButton.setOnClickListener {
            if (firstStart) buildGame()
            else resetGame()
        }

        undoButton.setOnClickListener {
            undo()
        }

        modeToggle.setOnCheckedChangeListener { _, isChecked ->
            if (isChecked) {
                // appLayout.setBackgroundColor(darkBGColor)
                // window.navigationBarColor = darkBGColor
                // window.statusBarColor = darkBGColor

                movesMadeHeading.setBackgroundColor(darkSecondaryTileBGColor)
                movesMadeHeading.setTextColor(darkTextColorMain)
                movesMadeView.setBackgroundColor(darkSecondaryTileBGColor)
                movesMadeView.setTextColor(darkTextColorMain)
                secondsElapsedHeading.setTextColor(darkTextColorMain)
                secondsElapsedHeading.setBackgroundColor(darkSecondaryTileBGColor)
                secondsElapsedView.setBackgroundColor(darkSecondaryTileBGColor)
                secondsElapsedView.setTextColor(darkTextColorMain)
                newGameButton.setBackgroundColor(darkSecondaryTileBGColor)
                newGameButton.setTextColor(darkTextColorMain)
                undoButton.setBackgroundColor(darkSecondaryTileBGColor)
                undoButton.setTextColor(darkTextColorMain)

                for (tileId in tileIds) {
                    val button = findViewById<Button>(tileId)
                    button.setTextColor(darkTextColorMain)
                }

                checkPosition()
            } else {
                // appLayout.setBackgroundColor(lightBGColor)
                // window.navigationBarColor = lightMainTileBGColor
                // window.statusBarColor = lightMainTileBGColor

                movesMadeHeading.setBackgroundColor(lightSecondaryTileBGColor)
                movesMadeHeading.setTextColor(lightTextColorSecondary)
                movesMadeView.setBackgroundColor(lightSecondaryTileBGColor)
                movesMadeView.setTextColor(lightTextColorSecondary)
                secondsElapsedHeading.setTextColor(lightTextColorSecondary)
                secondsElapsedHeading.setBackgroundColor(lightSecondaryTileBGColor)
                secondsElapsedView.setBackgroundColor(lightSecondaryTileBGColor)
                secondsElapsedView.setTextColor(lightTextColorSecondary)
                newGameButton.setBackgroundColor(lightSecondaryTileBGColor)
                newGameButton.setTextColor(lightTextColorSecondary)
                undoButton.setBackgroundColor(lightSecondaryTileBGColor)
                undoButton.setTextColor(lightTextColorSecondary)

                for (tileId in tileIds) {
                    val button = findViewById<Button>(tileId)
                    button.setTextColor(lightTextColorMain)
                }

                checkPosition()
            }
        }
    }

    override fun onSaveInstanceState(outState: Bundle) {
        super.onSaveInstanceState(outState)

        if (::tileMap.isInitialized) {
            val keys = (tileMap.keys).toIntArray()
            val values = tileMap.values.toTypedArray()

            outState.putIntArray("tileIds", keys)
            outState.putStringArray("tileValues", values)
        }

        outState.putString("movesMade", moveCount.toString())
        outState.putDouble("timeElapsed", time)
    }

    override fun onDestroy() {
        super.onDestroy()
        unregisterReceiver(broadcastReceiver)
    }

    private fun buildGame() {
        activateBoard(true)
        startTimer()
        firstStart = false
    }

    private fun resetGame() {
        clearCounters()
        drawBoard()
        checkPosition()
        buildGame()
    }

    private fun drawBoard(newGame: Boolean = true) {
        val puzzle = board.createPuzzle()

        for ((i, tileId) in tileIds.withIndex()) {
            val buttonNumber = puzzle[i]

            val button = findViewById<Button>(tileId)
            if (modeToggle.isChecked) button.setTextColor(darkTextColorMain)
            else button.setTextColor(lightTextColorMain)

            if (buttonNumber == 16) {
                if (modeToggle.isChecked) button.setBackgroundColor(darkSecondaryTileBGColor)
                else button.setBackgroundColor(lightSecondaryTileBGColor)

                if (tileMap.size == 16 && !newGame) {
                    button.text = tileMap[tileId]
                } else {
                    button.text = ""
                    tileMap[tileId] = button.text as String
                }

                tileMap[tileId] = button.text as String
            } else {
                if (modeToggle.isChecked) button.setBackgroundColor(darkMainTileBGColor)
                else button.setBackgroundColor(lightMainTileBGColor)

                if (tileMap.size == 16 && !newGame) {
                    button.text = tileMap[tileId]
                } else {
                    button.text = buttonNumber.toString()
                    tileMap[tileId] = button.text as String
                }
            }
        }
    }

    fun undo() {
        Log.d("MainActivityUndo", "undo function")
        if (movesMade.isNotEmpty()) {
            Log.d("MainActivityUndo", "undoing has moves")
            val lastMoveValue = movesMade.pop()
            val emptyTileR = tileIds[lastMoveValue]
            val emptyTile = findViewById<Button>(emptyTileR)
            val emptyTileId = resources.getResourceEntryName(emptyTile.id)

            handleTileClick(emptyTileId, undoMove = true)
        }
    }

    private fun handleTileClick(tileId: String, undoMove: Boolean = false) {
        Log.d("MainActivityUndo", "handleTileClick function")
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
                    if (clickedTileNumber in setOf(4, 8, 12, 16) && i == 4) continue // special case for rightmost tiles
                    if (clickedTileNumber in setOf(1, 5, 9, 13) && i == 3) continue // special case for leftmost tiles

                    if (!undoMove) {
                        increaseMoveCount()
                        movesMade.push(neighbourTileNumber - 1)
                    } else {
                        decreaseMoveCount()
                    }

                    neighbourTile.text = clickedTileValue
                    tileMap[neighbourTileR] = neighbourTile.text as String

                    if (modeToggle.isChecked) neighbourTile.setBackgroundColor(darkMainTileBGColor)
                    else neighbourTile.setBackgroundColor(lightMainTileBGColor)

                    clickedTile.text = ""
                    tileMap[clickedTileR] = clickedTile.text as String

                    if (modeToggle.isChecked) clickedTile.setBackgroundColor(
                        darkSecondaryTileBGColor
                    )
                    else clickedTile.setBackgroundColor(lightSecondaryTileBGColor)
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

    private fun decreaseMoveCount() {
        moveCount--
        movesMadeView.text = moveCount.toString()
    }

    private fun checkPosition() {
        var correctCount = 0

        for ((i, tileId) in tileIds.withIndex()) {
            val button = findViewById<Button>(tileId)

            if (button.text.toString().toIntOrNull() == i + 1) {
                if (modeToggle.isChecked) button.setBackgroundColor(darkTertiaryTileBGColor)
                else button.setBackgroundColor(lightTertiaryTileBGColor)
                correctCount++
            } else if (button.text == "") {
                if (modeToggle.isChecked) button.setBackgroundColor(darkSecondaryTileBGColor)
                else button.setBackgroundColor(lightSecondaryTileBGColor)
            } else {
                if (modeToggle.isChecked) button.setBackgroundColor(darkMainTileBGColor)
                else button.setBackgroundColor(lightMainTileBGColor)
            }
        }

        if (correctCount == 15) handleWin()
    }

    private fun handleWin() {
        val moveCountString = getString(R.string.game_complete_moves, moveCount)
        val timeElapsedString = getString(R.string.game_complete_time_elapsed, seconds)
        activateBoard(false)
        clearCounters()
        val winDialog = WinDialog(moveCountString, timeElapsedString)
        winDialog.show(supportFragmentManager, "win_dialog")
    }

    private fun startTimer() {
        startService(serviceIntent)
        timerStarted = true
    }

    private fun updateTimer(seconds: Int) {
        runOnUiThread {
            secondsElapsedView.text = resources.getString(seconds_elapsed, seconds)
        }
    }

    private fun stopTimer() {
        Log.d("MainActivityBroadcast", "stopped timer")
        stopService(serviceIntent)
        timerStarted = false
    }

    private fun clearCounters() {
        stopTimer()
        time = 0.0
        moveCount = 0
        movesMadeView.text = "0"

        movesMade = Stack<Int>()
    }
}