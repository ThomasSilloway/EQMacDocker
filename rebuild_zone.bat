@echo off
title ZONE
REM shutdown world and zone with docker-compose then rebuild zone after that's complete

wsl bash -c "cd /mnt/c/GithubRepos/QuarmDocker && docker-compose stop zone world && docker-compose up --build zone"
