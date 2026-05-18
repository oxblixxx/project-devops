1. pm2 start npm --name xxxx -- run start -- -p 9008
2. pm2 --name xxxxx serve dist 9007 --spa
3. pm2 start npm --name xxxxxx -- run serve -- --port 9042
   >NB: THE SERVE WILL BE BASED ON THE `PACKAGE.JSON` script command
