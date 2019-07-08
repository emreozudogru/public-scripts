#!/bin/bash

postqueue -p | awk '/^[0-9,A-F]/ {print $7}' | sort | uniq -c | sort -n
echo "Toplam"
echo "------------------"
mailq | grep -c "^[A-F0-9]"
