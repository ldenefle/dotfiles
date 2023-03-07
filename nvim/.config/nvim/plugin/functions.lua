
-- in-situ reversal
function reverse(t)
  local n = #t
  local i = 1
  while i < n do
    t[i],t[n] = t[n],t[i]
    i = i + 1
    n = n - 1
  end
end

function split(s)
    chunks = {}
    for substring in s:gmatch("%S+") do
       table.insert(chunks, substring)
    end
    return chunks
end

function reverse_words(s)
    a = split(s)
    reverse(a)
    return table.concat(a, " ")
end

function replace_timestamp(s)
    t = require "luatz.timetable".new_from_timestamp(tonumber(s))
    return t:rfc_3339()
end
