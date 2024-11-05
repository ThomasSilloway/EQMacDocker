@echo off
title WORLD
wsl bash -c "cd /mnt/c/GithubRepos/QuarmDocker && docker-compose up world"
