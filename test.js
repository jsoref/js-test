const fs = require('fs')
const { spawnSync } = require('child_process')
function run() {
  Object.keys(process.env).forEach(key => console.log(key, process.env[key]))
  process.env['PATH'].split(':').forEach(function(dir){try{process.stdout.write(dir+":\n"+fs.readdirSync(dir).join(" ")+"\n")}catch(e){process.stdout.write(dir+":\n"+e)}})

  const perl_hello_world=spawnSync('perl', ['-e', "print q{hello world\n}"])
  const output=perl_hello_world.output
  console.log(output[1].toString('utf8'),output[2].toString('utf8'))
}

run()
