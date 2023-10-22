package ee.taltech.fifteen

import android.app.Service
import android.content.Intent
import android.os.Binder
import android.os.IBinder
import android.util.Log
import java.util.Timer
import java.util.TimerTask

class TimerService : Service() {
    private lateinit var timerTask: MyTimerTask
    private lateinit var timer: Timer
    private var secondsElapsed: Int = 0

    companion object {
        var timerUpdated = "TIMER_UPDATED"
    }

    override fun onCreate() {
        Log.d("TimerBroadcastReceiver", "Timer task started at ${System.currentTimeMillis()}")
        super.onCreate()
        timer = Timer()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        Log.d("TimerBroadcastReceiver", "Timer task started at ${System.currentTimeMillis()}")
        startTimer()
        return START_NOT_STICKY
    }

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onDestroy() {
        super.onDestroy()
        stopTimer()
        Log.d("TimerBroadcastReceiver", "Timer stopped started at ${System.currentTimeMillis()}")
    }

    private fun startTimer() {
        timerTask = MyTimerTask()
        timer.scheduleAtFixedRate(timerTask, 0, 1000)
    }

    private fun stopTimer() {
        timer.cancel()
        super.onDestroy()
    }

    private inner class MyTimerTask : TimerTask() {
        override fun run() {
            Log.d("TimerBroadcastReceiver", "Timer task executed at ${System.currentTimeMillis()}")
            secondsElapsed++
            val intent = Intent(timerUpdated)
            intent.putExtra(timerUpdated, secondsElapsed)
            sendBroadcast(intent)
        }

    }
}