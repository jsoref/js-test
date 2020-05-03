const fs = require('fs')
const { spawnSync } = require('child_process')
function run() {
  process.stdout.write("cwd: "+process.cwd()+"\n")
  process.stdout.write("__dirname: "+__dirname+"\n")
  Object.keys(process.env).forEach(key => console.log(key, process.env[key]))
  process.env['PATH'].split(':').forEach(function(dir){try{process.stdout.write(dir+":\n"+fs.readdirSync(dir).join(" ")+"\n")}catch(e){process.stdout.write(dir+":\n"+e)}})

  const hello_world=spawnSync('ls')
  const output=hello_world.output
  console.log(output[1].toString('utf8'),output[2].toString('utf8'))
}

run()
