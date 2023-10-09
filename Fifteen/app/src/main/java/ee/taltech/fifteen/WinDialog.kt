package ee.taltech.fifteen

import android.app.AlertDialog
import android.app.Dialog
import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import androidx.appcompat.app.AppCompatDialogFragment

class WinDialog(private val moveCount: String, private val timeElapsed: String) : AppCompatDialogFragment() {


    override fun onCreateDialog(savedInstance: Bundle?): Dialog {
        val builder = AlertDialog.Builder(requireActivity())
        builder.setTitle("Congratulations!")
            .setMessage("$moveCount\n$timeElapsed")
            .setPositiveButton("OK") { _, _ ->
            }

        return builder.create()
    }
}