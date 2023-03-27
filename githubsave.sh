#!/bin/bash
git status
git add .
git commit -m $(/bin/date "+%Y%m%d-%H%M%S")
git push -u origin main