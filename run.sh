#!/bin/bash -x

set -e

date

cd $(dirname $0)
if [[ ! -d .venv ]]
then
    virtualenv --python=python3.5 .venv
    .venv/bin/pip install -r requirements.txt
fi
source .venv/bin/activate

./gen-burndown.py

#exit $?

sed -i "s/Last updated:.*/Last updated: $(date -u)/" index.html

# FIXME(lbragstad): Use this eventually to keep results in source controller
# and updated automatically.
# git add data.* *.json index.html
# git commit -m "Updated csv"

# FIXME(lbragstad): Switch back to this eventually once I figure out a way to
# integrate this into my blog, instead of Doug's.
# scp -i ~/.ssh/id_rsa-backups data.* *.json index.html doughellmann.com:~/doughellmann.com/doc-migration/

# NOTE(lbragstad): Locally testing only. Be explicit in copying files to expose
# since I can't seem to find a way to implement missing_urls.json for the
# policy work.
sudo cp data.csv /var/www/html/policy/
sudo cp data.json /var/www/html/policy/
sudo cp notstarted.json /var/www/html/policy/
sudo cp index.html /var/www/html/policy/
