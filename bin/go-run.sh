#!/bin/bash

# Errors are fatal
set -e

#
# Default targets include Google, their DNS resolver, and CloudFlare's DNS resolver.
#
TARGETS="google.com 8.8.8.8 1.1.1.1"

if test "$1" == "-h" -o "$1" == "--help"
then
	echo "! "
	echo "! Syntax: $0 [ host [ host [ ... ] ] ]"
	echo "! "
	echo "! host - Specify a host to monitor in addition to the defaults"
	echo "! "
	exit 1
fi

#
# If a target was specified, add it onto the defaults.
#
if test "$1"
then
	TARGETS="${TARGETS} $@"
fi


#
# Switch to the directory where this script lives and go up a directory
#
pushd $(dirname $0) >/dev/null
cd ..

echo "# "
echo "# Pulling latest version of container"
echo "# "
docker pull dmuth1/splunk-network-monitor

echo "# "
echo "# Starting container run..."
echo "# "
echo "# Target setting: ${TARGETS}"
echo "# "
docker run --restart unless-stopped --name splunk \
	-d \
	-e "TARGETS=${TARGETS}" \
	-e TZ=EST5EDT \
	-p 8000:8000 \
	-v $(pwd)/splunk-network-monitor-data:/opt/splunk/var/lib/splunk/defaultdb \
	-v $(pwd):/mnt \
	--privileged \
	splunk


