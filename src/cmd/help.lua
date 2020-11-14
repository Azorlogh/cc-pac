local HELP = " \
usage: pac <cmd> [...] \
In the following section, <pkg> represents a package directory. \
and <name> represents a package name. \
commands: \
  pac help \
    Display this message. \
  pac list \
    List package names on server. \
  pac info <name> \
	Display info on specified package. \
  pac install (-l pkg | name) \
	Install from local package dir <pkg>, \
	or <name> from the pac server. \
  pac uninstall <name> \
	Uninstall <name> from this computer. \
  pac upload <pkg> \
    Upload <pkg> on the pac server. \
"

return function()
	print(HELP)
end
