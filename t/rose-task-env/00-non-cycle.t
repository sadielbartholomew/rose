#!/bin/bash
#-------------------------------------------------------------------------------
# (C) British Crown Copyright 2012-7 Met Office.
#
# This file is part of Rose, a framework for meteorological suites.
#
# Rose is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Rose is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Rose. If not, see <http://www.gnu.org/licenses/>.
#-------------------------------------------------------------------------------
# Test "rose task-env" in non-cycling mode.
#-------------------------------------------------------------------------------
. $(dirname $0)/test_header
export ROSE_CONF_PATH=

#-------------------------------------------------------------------------------
tests 1
#-------------------------------------------------------------------------------
# Run the suite.
SUITE_RUN_DIR=$(mktemp -d --tmpdir="${HOME}/cylc-run" 'rose-test-battery.XXXXXX')
NAME=$(basename "${SUITE_RUN_DIR}")
rose suite-run -q -C "${TEST_SOURCE_DIR}/${TEST_KEY_BASE}" --name="${NAME}" \
    --no-gcontrol --host=localhost -- --no-detach --debug

sqlite3 "${SUITE_RUN_DIR}/log/db" \
    'select distinct status from task_states;' >"$TEST_KEY_BASE-db.out"
file_cmp "$TEST_KEY_BASE-db.out" "$TEST_KEY_BASE-db.out" <<<'succeeded'
#-------------------------------------------------------------------------------
rose suite-clean -q -y $NAME
exit 0
