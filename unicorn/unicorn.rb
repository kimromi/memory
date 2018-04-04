worker_processes 2
timeout 15

listen "#{@dir}tmp/sockets/unicorn.sock", :backlog => 64

stderr_path "#{@dir}log/unicorn.stderr.log"
stdout_path "#{@dir}log/unicorn.stdout.log"

