" This program is free software: you can redistribute it and/or modify
" it under the terms of the GNU Lesser General Public License as published by
" the Free Software Foundation, either version 3 of the License, or
" (at your option) any later version.
"
" This program is distributed in the hope that it will be useful,
" but WITHOUT ANY WARRANTY; without even the implied warranty of
" MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
" GNU General Public License for more details.
"
" You should have received a copy of the GNU Lesser General Public License
" along with this program.  If not, see <http://www.gnu.org/licenses/>.


" File: localcomplete.vim
" Author: Dirk Wallenstein
" Description: Combinable completion functions for Vim
" License: LGPLv3
" Version: 1.0.1


if (exists("g:loaded_localcomplete") && g:loaded_localcomplete)
    finish
endif
let g:loaded_localcomplete = 1

if ! exists( "g:localcomplete#LinesAboveToSearchCount" )
    " The count of lines before the cursor position to inspect.
    " Specify a negative value to search up to the beginning of the buffer.
    " Override buffer locally with b:LocalCompleteLinesAboveToSearchCount
    let g:localcomplete#LinesAboveToSearchCount = -1
endif

if ! exists( "g:localcomplete#LinesBelowToSearchCount" )
    " The count of lines before the cursor position to inspect.
    " Specify a negative value to search up to the end of the buffer
    " Override buffer locally with b:LocalCompleteLinesBelowToSearchCount
    let g:localcomplete#LinesBelowToSearchCount = 20
endif

if ! exists( "g:localcomplete#WantIgnoreCase" )
    " Ignore case when looking for local and all-buffer matches.
    " Override buffer locally with b:LocalCompleteWantIgnoreCase
    let g:localcomplete#WantIgnoreCase = 1
endif

if ! exists( "g:localcomplete#MatchResultOrder" )
    " Configure in what order matches from localcomplete#localMatches are
    " added to the completion menu:
    " 1 - centered: current line, then alternately lines from above and below
    " 2 - normal: top to bottom
    " 3 - reverse: bottom to top
    " 4 - normal, below first: current line to bottom, then top to current line
    " 5 - reverse, above first: current line to top, then bottom to current line
    "
    " Override buffer locally with b:LocalCompleteMatchResultOrder
    let g:localcomplete#MatchResultOrder = 1
endif

if ! exists( "g:localcomplete#ShowOriginNote" )
    " Add a sign in the completion menu that shows from which completion
    " method of this file the entry originates.
    " Override buffer locally with b:LocalCompleteShowOriginNote
    let g:localcomplete#ShowOriginNote = 1
endif

if ! exists( "g:localcomplete#AdditionalKeywordChars" )
    " Add these characters to the alphanumerical characters that are always
    " searched for.  You can for example set it to ':#' for Vim files, to be
    " able to complete this variable as one word.  Set it to the special
    " string '&iskeyword' to derive additional characters from Vim's iskeyword
    " setting.  In that case all single characters between commas will be
    " added.  This is used at the right side of a character set for a Python
    " regular expression.  Don't use characters that are special there.  In
    " particular backslashes.  If you want to add a hyphen, put it on the far
    " right.
    " Override buffer locally with b:LocalCompleteAdditionalKeywordChars
    let g:localcomplete#AdditionalKeywordChars = ''
endif

" =============================================================================

" XXX Note that all the length variables take effect _after_ the ACP-meets
" function restrictions.  So there is a minimum specified by ACP, too.

if ! exists( "g:localcomplete#DictMinPrefixLength" )
    " Add dictionary matches if the prefix has this lenght minimum
    " Override buffer locally with b:LocalCompleteDictMinPrefixLength
    let g:localcomplete#DictMinPrefixLength = 5
endif

if ! exists( "g:localcomplete#LocalMinPrefixLength" )
    " Add local matches if the prefix has this lenght minimum
    " Override buffer locally with b:LocalCompleteLocalMinPrefixLength
    let g:localcomplete#LocalMinPrefixLength = 1
endif

if ! exists( "g:localcomplete#AllBuffersMinPrefixLength" )
    " Add local matches if the prefix has this lenght minimum
    " Override buffer locally with b:LocalCompleteAllBuffersMinPrefixLength
    let g:localcomplete#AllBuffersMinPrefixLength = 1
endif

" =============================================================================

if ! exists( "g:localcomplete#OriginNoteLocalcomplete" )
    " Change the localcomplete result origin sign.
    let g:localcomplete#OriginNoteLocalcomplete = '<< localcomplete'
endif

if ! exists( "g:localcomplete#OriginNoteAllBuffers" )
    " Change the all-buffers result origin sign.
    let g:localcomplete#OriginNoteAllBuffers = '<+ all-buffers'
endif

if ! exists( "g:localcomplete#OriginNoteDictionary" )
    " Change the dictionary result origin sign.
    let g:localcomplete#OriginNoteDictionary = '<* dict'
endif

" =============================================================================

if ! exists( "g:localcomplete#WantIgnoreCaseDict" )
    " Ignore case when looking for matches in the dictionary
    " Override buffer locally with b:LocalCompleteWantIgnoreCaseDict
    let g:localcomplete#WantIgnoreCaseDict = 0
endif

" =============================================================================

" Variable Fallbacks
" ------------------

function s:variableFallback(variableList)
    for l:variable in a:variableList
        if exists(l:variable)
            let l:result_number = eval(l:variable)
            return l:result_number
        endif
    endfor
    throw "None of the variables exists: " . string(a:variableList)
endfunction

function localcomplete#getAdditionalKeywordChars()
    let l:variableList = [
                \ "b:LocalCompleteAdditionalKeywordChars",
                \ "g:localcomplete#AdditionalKeywordChars"
                \ ]
    return s:variableFallback(l:variableList)
endfunction

