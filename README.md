# qrcode_fa_app3

This is a Flutter App on Andriod. Enables QRCode scanning in both Local and ServerConnect modes. 

*Local Mode*

- Allows Scanning of a QRCode and the displaying of the QRCode and URL Preview on the screen
- User has the option to launch the URL or scan another QRCode
- Set Scan History in days 
- Scan History can be re-launched or shared
- QRCodes and scan status are updated directly to a sqflite local database
- QRCodes can launch a webpage, send and email or SMS or make a phone call
- Local settings enable webpages can be launched in the app itself or inside the default browser app 

*ServerConnect Mode*

- Enter the username, password 
- Enter server connection URL
- Additional data can be collected after the QRCode is scanned. 1 x Decimal Fields, 2 x String Fields. 
- Additional data field labels are configurable
- Additional data updates both the sqflite local database and the remote server via an API


Server Connect Mode could be used for Inventory cycle counts, move stock from bin A to bin B, scan in to venue, asset mainetnenace schedule


ToDo: Move API backend from Laravel to Flask
      Enable free format data validation for additional data fields
