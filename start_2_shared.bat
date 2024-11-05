@echo off
title SHARED
wsl bash -c "cd /mnt/c/GithubRepos/QuarmDocker && docker-compose up shared"
