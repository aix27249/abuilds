#!/bin/sh
if id transmission; then
	echo "transmission user already exists."
else
	echo "Creating transmission user..."
	useradd -M transmission
fi
