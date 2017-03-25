function vim_plug_update
	vim -c "PlugUpgrade" -c "PlugInstall" -c "PlugUpdate" -c "PlugClean" -c "quitall"
end
