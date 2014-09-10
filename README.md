#Text::Markdown::Discount

Perl 6 bindings to Discount, a Markdown compiler (aka libmarkdown).

Note that Discount must be compiled as a shared lib (`./configure.sh --shared` in the discount repository): otherwise NativeCall cannot access it.

### SYNOPSIS

    use Text::Markdown::Discount

    # simple API
    my $markdown = "_italicized_";
    my $html = markdown-to-html $markdown;
    # '<p><em>italicized</em><p>'

    # OO API
    my $markdown = "% Discount and Perl 6 \n% Camelia \n% A few hours ago \n__it is great!__";
    my $doc = MMIOT.new($markdown);
    # $doc.gist == $doc.html == '<p><strong>it is great!</strong><p>'
    say $doc.title;
    # "Discount and Perl 6"

    # using flags
    my $scary-link = "[the goog](google.com)";
    my $html-sans-link = markdown-to-html $scary-link, <no-links>;
    # or
    my $sanitized-doc = MMIOT.new($scary-link, <no-links>);
    # $html == $sanitized-doc.html == '<p>[the goog](google.com)</p>'

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

### WHAT ON EARTH IS 'MMIOT'?

The name of the Discount document object: "Magical Markdown IO Thing".

### TODO

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
