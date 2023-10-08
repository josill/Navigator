package ee.taltech.fifteen

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.widget.Button
import androidx.core.content.ContextCompat
import kotlin.properties.Delegates

class BoardActivity : AppCompatActivity() {
    private var textColor by Delegates.notNull<Int>();
    private var mainTileBGColor by Delegates.notNull<Int>();
    private var secondaryTileBGColor by Delegates.notNull<Int>();
    private var tertiaryTileBGColor by Delegates.notNull<Int>();
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_board)

        textColor = ContextCompat.getColor(this, R.color.textColorMain);
        mainTileBGColor = ContextCompat.getColor(this, R.color.mainTileBGColor);
        secondaryTileBGColor = ContextCompat.getColor(this, R.color.secondaryTileBGColor);
        tertiaryTileBGColor = ContextCompat.getColor(this, R.color.tertiaryTileBGColor);

        createPuzzle();
    }
    private fun createPuzzle(): List<Int> {
        val numbers = (1..16).toList();
        val shuffledNumbers = numbers.shuffled();
        var inversionCount = 0;

        for (i in 0 until 16) {
            for (n in i until shuffledNumbers.size) {
                if (shuffledNumbers[i] != 16 && shuffledNumbers[i] > shuffledNumbers[n]) inversionCount++;
            }
        }

        if (inversionCount % 2 != 0) {
            return createPuzzle();
        }

        return shuffledNumbers;
    }

    fun drawBoard() {
        val puzzle = createPuzzle();

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

    private fun findButtonById(tileName: String): Button {
        val resourceId = resources.getIdentifier(tileName, "id", packageName);
        return findViewById(resourceId);
    }
}