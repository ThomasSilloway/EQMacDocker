@echo off
title DB
wsl bash -c "cd /mnt/c/GithubRepos/QuarmDocker && docker-compose up db"
