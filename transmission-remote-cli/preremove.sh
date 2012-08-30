#!/bin/sh
if id transmission; then
	echo "Removing transmission user..."
	userdel transmission
else
	echo "transmission user doesn't exist."
fi