" -----------------------------------------------------------------------------

function s:numericVariableFallback(variableList, wantEnforceNonNegative)
    for l:variable in a:variableList
        if exists(l:variable)
            let l:result_number = eval(l:variable)
            if a:wantEnforceNonNegative && l:result_number < 0
                throw "Variable " . l:variable . "less than zero"
            endif
            return l:result_number
        endif
    endfor
    throw "None of the variables exists: " . string(a:variableList)
endfunction

function localcomplete#getLinesBelowCount()
    let l:variableList = [
                \ "b:LocalCompleteLinesBelowToSearchCount",
                \ "g:localcomplete#LinesBelowToSearchCount"
                \ ]
    return s:numericVariableFallback(l:variableList, 0)
endfunction

function localcomplete#getLinesAboveCount()
    let l:variableList = [
                \ "b:LocalCompleteLinesAboveToSearchCount",
                \ "g:localcomplete#LinesAboveToSearchCount"
                \ ]
    return s:numericVariableFallback(l:variableList, 0)
endfunction

function localcomplete#getDictMinPrefixLength()
    let l:variableList = [
                \ "b:LocalCompleteDictMinPrefixLength",
                \ "g:localcomplete#DictMinPrefixLength"
                \ ]
    return s:numericVariableFallback(l:variableList, 1)
endfunction

function localcomplete#getLocalMinPrefixLength()
    let l:variableList = [
                \ "b:LocalCompleteLocalMinPrefixLength",
                \ "g:localcomplete#LocalMinPrefixLength"
                \ ]
    return s:numericVariableFallback(l:variableList, 1)
endfunction

function localcomplete#getAllBufferMinPrefixLength()
    let l:variableList = [
                \ "b:LocalCompleteAllBuffersMinPrefixLength",
                \ "g:localcomplete#AllBuffersMinPrefixLength"
                \ ]
    return s:numericVariableFallback(l:variableList, 1)
endfunction

function localcomplete#getWantIgnoreCase()
    let l:variableList = [
                \ "b:LocalCompleteWantIgnoreCase",
                \ "g:localcomplete#WantIgnoreCase"
                \ ]
    return s:numericVariableFallback(l:variableList, 1)
endfunction

function localcomplete#getWantIgnoreCaseDict()
    let l:variableList = [
                \ "b:LocalCompleteWantIgnoreCaseDict",
                \ "g:localcomplete#WantIgnoreCaseDict"
                \ ]
    return s:numericVariableFallback(l:variableList, 1)
endfunction

function localcomplete#getMatchResultOrder()
    let l:variableList = [
                \ "b:LocalCompleteMatchResultOrder",
                \ "g:localcomplete#MatchResultOrder"
                \ ]
    return s:numericVariableFallback(l:variableList, 1)
endfunction

function localcomplete#getWantOriginNote()
    let l:variableList = [
                \ "b:LocalCompleteShowOriginNote",
                \ "g:localcomplete#ShowOriginNote"
                \ ]
    return s:numericVariableFallback(l:variableList, 1)
endfunction

" =============================================================================

" Helpers
" -------

function s:getLineUpToCursor()
    return strpart(getline('.'), 0, col('.') - 1)
endfunction

function s:getCurrentKeyword()
    return matchstr(s:getLineUpToCursor(), '\k*$')
endfunction

function localcomplete#getCurrentKeywordColumnIndex()
    " Note : return a zero based column index
    let l:start_col = col('.') - len(s:getCurrentKeyword()) - 1
    return max([l:start_col, 0])
endfunction

function s:is_keyword_minimum_reached(keyword_base, min_length)
    let l:word_width = strwidth(a:keyword_base)
    if l:word_width < a:min_length
        return 0
    else
        return 1
    endif
endfun

" Completion functions
" --------------------

function localcomplete#localMatches(findstart, keyword_base)
    " Suggest matches looking at the region around the current cursor position
    " or the whole file.  The configuration at the top of this file applies.
    if a:findstart
        LCPython import localcomplete
        LCPython localcomplete.findstart_local_matches()
        return s:__localcomplete_lookup_result_findstart
    else
        LCPython import localcomplete
        LCPython localcomplete.complete_local_matches()
        return s:__localcomplete_lookup_result
    endif
endfunction

function localcomplete#allBufferMatches(findstart, keyword_base)
    " Search all buffers for matches.  Results from the current buffer will
    " come first.  The ignore-case and keyword-chars configuration from the
    " top of this file will be respected.
    if a:findstart
        LCPython import localcomplete
        LCPython localcomplete.findstart_local_matches()
        return s:__localcomplete_lookup_result_findstart
    else
        LCPython import localcomplete
        LCPython localcomplete.complete_all_buffer_matches()
        return s:__buffercomplete_lookup_result
    endif
endfunction

function localcomplete#dictMatches(findstart, keyword_base)
    " Search the file specified in the dictionary option for matches.  The
    " search is always performed case-insensitively.  The dictionary has
    " to be "utf-8" encoded.
    if a:findstart
        return localcomplete#getCurrentKeywordColumnIndex()
    else
        if !s:is_keyword_minimum_reached(a:keyword_base,
                    \ localcomplete#getDictMinPrefixLength())
            return []
        endif
        LCPython import localcomplete
        LCPython localcomplete.complete_dictionary_matches()
        return s:__dictcomplete_lookup_result
    endif
endfunction

" ----------- Python prep

if has('python')
    command! -nargs=1 LCPython python <args>
elseif has('python3')
    command! -nargs=1 LCPython python3 <args>
else
    echoerr "No Python support found"
end

LCPython << PYTHONEOF
import sys, os, vim
sys.path.insert(0, os.path.join(vim.eval("expand('<sfile>:p:h:h')"), 'pylibs'))
PYTHONEOF
