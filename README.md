ready-suspend
==================================================

A script which spawn a process and suspend when specified process is running and continue if specified process are exited.

# How to use
`ruby ready-suspend.rb [-i INTERVAL] [-c COMMAND_NAME] command`

* -i, --interval INERVAL
    * An interval for fetching processes. A unit is second. Use 15 seconds as a default.
* -c, --command COMMAND\_NAME
    * What name of process to suspend if it is running. For example, you use `-c bash` if you want to suspend when bash is running.
    * This option can use serveral times. A script suspends a spawned process when bash or zsh is running if you use `-c bash -c zsh`.
* command
    * A command to run and suspend automatically.

