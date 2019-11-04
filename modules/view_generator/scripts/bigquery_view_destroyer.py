import sys
import subprocess
import os
import time

def main():
    bq_path = os.environ.get('BQ_PATH', sys.argv[1:])
    view_fqn = os.environ.get('VIEW_FQN', sys.argv[2:])

    view_list = list(view_fqn.split('.'))
    view_prj_name = view_list[0]
    view_ds_name = view_list[1]
    view_vw_name = view_list[2]

    dest_view_name = view_prj_name + ":" + view_ds_name + "." + view_vw_name

    destroy_view_command = " ".join([
        bq_path, "--synchronous_mode", "rm", "-f", "-t", dest_view_name
    ])

    tries   = 3
    attempt = 0

    while attempt < tries:
        attempt += 1
        sys.stdout.write("Destroying BQ View, Attempt #"+str(attempt)+": ")
        print(destroy_view_command)

        try:
            subprocess.check_output(destroy_view_command, shell=True)
	    break
        except subprocess.CalledProcessError as err:
            if attempt >= tries:
                raise RuntimeError(err.output)
            else:
                time.sleep(10)

if __name__ == '__main__':
    main()
