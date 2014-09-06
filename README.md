#Text::Markdown::Discount

Perl 6 bindings to Discount, a Markdown compiler (aka libmarkdown).

Note that Discount must be compiled as a shared lib (`./configure.sh --shared`): otherwise NativeCall cannot access it.

### SYNOPSIS

    use Text::Markdown::Discount
    my $markdown = "_italicized_";
    my $html = markdown-to-html $markdown; # '<p><em>italicized</em><p>'

### TODO

0. expose more of discount's API (flags, table of contents, switches, etc.)
1. more tests

### LICENSE

Artistic License 2.0

### CREDITS

* The wonderful NativeCall module
* moritz and geekosaur on freenode #perl6 (C wisdom)
* Discount

### SEE ALSO

[Text::Markdown](http://github.com/masak/markdown)

[Discount](http://www.pell.portland.or.us/~orc/Code/discount)
