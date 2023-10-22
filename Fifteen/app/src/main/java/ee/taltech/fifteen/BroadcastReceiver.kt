package ee.taltech.fifteen

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log

open class TimerBroadcastReceiver : BroadcastReceiver() {
    companion object {
        var timerStarted = "TIMER_STARTED"
        var timerUpdated = "TIMER_UPDATED"
        var timerStopped = "TIMER_STOPPED"
    }

    override fun onReceive(context: Context, intent: Intent?) {
        if (intent?.action == timerUpdated) {
            Log.d("TimerBroadcastReceiver1", "Timer updated broadcast received!")
            // Add your logic to handle the broadcast here
        }
    }
}