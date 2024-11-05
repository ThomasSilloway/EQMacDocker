@echo off
title QUERYSERV
wsl bash -c "cd /mnt/c/GithubRepos/QuarmDocker && docker-compose up queryserv"
