scriptencoding utf-8
                               "  # TO タグ        FROM 行    in file/text
                               " 12  1 'fileformat'@ja   421  システムや 'fileformat' に依存)^I*<EOL>*
                               ">
let s:current_tag_pattern = '\v\s+(\d+)\s+(\d+)\s+(\S+)\@(\S+)\s+[^\n]*\n\>'

function! s:getLangList() abort
    let lang_list = split(&helplang, ',')
    if (index(lang_list, 'en') < 0)
        call add(lang_list, 'en') " default
    endif
    return lang_list
endfunction

function! s:getNextLang(lang) abort
    let lang_list = s:getLangList()
    let next_lang = get(lang_list, index(lang_list, a:lang) + 1, lang_list[0])
    return next_lang
endfunction

function! s:getNextTag(tag_info) abort
    let tag = a:tag_info[3]
    let lang = a:tag_info[4]
    let next_lang = s:getNextLang(lang)
    let next_tag = tag . '@' . next_lang
    return next_tag
endfunction

function! switch_help_lang#switchHelpLang() abort
    let tags_result = execute(':tags')
    let current_tag_info = matchlist(tags_result, s:current_tag_pattern)
    if empty(current_tag_info)
        return
    endif

    let next_tag = s:getNextTag(current_tag_info)
    execute ':help ' . next_tag
endfunction
