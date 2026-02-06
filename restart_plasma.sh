#!/bin/bash

nohup kwin_wayland --replace &
sleep 1
nohup plasmashell --replace &
sleep 1