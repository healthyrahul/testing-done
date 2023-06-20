#!/bin/sh -l

echo "Hello People >> $1"
time=$(date)
echo "time=$time" >> $GITHUB_OUTPUT
