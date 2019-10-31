import sys
import subprocess
import os

def main():
    bq_path = os.environ.get('BQ_PATH', sys.argv[1:])
    view_fqn = os.environ.get('VIEW_FQN', sys.argv[2:])

    view_list = list(view_fqn.split('.'))
    view_prj_name = view_list[0]
    view_ds_name = view_list[1]
    view_vw_name = view_list[2]

    dest_view_name = view_prj_name + ":" + view_ds_name + "." + view_vw_name

    destroy_view_command = " ".join([
        bq_path, "rm", "-f", "-t", dest_view_name
    ])

    try:
        sys.stdout.write("Destroying BQ View:")
        sys.stdout.write(destroy_view_command)
        subprocess.check_output(destroy_view_command, shell=True)
    except subprocess.CalledProcessError as err:
        raise RuntimeError(err.output)

if __name__ == '__main__':
    main()
