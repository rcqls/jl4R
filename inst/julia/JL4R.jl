module JL4R

function display_buffer(res)
    buf = IOBuffer();
    td = TextDisplay(buf);
    display(td, res);
    String(take!(buf))
end

function funcfind(name)
    r = Main
    ns = split(name, ".")
    for n in ns
        r = getfield(r, Symbol(n))
    end
    r
end

function safe_call(fname, args...; kwargs...)
    try
        # if endswith(fname, ".")
        #     fname = chop(fname);
        #     # f = eval(Main, parse(fname));
        #     f = funcfind(fname);
        #     r = broadcast(f, args...);
        # else
            f = funcfind(fname);
            f(args...; kwargs...);
        # end
    catch e
        showerror(stdout,e)
    end;
end

end