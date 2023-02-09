let express = require('express');
let path = require('path');
let fs = require('fs');
let app = express();


app.get('/', function (req, res) {
    res.sendFile(path.join(__dirname, "index.html"));
});

app.get('/profile1', function (req, res) {
  let img = fs.readFileSync(path.join(__dirname, "images/profile1.png"));
  res.writeHead(200, {'Content-Type': 'image/png' });
  res.end(img, 'binary');
});

app.get('/profile2', function (req, res) {
  let img = fs.readFileSync(path.join(__dirname, "images/profile2.png"));
  res.writeHead(200, {'Content-Type': 'image/png' });
  res.end(img, 'binary');
});

app.listen(3000, function () {
  console.log("app listening on port 3000!");
});
