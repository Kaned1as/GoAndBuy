package org.qtproject.qt5.android.bindings;

import android.app.Activity;
import android.app.Service;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.IBinder;

public class SMSReceiveService extends Service
{
    final public static String PREFERENCES = "devicePrefs";
    SharedPreferences preferences;

    @Override
    public IBinder onBind(Intent intent)
    {
        return null;
    }

    @Override
    public boolean onUnbind(Intent intent)
    {
        return false;
    }

    @Override
    public void onCreate()
    {
        super.onCreate();
        preferences = getSharedPreferences(PREFERENCES, MODE_PRIVATE);
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId)
    {
        if(intent != null && intent.hasExtra("number"))
        {
            String[] IDs = preferences.getString("IDs", "").split(";");
            String[] words = preferences.getString("buyString", "").split(";");
            for (String ID : IDs)
                if(ID.length() > 1 && intent.getStringExtra("number").endsWith(ID.substring(1))) // +7 / 8 handling
                {
                    for(String word : words)
                        if(word.length() > 1 && intent.getStringExtra("text").toLowerCase().contains(word.toLowerCase()))
                        {
                            Intent starter = new Intent(this, QtActivity.class);
                            starter.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_SINGLE_TOP);
                            starter.putExtra("text", intent.getStringExtra("text"));
                            startActivity(starter);
                            return START_STICKY;
                        }
                }
        }
        return START_NOT_STICKY;
    }
}
