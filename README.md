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

*ServerConnect Mode*

- Enter the username, password 
- Enter server connection URL
- Additional data can be collected after the QRCode is scanned. 1 x Decimal Fields, 2 x String Fields. 
- Additional data field labels are configurable
- Additional data updates both the sqflite local database and the remote server via an API


