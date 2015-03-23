-- helper to iterate through "..." without creating a new garbage table
do
  local i, t, l = 0, {}
  local function iter(...)
    i = i + 1
    if i > l then return end
    return i, t[i]
  end

  function vararg(...)
    i = 0
    l = select("#", ...)
    for n = 1, l do
      t[n] = select(n, ...)
    end
    for n = l+1, #t do
      t[n] = nil
    end
    return iter
  end
end