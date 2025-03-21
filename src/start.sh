#!/bin/sh

# Configuration

host="${MINIUM__SERVER__HOST:-0.0.0.0}"
port="${MINIUM__SERVER__PORTS__S3:-10210}"
web_port="${MINIUM__SERVER__PORTS__WEB:-10211}"
web_public_url="${MINIUM__URLS__WEB:-http://localhost:10211}"
admin_user="${MINIUM__CREDENTIALS__ADMIN__USER:-admin}"
admin_password="${MINIUM__CREDENTIALS__ADMIN__PASSWORD:-password}"
readonly_user="${MINIUM__CREDENTIALS__READONLY__USER:-readonly}"
readonly_password="${MINIUM__CREDENTIALS__READONLY__PASSWORD:-password}"
readwrite_user="${MINIUM__CREDENTIALS__READWRITE__USER:-readwrite}"
readwrite_password="${MINIUM__CREDENTIALS__READWRITE__PASSWORD:-password}"
bucket=default

# Start MinIO

MINIO_ROOT_USER="${admin_user}" \
	MINIO_ROOT_PASSWORD="${admin_password}" \
	MINIO_BROWSER_REDIRECT_URL="${web_public_url}" \
	minio server \
	data/ \
	--address "${host}:${port}" \
	--console-address "${host}:${web_port}" \
	--quiet \
	--anonymous \
	&

pid="$!"

# Wait for MinIO to start

echo "Setting up MinIO..."
echo

while ! mc config host add minio "http://localhost:${port}" "${admin_user}" "${admin_password}" >/dev/null 2>&1; do
	echo "Waiting for MinIO to start..."
	sleep 0.1
done

echo
echo "Connected to MinIO!"
echo

# Create buckets

echo "Setting up buckets..."
echo

if mc ls minio | grep --quiet "${bucket}"; then
	echo "Bucket '${bucket}' already exists, skipping..."
else
	mc mb --ignore-existing "minio/${bucket}"
fi

# Setup policies

echo
echo "Setting up policies..."
echo

mc admin policy create minio custom-readonly src/policies/readonly.json
mc admin policy create minio custom-readwrite src/policies/readwrite.json

# Create users

echo
echo "Setting up users..."
echo

if mc admin user ls minio | grep --quiet "${readonly_user}"; then
	echo "User ${readonly_user} already exists, skipping..."
else
	mc admin user add minio "${readonly_user}" "${readonly_password}"
fi

if mc admin policy entities minio --user "${readonly_user}" | grep --quiet "custom-readonly"; then
	echo "Policy custom-readonly already attached to user ${readonly_user}, skipping..."
else
	mc admin policy attach minio custom-readonly --user "${readonly_user}"
fi

if mc admin user ls minio | grep --quiet "${readwrite_user}"; then
	echo "User ${readwrite_user} already exists, skipping..."
else
	mc admin user add minio "${readwrite_user}" "${readwrite_password}"
fi

if mc admin policy entities minio --user "${readwrite_user}" | grep --quiet "custom-readwrite"; then
	echo "Policy custom-readwrite already attached to user ${readwrite_user}, skipping..."
else
	mc admin policy attach minio custom-readwrite --user "${readwrite_user}"
fi

# Summary

echo
echo "MinIO is ready!"
echo
echo "Host: ${host}"
echo "Port: ${port}"
echo "Web port: ${web_port}"
echo "Web public URL: ${web_public_url}"
echo
echo "Admin user: ${admin_user}"
echo "Read-only user: ${readonly_user}"
echo "Read-write user: ${readwrite_user}"
echo
echo "Bucket: ${bucket}"

# Wait for MinIO to exit

wait "${pid}"
