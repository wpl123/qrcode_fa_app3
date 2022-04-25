# qrcode_fa_app3

A new Flutter project.

This App enables QRCode scanning in both Local and ServerConnect modes

*Local Mode*

- Allows Scanning of a QRCode and the displaying of the QRCode and URL Preview on the screen
- User has the option to launch the URL or scan another QRCode
- Local Settings enable the retention of scan history for a set number of days and the ability to re-launch or share QRCodes from the history
- QRCodes and scan status are updated directly to a sqflite local database
- QRCodes can launch a webpage, send and email or SMS or make a phone call
- Local settings enable webpages can be launched in the app itself or inside the default browser app 

*Server Mode*

- Requires the user to seect Server Connect Mode and setup the username, password and server connection URL in the settings
- Data can be collected after the QRCode is scanned. 1 x Decimal Fields, 2 x String Fields. The Field lables are setup in the Settings
- This data is updated directly via SQL to a sqflite local database and the remote server via an API


