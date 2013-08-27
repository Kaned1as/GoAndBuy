package org.qtproject.qt5.android.bindings;


import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.telephony.SmsMessage;

public class IncomingSmsBroadcastReceiver extends BroadcastReceiver
{
    private static final String ACTION_SMS_RECEIVED = "android.provider.Telephony.SMS_RECEIVED";

    // Retrieve SMS
    public void onReceive(Context context, Intent intent)
    {
        String action = intent.getAction();

        if (action.equalsIgnoreCase(ACTION_SMS_RECEIVED))
        {
            SmsMessage[] msgs = getMessagesFromIntent(intent);
            String texts = "";
            for(SmsMessage msg : msgs)
                texts += msg.getMessageBody();

            Intent broadcastIntent = new Intent(context, SMSReceiveService.class);
            broadcastIntent.putExtra("number", msgs[0].getOriginatingAddress());
            broadcastIntent.putExtra("text", texts);

            context.startService(broadcastIntent);
        }

    }

    public static SmsMessage[] getMessagesFromIntent(Intent intent)
    {
        Object[] pduObjs = (Object[]) intent.getSerializableExtra("pdus");
        SmsMessage[] messages = new SmsMessage[pduObjs.length];
        for (int i = 0; i < pduObjs.length; i++)
            messages[i] = SmsMessage.createFromPdu((byte[]) pduObjs[i]);

        return messages;
    }

}
