const express = require('express')
const app = express()
 
app.get('/', function (req, res) {
  res.send('Welcome')
})

app.get("/api/generate_config", function (req, res){
  const { exec } = require('child_process');
  var yourscript = exec('bash create_client.sh',
          (error, stdout, stderr) => {
              res.json({
                "id": stdout.replace("\n", "")
              });
              console.log(stderr);
              if (error !== null) {
                  console.log(`exec error: ${error}`);
              }
          });
})
app.listen(3000)