# Twitter Video Fixer Script

A bash script that re-encodes video files for better compatibility with X (formerly Twitter), ensuring optimal playback and quality while meeting platform requirements.
https://github.com/igoros777/x/blob/main/winreg/twitter_video_fixer.sh

## Overview

The script monitors a downloads directory for video files and automatically re-encodes them using FFmpeg with parameters optimized for X's video player.

## Prerequisites

- Bash shell environment
- FFmpeg installed
- Sufficient disk space for temporary processing
- Write access to the target directory

## Configuration

### Default Settings

- Input Directory: `/mnt/c/Users/igor/Downloads`
- Supported File Types: `.mp4`, `.mov`
- Processing Limit: Last 10 files by default (configurable via command line)
- Output Resolution: Scaled to 640px width while maintaining aspect ratio
- Frame Rate: 30 FPS
- Video Codec: H.264
- Audio Codec: AAC
- Audio Sample Rate: 44.1 kHz
- Video Quality: CRF 20 (constant rate factor)

## Usage

```bash
./twitter_video_fixer.sh [number_of_files]
```

### Parameters

- `number_of_files`: Optional. Number of recent videos to process (default: 10)

## Process Flow

1. Script changes to the configured input directory
2. Identifies the most recent video files (MP4 or MOV) that haven't been processed
3. For each file:
   - Generates a random filename for the output
   - Re-encodes using FFmpeg with Twitter-optimized settings
   - Removes the original file upon successful conversion
   - Outputs the name of the processed file

## FFmpeg Parameters Explained

- `-threads $(nproc)`: Utilizes all available CPU threads
- `-vcodec libx264`: Uses H.264 video codec
- `-vf 'scale=640:ih*640/iw,scale=trunc(iw/2)*2:trunc(ih/2)*2'`: 
  - Scales video to 640px width
  - Maintains aspect ratio
  - Ensures dimensions are even numbers (required for H.264)
- `-acodec aac`: Uses AAC audio codec
- `-b:v 0`: Allows CRF to control quality
- `-crf 20`: Sets constant rate factor for quality control
- `-ar 44100`: Sets audio sample rate to 44.1 kHz
- `-r 30`: Sets output frame rate to 30 FPS

## File Naming

- Output files are appended with `_tvf` before the extension
- A random 32-character alphanumeric string is prepended to avoid naming conflicts

## Notes

- Original files are automatically deleted after successful conversion
- The script preserves the original file extension
- Files already containing `_tvf` in the name are skipped to prevent re-processing
- The script uses IFS manipulation to handle filenames with spaces
