#!/bin/sh

### Constants

datadir=data/
bucket=default

### Configuration

host="${MINIUM__SERVER__HOST:-0.0.0.0}"
port="${MINIUM__SERVER__PORTS__S3:-10210}"
web_port="${MINIUM__SERVER__PORTS__WEB:-10211}"
admin_user="${MINIUM__CREDENTIALS__ADMIN__USER:-admin}"
admin_password="${MINIUM__CREDENTIALS__ADMIN__PASSWORD:-password}"
readonly_user="${MINIUM__CREDENTIALS__READONLY__USER:-readonly}"
readonly_password="${MINIUM__CREDENTIALS__READONLY__PASSWORD:-password}"
readwrite_user="${MINIUM__CREDENTIALS__READWRITE__USER:-readwrite}"
readwrite_password="${MINIUM__CREDENTIALS__READWRITE__PASSWORD:-password}"

### Temporary files and directories

tmpconfigdir="$(mktemp --directory)"

### Functions

# Cleanup function to remove temporary files and directories
cleanup() {
	rm --recursive --force "${tmpconfigdir}"
}

# Function to setup ignoring signals
ignoresignals() {
	for signal in INT TERM HUP QUIT; do
		trap '' "${signal}"
	done
}

# Function to start RustFS
startrustfs() {
	echo 'Starting RustFS...'

	RUSTFS_ACCESS_KEY="${admin_user}" \
		RUSTFS_SECRET_KEY="${admin_password}" \
		RUSTFS_CONSOLE_ENABLE=true \
		rustfs server \
		"${1}" \
		--address "${host}:${port}" \
		--console-address "${host}:${web_port}" \
		&
}

# Function to setup signal handling
handlesignals() {
	for signal in INT TERM HUP QUIT; do
		trap 'kill -'"${signal}"' '"${1}"'; wait '"${1}"'; status=$?; cleanup; exit "${status}"' "${signal}"
	done
}

# Function to wait until RustFS is ready
waituntilready() {
	retries=30
	interval=1

	for i in $(seq 1 "${retries}"); do
		if [ "${i}" -eq "${retries}" ]; then
			echo 'Could not connect to RustFS!'
			return 1
		fi

		if rc alias set rustfs "http://localhost:${port}" "${admin_user}" "${admin_password}" >/dev/null 2>&1; then
			echo 'Connected to RustFS!'
			break
		else
			echo 'Waiting for RustFS to start...'
			sleep "${interval}"
		fi
	done
}

# Bucket setup function
setupbuckets() {
	echo 'Setting up buckets...'

	if rc bucket list rustfs | grep --quiet "${bucket}"; then
		echo "Bucket '${bucket}' already exists, skipping..."
	else
		rc bucket create --ignore-existing "rustfs/${bucket}"
	fi
}

# Policy setup function
setuppolicies() {
	echo 'Setting up policies...'

	rc admin policy create rustfs customReadonly src/policies/readonly.json
	rc admin policy create rustfs customReadwrite src/policies/readwrite.json
}

# User setup function
setupusers() {
	echo 'Setting up users...'

	if rc admin user ls rustfs | grep --quiet "${readonly_user}"; then
		echo "User ${readonly_user} already exists, skipping..."
	else
		rc admin user add rustfs "${readonly_user}" "${readonly_password}"
	fi

	if rc admin policy entities rustfs --user "${readonly_user}" | grep --quiet 'customReadonly'; then
		echo "Policy customReadonly already attached to user ${readonly_user}, skipping..."
	else
		rc admin policy attach rustfs customReadonly --user "${readonly_user}"
	fi

	if rc admin user ls rustfs | grep --quiet "${readwrite_user}"; then
		echo "User ${readwrite_user} already exists, skipping..."
	else
		rc admin user add rustfs "${readwrite_user}" "${readwrite_password}"
	fi

	if rc admin policy entities rustfs --user "${readwrite_user}" | grep --quiet 'customReadwrite'; then
		echo "Policy customReadwrite already attached to user ${readwrite_user}, skipping..."
	else
		rc admin policy attach rustfs customReadwrite --user "${readwrite_user}"
	fi
}

# Function to wait for RustFS to exit and handle cleanup
waitandcleanup() {
	wait "${1}"
	status=$?

	# Cleanup temporary files and directories
	cleanup

	exit "${status}"
}

### Main script execution

# Make sure the directory exists
mkdir --parents "${datadir}"

# Isolate client configuration
export RC_CONFIG_DIR="${tmpconfigdir}"

# Temporarily ignore signals
ignoresignals

# Start RustFS in the background
startrustfs "${datadir}"

# Setup signal handling
pid=$!
handlesignals "${pid}"

# Wait for RustFS to start
waituntilready

# Setup buckets
setupbuckets

# Setup policies
setuppolicies

# Setup users
setupusers

echo 'RustFS is ready!'

# Wait for RustFS to exit
waitandcleanup "${pid}"
