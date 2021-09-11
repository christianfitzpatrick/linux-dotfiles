#!/bin/bash

pgrep -x spotify >/dev/null && jumpapp spotify || spotify
