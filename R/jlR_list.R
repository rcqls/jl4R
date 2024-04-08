## Convert to Tuple or NamedTuple
as_jlValue.list <-  function(obj, ...) {
    if(!.jlrunning()) .jlinit()
    .RNamedList2jlNamedTuple(obj)
   # .RNamedlist2jlDict(obj)
}
