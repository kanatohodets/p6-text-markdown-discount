#Text::Markdown::Discount

Perl 6 bindings to Discount, a Markdown compiler (aka libmarkdown).

Note that Discount must be compiled as a shared lib (`./configure.sh --shared` in the discount repository): otherwise NativeCall cannot access it.

### SYNOPSIS

    use Text::Markdown::Discount
    my $markdown = "_italicized_";
    my $html = markdown-to-html $markdown;
    # '<p><em>italicized</em><p>'

    my $scary-link = "[the goog](google.com)";
    my $html-sans-link = markdown-to-html $scary-link, :flags<no-links>;
    # '<p>[the goog](google.com)</p>'

### DISCOUNT FLAGS

Discount accepts a large number of flags to control the parsing/compiling process. Here's the complete list. For a description of what they do, see the [discount documentation](http://www.pell.portland.or.us/~orc/Code/discount/)

    no-links
    no-image
    no-pants
    no-html
    strict
    tagtext
    no-extensions
    cdata
    no-superscript
    no-relaxed
    no-tables
    no-strikethrough
    toc
    one-compat
    auto-link
    safe-link
    no-header
    tabstop
    no-div-quote
    no-alphalist
    no-definition-list
    extra-footnote
    no-style

### TODO

0. expose more of discount's API (table of contents, header access, style functions, etc.)
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
