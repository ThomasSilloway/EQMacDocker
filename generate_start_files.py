import os


# Function to convert Windows path to WSL path
def convert_to_wsl_path(path):
    path = path.replace("\\", "/")
    if path[1] == ':':
        path = f"/mnt/{path[0].lower()}{path[2:]}"
    return path


# List of manual batch file names
bat_names = [
    "start_1_db.bat",
    "start_2_shared.bat",
    "start_3_login.bat",
    "start_4_world.bat",
    "start_5_zone.bat",
    "start_6_queryserv.bat",
    "start_7_boats.bat"
]

# Get the base directory where the script is running
base_dir = os.path.dirname(os.path.abspath(__file__))
# Convert the base directory to WSL-compatible path
wsl_base_dir = convert_to_wsl_path(base_dir)

for bat_name in bat_names:
    # Extract service name by removing the number and extension
    service_name = bat_name.split('_', 2)[-1].replace('.bat', '')

    # Convert service name to uppercase for the title
    service_name_upper = service_name.upper()

    # Debugging output
    print(f"Generating scripts for service: {service_name}")

    # Updated script content to print the current directory
    sh_script_content = f"""#!/bin/bash
echo "Current directory: $(pwd)"  # Print the current directory
docker-compose up {service_name}
"""

    # Ensure Unix-style line endings by replacing \n with '\n' directly
    sh_script_content = sh_script_content.replace('\r\n', '\n')

    bat_script_content = f"""@echo off
title {service_name_upper}
wsl bash -c "cd {wsl_base_dir} && bash start_{service_name}.sh"
pause
"""

    # Write the .sh script in the base directory with Unix line endings
    sh_script_path = os.path.join(base_dir, f'start_{service_name}.sh')
    with open(sh_script_path, 'w', newline='\n') as sh_file:
        sh_file.write(sh_script_content)

    # Make the .sh script executable
    os.chmod(sh_script_path, 0o755)

    # Write the .bat file in the base directory
    bat_script_path = os.path.join(base_dir, bat_name)
    with open(bat_script_path, 'w') as bat_file:
        bat_file.write(bat_script_content)

print("Scripts generated successfully in the base directory.")
