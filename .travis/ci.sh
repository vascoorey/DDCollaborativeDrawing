#!/bin/sh
set -e

xctool -workspace DDCollaborativeDrawing -scheme DDCollaborativeDrawing build test
