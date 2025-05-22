#!/bin/sh
set -ue

CONF="/etc/default/chrony"
DOC="/usr/share/doc/chrony/README.container"
CAP="cap_sys_time"
CMD="/usr/sbin/chronyd"
# Take any args passed, use none if nothing was specified
EFFECTIVE_DAEMON_OPTS=${@:-""}

if [ -f "${CONF}" ]; then
    . "${CONF}"
else
    echo "<4>Warning: ${CONF} is missing"
fi
# take from conffile if available, default to no otherwise
EFFECTIVE_SYNC_IN_CONTAINER=${SYNC_IN_CONTAINER:-"no"}

if [ ! -x "${CMD}" ]; then
    echo "<3>Error: ${CMD} not executable"
    # ugly, but works around https://github.com/systemd/systemd/issues/2913
    sleep 0.1
    exit 1
fi

# Check if -x is already set manually, don't process further if that is the case
X_SET=0
for arg in $@; do
    if echo "$arg" | grep -q -e '^-[a-zA-Z0-9]*x'; then
         X_SET=1
    fi
done

if [ ${X_SET} -ne 1 ]; then
  # Assume it is not in a container
  IS_CONTAINER=0
  if [ -x /usr/bin/systemd-detect-virt ]; then
      if /usr/bin/systemd-detect-virt --quiet --container; then
          IS_CONTAINER=1
      fi
  fi


  # Assume it has the cap
  HAS_CAP=1
  CAPSH="/sbin/capsh"
  if [ -x "${CAPSH}" ]; then
      ${CAPSH} --has-p="${CAP}" || HAS_CAP=0
  fi

  if [ ${HAS_CAP} -eq 0 ]; then
      echo "<4>Warning: Missing ${CAP}, syncing the system clock will fail"
  fi
  if [ ${IS_CONTAINER} -eq 1 ]; then
      echo "<4>Warning: Running in a container, likely impossible and unintended to sync system clock"
  fi

  if [ ${HAS_CAP} -eq 0 -o ${IS_CONTAINER} -eq 1 ]; then
      if [ "${EFFECTIVE_SYNC_IN_CONTAINER}" != "yes" ]; then
          echo "<5>Adding -x as fallback disabling control of the system clock, see ${DOC} to override this behavior"
          EFFECTIVE_DAEMON_OPTS="${EFFECTIVE_DAEMON_OPTS} -x"
      else
          echo "<5>Not falling back to disable control of the system clock, see ${DOC} to change this behavior"
      fi
  fi
fi

${CMD} ${EFFECTIVE_DAEMON_OPTS}
