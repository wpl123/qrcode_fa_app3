# qrcode_fa_app3

This is a Flutter App on Andriod. Enables QRCode scanning in both Local and ServerConnect modes. 

*Local Mode*

- Scan QRCode, store and display the QRCode locally.
- Preview the URL on the device prior to launch
- User has the option to launch the URL or scan another QRCode
- Scan History can be re-launched or shared
- QRCodes and scan status are updated directly to a sqflite local database
- QRCodes can launch a webpage, send email,SMS or make a phone call
- Local settings configure Scan History in Days plus in-app or default browser URL launch 

*ServerConnect Mode*

- Enter the username, password 
- Enter server connection URL
- Additional data can be collected after the QRCode is scanned. 1 x Decimal Fields, 2 x String Fields. 
- Additional data field labels are configurable
- Additional data updates both the sqflite local database and the remote server via an API


Server Connect Mode could be used for Inventory cycle counts, move stock from bin A to bin B, scan in to venue, asset mainetnenace schedule


ToDo: Move API backend from Laravel to Flask
      Enable free format data validation for additional data fields
