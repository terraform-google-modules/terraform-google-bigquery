"""
Command line utility to create/update  views on a big query's  table.
This utility pulls the JSON schema of a given table and iterates through them
and filters out  the blacklisted fields , and creats a string with all the
required columns for a view
Inut as Commandline Args:
- Arg 1: projectname.datasetname.tablename (Fully qualified table name)
- Arg2 :blacklisted fields: A string with comma separated black listed fields
- Arg3 : bq command path
- Arg4 : View project name.View Dataset.View Name
Output :
This tool filters out the blacklisted fields from the source table and creates a
view with the remaining fields in the destination project and destination
dataset withe given view name
***This tool is idompetent hence creates a new view if a view does not exist
with the given view name.
If the view exists , it drops the view and recreate with latest column fields
"""

import json
import sys
import subprocess
import os
import time


def view_builder(col_str, table_fqn, view_fqn, bq_path):
    """Idempotent function to create/update view
    Parameters :
        col_str : String of comma separated columns require for the view
            creation
        table_fqn : Fully Qualified name of the table
            i.e. ProjectName.DatasetName.TableName
        view_fqn : Fully qualified name of the view
            i.e. ProjectName.DatasetName.TableName
        Creates or updates a view
    """
    # Parse the view_fqn
    view_list = list(view_fqn.split('.'))
    view_prj_name = view_list[0]
    view_ds_name = view_list[1]
    view_vw_name = view_list[2]

    # Create the view with new columns and view name
    new_view_query = "\"CREATE OR REPLACE VIEW \`" + \
        view_fqn + \
        "\` AS SELECT " + col_str + " FROM \`" + table_fqn + "\`\""
    make_view_command = " ".join([
        bq_path, "query", "--use_legacy_sql=false",
        "--project_id=" + view_prj_name,
        new_view_query
    ])

    tries             = 3
    attempt           = 0

    while attempt <= tries:
        attempt += 1
        try:
            sys.stdout.write("Creating BQ View:")
            sys.stdout.write(make_view_command)
            subprocess.check_output(make_view_command, shell=True)
            break
        except subprocess.CalledProcessError as err:
            if attempt <= tries:
                time.sleep(10)
            else:
                raise RuntimeError(err.output)

def pull_table_fields(src_proj, src_ds, src_table, bq_path):
    """Function to pull the JSON schema of a given BigQuery's table
    Parameters:
        Source Project Name, Source Dataset Name, Source Table Name
    Output :
        A JSON string with source table schema is created on the local disk
    """
    # Pull the JSON schema of the table using table FQN
    source_table_name = src_proj + ":" + src_ds + "." + src_table
    tries             = 3
    attempt           = 0

    while attempt <= tries:
        attempt += 1
        try:
            schema_json = subprocess.check_output(" ".join([
                bq_path, "show", "--quiet", "--format=prettyjson", "--project_id", src_proj, source_table_name]), shell=True)
            if schema_json:
                try:
                    fields = json.loads(schema_json)["schema"]["fields"]
                    break
                except Exception as err:
                    time.sleep(1)
            else:
                time.sleep(10)
        except subprocess.CalledProcessError as err:
            if attempt <= tries:
                time.sleep(10)
            else:
                raise RuntimeError(err.output)

    return fields

def view_columns_builder(source_table_fields, blacklist_str):
    """
    Function that loads and parses a JSON File and retunrs a string of
    whitelisted columns
    Parameters:
        source_table_json: dict with source table schema
        blacklist_str : A string with comma seperated blacklisted fields
    Ouput:
        A string with whitelisted columns which can be used in view creation
    """
    view_columns_str = ""
    # Parse the blacklist string and build the blacklist
    blacklist = list()
    blacklist = list(blacklist_str.split(','))

    # Loop through the schama and build a string with filtered columns
    for p_columns in source_table_fields:
        parent_col = p_columns["name"]
        parent_col_mode = p_columns["mode"]
        parent_col_type = p_columns["type"]
        if parent_col_type == "RECORD":
            # Handle structs that are null.
            null_handler = "IF(%s is null, null, " % parent_col
            view_columns_str = view_columns_str + null_handler
            if parent_col_mode == "REPEATED":
                view_columns_str = view_columns_str + "ARRAY(SELECT AS STRUCT "
            elif (parent_col_mode == "NULLABLE" or parent_col_mode == "REQUIRED"):
                view_columns_str = view_columns_str + "STRUCT("

            cols = p_columns["fields"]
            item_count = 0

            for col in cols:
                field_name = col["name"]
                if field_name not in blacklist:
                    item_count = item_count + 1
                    if item_count == 1:
                        view_columns_str = view_columns_str + parent_col + "." \
                            + field_name
                    else:
                        view_columns_str = view_columns_str + "," + \
                            parent_col + "." + field_name
            if parent_col_mode == "REPEATED":
                view_columns_str = view_columns_str + \
                    " FROM UNNEST(" + parent_col + ") AS " + parent_col + ")) as " + \
                    parent_col
            elif parent_col_mode == "NULLABLE" or parent_col_mode == "REQUIRED":
                view_columns_str = view_columns_str + ")) as " + parent_col
        else:  # Top level column is not nested.
            if parent_col not in blacklist:
                view_columns_str = view_columns_str + parent_col
        # Add comma separator between fields.
        view_columns_str = view_columns_str + ","
    return view_columns_str.strip(",").replace(",,", ",")


def main():
    bq_command_path = os.environ.get('BQ_PATH', sys.argv[3:])
    source_table_fqn = os.environ.get('TABLE_FQN', sys.argv[1:])
    blacklist_fields_string = os.environ.get('BLACKLIST_FIELDS', sys.argv[2:])
    destination_view_fqn = os.environ.get('VIEW_FQN', sys.argv[4:])
    schema_path = os.environ.get('SCHEMA_PATH', sys.argv[5:])
    required_args = [bq_command_path, source_table_fqn, destination_view_fqn]
    if not all(required_args):
        print("required variable not set:\nbq_command_path: {}\nsource_table_fqn: {}\ndestination_view_fqn: {}".format(
            bq_command_path, source_table_fqn, destination_view_fqn))
        exit(1)
    view_columns = ""
    table_list = list(source_table_fqn.split('.'))
    source_project_name = table_list[0]
    source_dataset_name = table_list[1]
    source_table_name = table_list[2]
    if schema_path:
        source_table_fields = json.load(open("../../../"+schema_path))
    else:
        source_table_fields = pull_table_fields(source_project_name, source_dataset_name,
                                          source_table_name, bq_command_path)

    view_columns = view_columns_builder(source_table_fields, blacklist_fields_string)
    view_builder(view_columns, source_table_fqn, destination_view_fqn,
                 bq_command_path)


if __name__ == '__main__':
    main()
