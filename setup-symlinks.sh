for prog in 'fish' 'nvim' 'ghostty'; do
	mv $HOME/.config/$prog $HOME/.config/$prog.old
	ln -s $(realpath .)/$prog $HOME/.config/$prog
done
