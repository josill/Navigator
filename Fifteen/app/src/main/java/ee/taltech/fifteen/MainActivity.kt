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

    private var gameActiveState = "gameActive"
    private var tileIdsState = "tileIds"
    private var tileValuesState = "tileValues"
    private var movesMadeState = "movesMade"

    private lateinit var board: Board
    private var firstStart = true
    private var gameActive = false
    private var timerStarted = false
    private var movesMade = Stack<Int>()
    private var moveCount = 0
    private var seconds = 0
    private var time = 0.0
    private lateinit var tileMap: MutableMap<Int, String>
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

    private lateinit var serviceIntent: Intent
    private val broadcastReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context?, intent: Intent?) {
            if (intent?.action == TimerService.timerUpdated) {
                val currentTime = intent.getIntExtra(TimerService.timerUpdated, 0)
                updateTimer(currentTime)
            }
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        setColors()
        setViews()

        setIntentFilter()
        setBoard(savedInstanceState)
        setControls(savedInstanceState)

        setNewGameButton()
        setUndoButton()
        setModeToggle()
    }

    override fun onRestoreInstanceState(savedInstanceState: Bundle) {
        super.onRestoreInstanceState(savedInstanceState)

        gameActive = savedInstanceState.getBoolean(gameActiveState)
        if (gameActive) activateBoard(true)
    }

    override fun onSaveInstanceState(outState: Bundle) {
        super.onSaveInstanceState(outState)

        if (::tileMap.isInitialized) {
            val keys = (tileMap.keys).toIntArray()
            val values = tileMap.values.toTypedArray()

            outState.putBoolean(gameActiveState, !firstStart)
            outState.putIntArray(tileIdsState, keys)
            outState.putStringArray(tileValuesState, values)
        }

        outState.putString(movesMadeState, moveCount.toString())
    }
    override fun onWindowFocusChanged(hasFocus: Boolean) {
        super.onWindowFocusChanged(hasFocus)

        if (hasFocus) {
            handleAndroidModeToggle(false)
        }
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
            if (modeToggle.isChecked) button.setTextColor(darkTextColorSecondary)
            else button.setTextColor(lightTextColorSecondary)

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

    fun undo() {
        if (movesMade.isNotEmpty()) {
            val lastMoveValue = movesMade.pop()
            val emptyTileR = tileIds[lastMoveValue]
            val emptyTile = findViewById<Button>(emptyTileR)
            val emptyTileId = resources.getResourceEntryName(emptyTile.id)

            handleTileClick(emptyTileId, undoMove = true)
        }
    }

    private fun handleTileClick(tileId: String, undoMove: Boolean = false) {
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

    private fun setColors() {
        lightTextColorMain = ContextCompat.getColor(this, R.color.lightMainTextColor)
        lightTextColorSecondary = ContextCompat.getColor(this, R.color.lightSecondaryTextColor)
        darkTextColorMain = ContextCompat.getColor(this, R.color.darkMainTextColor)
        darkTextColorSecondary = ContextCompat.getColor(this, R.color.darkSecondaryTextColor)
        lightMainTileBGColor = ContextCompat.getColor(this, R.color.lightMainTileBGColor)
        lightSecondaryTileBGColor = ContextCompat.getColor(this, R.color.lightSecondaryTileBGColor)
        lightTertiaryTileBGColor = ContextCompat.getColor(this, R.color.lightTertiaryTileBGColor)
        darkMainTileBGColor = ContextCompat.getColor(this, R.color.darkMainTileBGColor)
        darkSecondaryTileBGColor = ContextCompat.getColor(this, R.color.darkSecondaryTileBGColor)
        darkTertiaryTileBGColor = ContextCompat.getColor(this, R.color.darkTertiaryTileBGColor)
        lightBGColor = ContextCompat.getColor(this, R.color.lightBackgroundColor)
        darkBGColor = ContextCompat.getColor(this, R.color.darkBackgroundColor)
    }

    private fun setViews() {
        appLayout = findViewById(R.id.appLayout)
        secondsElapsedHeading = findViewById(R.id.secondsElapsedHeading)
        secondsElapsedView = findViewById(R.id.secondsElapsedView)
        movesMadeHeading = findViewById(R.id.movesMadeHeading)
        movesMadeView = findViewById(R.id.movesMadeView)
        boardLayout = findViewById(R.id.boardLayout)
        newGameButton = findViewById(R.id.newGameButton)
        undoButton = findViewById(R.id.undoButton)
        modeToggle = findViewById(R.id.modeToggle)
    }

    private fun setIntentFilter() {
        serviceIntent = Intent(this, TimerService::class.java)
        val filter = IntentFilter()
        filter.addAction(TimerService.timerUpdated)
        registerReceiver(broadcastReceiver, filter)
    }

    private fun setBoard(savedInstanceState: Bundle?) {
        board = Board()

        val tileIdsArray = savedInstanceState?.getIntArray(tileIdsState)
        val tileValuesArray = savedInstanceState?.getStringArray(tileValuesState)

        if (tileIdsArray != null && tileValuesArray != null) {
            tileMap = mutableMapOf<Int, String>().apply {
                for (i in tileIdsArray.indices) this[tileIdsArray[i]] = tileValuesArray[i]
            }

            drawBoard(false)
        } else {
            tileMap = mutableMapOf()

            drawBoard()
        }

        gameActive = savedInstanceState?.getBoolean(gameActiveState) ?: false
        if (gameActive) {
            firstStart = false
            activateBoard(true)
        }

        checkPosition()
    }

    private fun setControls(savedInstanceState: Bundle?) {
        movesMadeView.text = savedInstanceState?.getString(movesMadeState) ?: "0"
        secondsElapsedView.text = resources.getString(seconds_elapsed, seconds)
    }

    private fun setNewGameButton() {
        newGameButton.setOnClickListener {
            if (firstStart) buildGame()
            else resetGame()
        }
    }

    private fun setUndoButton() {
        undoButton.setOnClickListener {
            undo()
        }
    }

    private fun setModeToggle() {
        modeToggle.setOnCheckedChangeListener { _, darkModeEnabled ->
            handleModeToggle(darkModeEnabled)
        }
    }

    private fun handleModeToggle(darkModeEnabled: Boolean) {
        val bgColor = if (darkModeEnabled) darkBGColor else lightBGColor
        val secondaryTileBGColor = if (darkModeEnabled) darkSecondaryTileBGColor else lightSecondaryTileBGColor
        val mainTextColor = if (darkModeEnabled) darkTextColorMain else lightTextColorMain
        val textColorSecondary = if (darkModeEnabled) darkTextColorSecondary else lightTextColorSecondary

        appLayout.setBackgroundColor(bgColor)
        handleAndroidModeToggle(darkModeEnabled)

        movesMadeHeading.setBackgroundColor(secondaryTileBGColor)
        movesMadeHeading.setTextColor(mainTextColor)
        movesMadeView.setBackgroundColor(secondaryTileBGColor)
        movesMadeView.setTextColor(mainTextColor)
        secondsElapsedHeading.setTextColor(mainTextColor)
        secondsElapsedHeading.setBackgroundColor(secondaryTileBGColor)
        secondsElapsedView.setBackgroundColor(secondaryTileBGColor)
        secondsElapsedView.setTextColor(mainTextColor)
        newGameButton.setBackgroundColor(secondaryTileBGColor)
        newGameButton.setTextColor(mainTextColor)
        undoButton.setBackgroundColor(secondaryTileBGColor)
        undoButton.setTextColor(mainTextColor)

        for (tileId in tileIds) {
            val button = findViewById<Button>(tileId)
            button.setTextColor(textColorSecondary)
        }

        checkPosition()
    }

    private fun handleAndroidModeToggle(darkModeEnabled: Boolean) {
        val mainTileBGColor = if (darkModeEnabled) darkMainTileBGColor else lightMainTileBGColor

        window.navigationBarColor = mainTileBGColor
        window.statusBarColor = mainTileBGColor
    }
}