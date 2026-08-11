#!/bin/sh

set -e

#cd /var/lib/odoo/.local/share/Odoo/sessions/
cd /var/lib/odoo/sessions

for i in *.sess; do rm -f "$i"; done

echo SESSIONS_CLEANUP_DONE
