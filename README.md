# openshift-galaxy
Ansible Galaxy on OpenShift


The master branch does not work yet. The errors seen during install are noted below.
Even if I hardcode the redis address I get to a djago migration issue.

The Devel branch does work and deploy.


This repository doesn't work yet. When running the galaxy pulp worker:

oc logs -f galaxy-pulp-worker-1-zr4xk
Traceback (most recent call last):
  File "/usr/share/galaxy/venv/lib64/python3.6/site-packages/redis/connection.py", line 968, in get_connection
    connection = self._available_connections.pop()
IndexError: pop from empty list

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
  File "/usr/share/galaxy/venv/bin/rq", line 8, in <module>
    sys.exit(main())
  File "/usr/share/galaxy/venv/lib64/python3.6/site-packages/click/core.py", line 764, in __call__
    return self.main(*args, **kwargs)
  File "/usr/share/galaxy/venv/lib64/python3.6/site-packages/click/core.py", line 717, in main
    rv = self.invoke(ctx)
  File "/usr/share/galaxy/venv/lib64/python3.6/site-packages/click/core.py", line 1137, in invoke
    return _process_result(sub_ctx.command.invoke(sub_ctx))
  File "/usr/share/galaxy/venv/lib64/python3.6/site-packages/click/core.py", line 956, in invoke
    return ctx.invoke(self.callback, **ctx.params)
  File "/usr/share/galaxy/venv/lib64/python3.6/site-packages/click/core.py", line 555, in invoke
    return callback(*args, **kwargs)
  File "/usr/share/galaxy/venv/lib64/python3.6/site-packages/rq/cli/cli.py", line 76, in wrapper
    return ctx.invoke(func, cli_config, *args[1:], **kwargs)
  File "/usr/share/galaxy/venv/lib64/python3.6/site-packages/click/core.py", line 555, in invoke
    return callback(*args, **kwargs)
  File "/usr/share/galaxy/venv/lib64/python3.6/site-packages/rq/cli/cli.py", line 209, in worker
    cleanup_ghosts(cli_config.connection)
  File "/usr/share/galaxy/venv/lib64/python3.6/site-packages/rq/contrib/legacy.py", line 25, in cleanup_ghosts
    for worker in Worker.all(connection=conn):
  File "/usr/share/galaxy/venv/lib64/python3.6/site-packages/rq/worker.py", line 113, in all
    worker_keys = get_keys(queue=queue, connection=connection)
  File "/usr/share/galaxy/venv/lib64/python3.6/site-packages/rq/worker_registration.py", line 45, in get_keys
    return {as_text(key) for key in redis.smembers(redis_key)}
  File "/usr/share/galaxy/venv/lib64/python3.6/site-packages/redis/client.py", line 1859, in smembers
    return self.execute_command('SMEMBERS', name)
  File "/usr/share/galaxy/venv/lib64/python3.6/site-packages/redis/client.py", line 752, in execute_command
    connection = pool.get_connection(command_name, **options)
  File "/usr/share/galaxy/venv/lib64/python3.6/site-packages/redis/connection.py", line 970, in get_connection
    connection = self.make_connection()
  File "/usr/share/galaxy/venv/lib64/python3.6/site-packages/redis/connection.py", line 988, in make_connection
    return self.connection_class(**self.connection_kwargs)
  File "/usr/share/galaxy/venv/lib64/python3.6/site-packages/redis/connection.py", line 453, in __init__
    self.port = int(port)
ValueError: invalid literal for int() with base 10: 'tcp://172.30.138.62:6379'


