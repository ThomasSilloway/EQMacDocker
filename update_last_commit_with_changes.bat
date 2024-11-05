@echo off
REM Navigate to the Server directory
cd /d %~dp0Server

REM Ensure we are in a Git repository
if not exist .git (
    echo "No Git repository found in the Server directory."
    exit /b 1
)

REM Print the current branch
for /f "delims=" %%i in ('git rev-parse --abbrev-ref HEAD') do set "current_branch=%%i"
echo "Operating on branch: %current_branch%"

REM Stage current changes
git add -A

REM Print the status after staging
echo "About to amend the commit with these changes:"
git status --short

REM Display the changes in the files
git diff --cached

REM Get the original commit message of the second-to-last commit
setlocal enabledelayedexpansion
set "original_commit_message="

REM Use a temporary file to store the commit message
set "temp_file=%temp%\commit_message.txt"
git log -1 --pretty=format:"%%B" > "%temp_file%"

REM Build the git commit command with multiple -m options
set "commit_command=git commit --amend"
for /f "tokens=*" %%i in (%temp_file%) do (
    REM echo %%i
    set "commit_command=!commit_command! -m "%%i""
)

REM Do not delete the temporary file so it can be inspected
del "%temp_file%"

endlocal & set "commit_command=%commit_command%"

REM Print the commit command
echo "Commit command: %commit_command%"

REM Ask for confirmation to proceed
set /p proceed="Do you want to proceed with squashing these commits? (Y/N): "
if /i not "%proceed%"=="Y" (
    echo "Aborting the squashing process."
    exit /b 1
)

REM Uncomment the following lines to actually execute the commands
%commit_command%
