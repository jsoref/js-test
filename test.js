const fs = require('fs');
function run() {
  Object.keys(process.env).forEach(key => console.log(key, process.env[key]))
  process.env['PATH'].split(':').forEach(dir=>fs.readdir(dir, (e,files)=>console.log(dir,files)))
}

run()
