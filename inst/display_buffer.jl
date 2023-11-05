function display_buffer(res)
    buf = IOBuffer();
    td = TextDisplay(buf);
    display(td, res);
    String(take!(buf))
end