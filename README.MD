# Wake Script Usage Guide

## Overview

This script is used to manage Amphetamine sessions on macOS, allowing users to keep their Mac awake until a specified time. Amphetamine is an application that prevents macOS from going to sleep, and this script provides an easy way to start, stop, and check the status of Amphetamine sessions through the command line.

## Prerequisites

- macOS with Amphetamine installed (available on the App Store).
- The Amphetamine application should be installed in the `/Applications` folder.

## Usage

The script provides the following commands:

### Starting a Wake Session

To start a wake session, provide a time in 12-hour format with either `am` or `pm` suffix. The script will calculate the duration until the specified time and start an Amphetamine session accordingly.

**Usage:**

```sh
./wake.sh <time>
```

**Examples:**

- Start a session until 1:30 AM:
  ```sh
  ./wake.sh 130am
  ```
- Start a session until 11:30 PM:
  ```sh
  ./wake.sh 1130pm
  ```
- Start a session until 5 PM:
  ```sh
  ./wake.sh 5pm
  ```

### Stopping a Wake Session

To stop an active Amphetamine session:

**Usage:**

```sh
./wake.sh stop
```

This command will end the current Amphetamine session and delete any temporary files used by the script.

### Checking the Status of a Wake Session

To check if there is an active Amphetamine session and view the remaining time:

**Usage:**

```sh
./wake.sh check
```

This command will display whether there is an active Amphetamine session and how much time remains in the session.

## Details

### Time Input Format

The script accepts time in the following formats:

- **Single-digit hour:** `1am`, `5pm`
- **Two-digit hour:** `11am`, `11pm`
- **Three-digit hour and minutes:** `130am`, `530pm`
- **Four-digit hour and minutes:** `1130pm`

If the time is specified incorrectly, the script will provide an error and prompt you to use the correct format.

### Example Command Workflow

1. **Start a Session**: To keep your Mac awake until 2:30 PM:

   ```sh
   ./wake.sh 230pm
   ```

2. **Check Status**: To see if the wake session is still active:

   ```sh
   ./wake.sh check
   ```

   Output:
   ```
   Wake process active: 1h 30m remaining
   ```

3. **Stop the Session**: To manually end the session:

   ```sh
   ./wake.sh stop
   ```

   Output:
   ```
   Stopped wake process
   ```

## How the Script Works

- The script converts the provided time to a 24-hour format using the `convert_to_24hr` function.
- It calculates the duration until the specified time and initiates an Amphetamine session using `osascript` to execute the AppleScript commands.


## Notes

- If the specified time is earlier than the current time, the script will calculate the duration for the next day.
- The script requires `osascript` to communicate with the Amphetamine app.

## Error Handling

- **Invalid Time Format**: If the input time format is invalid, the script will display an error message and exit.
- **No Active Session**: If the `check` command is used and there is no active Amphetamine session, the script will inform you accordingly.

## License

This script is open-source and can be used and modified under the terms of the MIT License.

