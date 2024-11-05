@echo off
title LOGIN
wsl bash -c "cd /mnt/c/GithubRepos/QuarmDocker && docker-compose up login"
