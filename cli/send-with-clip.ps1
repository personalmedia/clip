$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

& "$scriptDir\clip.sh" $args
