# Script Documentation: `unrar_here_mk3.sh`

## Overview

This Bash script automates the extraction of `.rar` archive files with specific configurations. It processes `.rar` files by sanitizing their filenames, extracting desired files based on predefined extensions, and handling parallel processing to optimize resource usage.

https://github.com/igoros777/x/blob/main/bash/unrar_here_mk3.sh

------

## Features

- **Filename Sanitization**: Removes invalid characters and ensures unique filenames.
- **Parallel Processing**: Uses multiple cores for concurrent extractions.
- **Targeted Extraction**: Extracts files matching specific extensions.
- **Error Handling**: Logs errors and halts cleanup if issues occur.
- **Configurable Behavior**: Modify file extensions, unrar options, and other parameters as needed.

------

## Usage

1. Change to the directory containing the RAR archives.

2. Execute the script:

   ```bash
   ${full_path}/unrar_here_mk3.sh
   ```

3. Review the generated log file (`unrar_log_<timestamp>.log`) for operation details.

------

## Configuration

### Variables

| Variable      | Description                                                  | Default Value                                  |
| ------------- | ------------------------------------------------------------ | ---------------------------------------------- |
| `extensions`  | Comma-separated list of file extensions to extract from `.rar` archives. | `pdf,epub,mkv,avi,mp4,mp3,flac`                |
| `unrar_opts`  | Options passed to the `unrar` command.                       | `e -kb -o+`                                    |
| `log_file`    | Log file for operation status and error messages.            | `unrar_log_<timestamp>.log`                    |
| `status_file` | Temporary file for tracking operation success/failure.       | Generated using `mktemp`                       |
| `max_jobs`    | Maximum number of parallel extraction jobs.                  | Determined by system cores (up to 4 max jobs). |

------

## Script Behavior

1. **Initialization**:
   - Sets up variables and creates a log file.
   - Registers a cleanup handler to remove temporary files on exit.
2. **Filename Sanitization**:
   - Identifies `.rar` files with problematic characters.
   - Renames files to sanitized versions while avoiding name collisions.
3. **Extraction**:
   - Searches for `.rar` files.
   - Extracts files matching specified extensions using `unrar`.
   - Executes extractions in parallel to optimize performance.
4. **Status Check**:
   - Verifies extraction success by analyzing `status_file`.
   - Proceeds with cleanup if all extractions succeed.
5. **Cleanup**:
   - Removes all `.rar` files if no errors occurred.
   - Halts cleanup and logs details if errors are detected.

------

## Logs and Error Handling

- Log File

  :

  - All operations, errors, and statuses are recorded in `unrar_log_<timestamp>.log`.

- Error Handling

  :

  - If any extraction fails, cleanup is halted, and the error is logged for review.

------

## Requirements

- `bash` shell
- `unrar` utility installed and accessible in `$PATH`
- A system supporting POSIX-compliant `find` and `xargs`

------

## Example Log Output

```
Starting unrar operation at 2025-01-12 14:00:00
Renaming problematic filenames...
Extracting files from archives...
All unrar operations successful. Proceeding with cleanup.
Removed: ./example_file.rar
```

------

## Notes

- Customize the `extensions` variable for additional file types as needed.
- Ensure sufficient disk space for extracted files.

------

## Author

**Igor Os**
 [igor@igoros.com](mailto:igor@igoros.com)

Date: **2025-01-12**

------