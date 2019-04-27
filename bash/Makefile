.PHONY: all
all: load_bash load_inputrc clean

load_bash: /home/$(USER)/.config/bash/.bashrc
	cp /home/$(USER)/.config/bash/.bashrc.default /home/$(USER)/.config/bash/.bashrc.default.tmp
	sed -i "s|USER|$(USER)|" /home/$(USER)/.config/bash/.bashrc.default.tmp
	cp /home/$(USER)/.config/bash/.bashrc.default.tmp /home/$(USER)/.bashrc
	echo "Please run '. ~/.bashrc' or close and reopen terminal"

load_inputrc: /home/$(USER)/.config/bash/.inputrc
	cp /home/$(USER)/.config/bash/.inputrc.default /home/$(USER)/.config/bash/.inputrc.default.tmp
	sed -i "s|USER|$(USER)|" /home/$(USER)/.config/bash/.inputrc.default.tmp
	cp /home/$(USER)/.config/bash/.inputrc.default.tmp /home/$(USER)/.inputrc
	echo "Please close and reopen terminal"

.PHONY: clean
clean:
	-rm /home/$(USER)/.config/bash/.bashrc.default.tmp
	-rm /home/$(USER)/.config/bash/.inputrc.default.tmp
