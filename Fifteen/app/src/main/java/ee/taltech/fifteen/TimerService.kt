package ee.taltech.fifteen

import android.app.Service
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.IBinder
import android.util.Log
import java.util.Timer
import java.util.TimerTask

class TimerReceiver: BroadcastReceiver() {
    override fun onReceive(context: Context?, intent: Intent?) {
        if (intent?.action == TIMER_UPDATED) {
            Log.d("broadcast receiver", intent.action!!)
        }
    }

    companion object {
        const val TIMER_UPDATED = "timerUpdated"
        const val TIMER_STARTED = "timerStarted"
        const val TIMER_STOPPED = "timerStopped"
    }
}