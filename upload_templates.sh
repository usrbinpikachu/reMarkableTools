#!/bin/bash
set -e

declare ssh_target="remarkable"
declare archive_name="remarkable_templates.tgz"

# Checks if there's any directories in the current directory
declare curr_dir=""
curr_dir=$(find . -maxdepth 1 -mindepth 1 -type d)
if [ -z "$curr_dir" ]; then
  echo -e "Template files need to be in a directory in order to be correctly categorized after uploading.\n"
  echo -e "Move your png files into a directory and run this script again.\n"
  exit 1
fi

# We don't want nested directories, though. The tablet doesn't handle them properly
declare nested_dirs=""
nested_dirs=$(find . -mindepth 2 -type d)
if [ -n "$nested_dirs" ]; then
  echo -e "The reMarkable doesn't handle nested directories for templates properly.\n"
  echo -e "Move any nested directories to this directory level and run the script again.\n"
  exit 1
fi

declare archive_command="find . -maxdepth 1 -mindepth 1 -type d -exec tar cfz $archive_name {} +"
echo -e "Compressing the directories and files using this command: %s" "$archive_command\n"
$archive_command

# Uploads the created tarball to the reMarkable's templates directory
scp $archive_name $ssh_target:/usr/share/remarkable/templates/

declare ssh_command=""
ssh_command="ssh $ssh_target \"cd /usr/share/remarkable/templates/ && tar -xf $archive_name && rm $archive_name\""
echo -e "Executing SSH command: %s" "$ssh_command\n"
eval "$ssh_command"

# Clean up the tarball
rm $archive_name

declare json_string=""
# Identify any relevant png files and generate the JSON snippets for them to add to templates.json
for f in $(find . -iname "*.PNG" | sort); do
  json_string="$json_string,\n    {\n"
  declare name=""
  name=$(basename $f | cut -f 1 -d '.' | sed 's,\-, ,g')
  json_string="$json_string\n      \"name\": \"${name//_}\","
  # Takes the last folder before the filename as the parent directory.
  declare dir_name=""
  dir_name=$(basename $(dirname $f));
  json_string="$json_string\n      \"filename\": \"$dir_name/$(basename $f  | cut -f 1 -d '.')\","
  json_string="$json_string\n      \"iconCode\": \"\ue9d8\","
  json_string="$json_string\n      \"landscape\": false,"
  json_string="$json_string\n      \"categories\": ["
  json_string="$json_string\n        \"${dir_name//-/ }\""
  json_string="$json_string\n      ]"
  json_string="$json_string\n    }"
done

echo -e "$json_string" | tee remarkable_json_snippet

