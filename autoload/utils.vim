" Purpose: General purpose utilities

function! utils#mkdir(path) abort
	if !isdirectory(a:path)
		let b:path = a:path
		autocmd MkdirAutocmd BufWritePre <buffer>
					\ call mkdir(b:path, 'p')
					\ | unlet b:path
					\ | autocmd! MkdirAutocmd  * <buffer>
	endif
endfunction

