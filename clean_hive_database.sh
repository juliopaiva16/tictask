#!/bin/zsh

echo "Cleaning Hive database..."

# Detect platform
if [[ $(uname) == "Darwin" ]]; then
    # macOS
    rm -rf ./hive/*
    echo "Hive database on macOS cleaned successfully."
elif [[ $(uname) == "Linux" ]]; then
    # Linux
    rm -rf ./hive/*
    echo "Hive database on Linux cleaned successfully."
elif [[ $(uname) == "MINGW"* ]] || [[ $(uname) == "MSYS"* ]]; then
    # Windows
    rm -rf ./hive/*
    echo "Hive database on Windows cleaned successfully."
else
    echo "Unknown platform, please manually delete the Hive database."
fi

echo "Done."
