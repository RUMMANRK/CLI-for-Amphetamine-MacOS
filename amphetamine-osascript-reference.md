Overview
Amphetamine⁴ ships with expanded AppleScript support. This document goes over available the AppleScript commands for Amphetamine⁴. AppleScript documentation for earlier versions of Amphetamine is not available outside of the Scripting Dictionary bundled within the app.



For best results, make sure Amphetamine is installed on the /Applications folder. For additional documentation, refer to the AppleScript dictionary included with Amphetamine⁴.



Starting a New Session
Starting a new session is super easy:

tell application "Amphetamine" to start new session



Unless a duration and options for a session are supplied, Amphetamine will 1) use the Default Duration as configured in Amphetamine Preferences → General → Default Duration,and 2) use the Allow Display Sleep as configured in Amphetamine Preferences → General → Allow Display Sleep. To supply a duration, and other options, use the with options: verb:



tell application "Amphetamine" to start new session with options {duration:integer, interval:hours or minutes, displaySleepAllowed:true or false}



Here's an example of a 3 hour session with display sleep allowed:

tell application "Amphetamine" to start new session with options {duration:3, interval:hours, displaySleepAllowed:true}



Here's an example of a 30 minute session with display sleep prevented:

tell application "Amphetamine" to start new session with options {duration:30, interval:minutes, displaySleepAllowed:false}



Here's an example of activating a session until a certain time (2:30 in this example):

Thanks, Jim, for sharing this example!

set t to (time string of (current date))

set d to (date string of (current date))



set endTime to date (d & " at 2:30:00 PM")

set durationSeconds to endTime - (current date)

set durationMinutes to durationSeconds / 60 div 1



if durationMinutes > 0 then

    tell application "Amphetamine" to start new session with options {duration:durationMinutes, interval:minutes, displaySleepAllowed:true}

else

    log durationMinutes

end if





Note: If a session is already running when Amphetamine receives an AppleScript command to start a new session, the existing session will end and a new one will be started per the instructions sent via AppleScript. Trigger sessions will resume after completion of the AppleScript initiated session, if all criteria for the Trigger to activate are still met.





Ending a Session
Ending a session is also super easy:

tell application "Amphetamine" to end session



Note: This command will not end a Trigger Session. Triggers must be disabled manually or via AppleScript (see below).





Modifying a Running Session's Display Sleep Option
If a session is running, you can modify its display sleep option. It is a recommended best practice to query the display sleep option first and take the appropriate action based on your query result.



Allow Display sleep

tell application "Amphetamine" to allow display sleep



Prevent Display Sleep

tell application "Amphetamine" to prevent display sleep



Allow Screen Saver (Requires Amphetamine 5.0+)

tell application "Amphetamine" to allow screen saver



Prevent Screen Saver (Requires Amphetamine 5.0+)

tell application "Amphetamine" to prevent screen saver



Enable Closed-Display Mode (Requires Amphetamine 5.0+)

tell application "Amphetamine" to enable closed display mode



Disable Closed-Display Mode (Requires Amphetamine 5.0+)

tell application "Amphetamine" to disable closed display mode



Querying For Session/Session Options
If you need to know whether a session is running, and if running what the session's properties are, you can query the current session.



Active Session

tell application "Amphetamine" to set sessionActiveTest to session is active



sessionActiveTestis assigned a boolean value of true or false, based on whether there is an active session.



Session time Remaining 

tell application "Amphetamine" to set timeRemaining to session time remaining



timeRemaining is assigned an integer value representing total number of seconds remaining in the session (ex. 1 hour = 3600 seconds). If the session does not have a definitive time remaining the following values will be returned: 



  0 if session is of infinite duration

-1 if session is Trigger-based

-2 if session is app-based (i.e. while app is running) or date-based (i.e. until XX:XX time)

-3 if there is no active session.





Display Sleep Status

tell application "Amphetamine" to set displaySleepStatus to display sleep allowed



displaySleepStatusis assigned a boolean value of true or false based on whether the current session allows display sleep. If there is no active session, true is always returned.



Trigger Session 

tell application "Amphetamine" to set triggerCheck to session is Trigger



triggerCheck is assigned a boolean value of true or false based on whether the current session is a Trigger-based session. If there is no active session, false is always returned.





Querying For App Preferences
If you need to know whether certain preferences are enabled or disable, you can query the preference.



Triggers Status

tell application "Amphetamine" to set triggerStatus to Triggers are enabled



triggerStatusis assigned a boolean value based on whether Triggers are enabled or disabled in Amphetamine's Preferences.



Drive Alive Status

tell application "Amphetamine" to set driveAliveStatus to Drive Alive is enabled



driveAliveStatusis assigned a boolean value based on whether Triggers are enabled or disabled in Amphetamine's Preferences.