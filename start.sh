#!/bin/bash

# Create necessary directories
mkdir -p "${DATA_DIRECTORY:-./src/data}"
mkdir -p "${APP_DIRECTORY:-./src/data/app}"

# Start the actual application
node dist/index.js