use v6;
use NativeCall;

my @flags = <
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
>;

# set up the link between the flag names and the numbers Discount expects.
# (the ordering of the above list is important)
my %flag-mapping = @flags.kv.map(-> $index, $flag {$flag => 2 ** $index});

my class MMIOT is repr('CPointer') { }

# hack to be able to access the buffer contents after discount performs
# mkd_document.
my class StringBuf is repr('CStruct') {
    has Str $.text;
}

sub mkd_string(Str, int, int) returns MMIOT is native("libmarkdown") { ... };
sub mkd_compile(MMIOT, int) returns int is native("libmarkdown") { ... };
sub mkd_document(MMIOT, StringBuf) returns int is native("libmarkdown") { ... };

my sub build-and-compile(Str $markdown, int $flags) {
    my $doc = mkd_string($markdown, $markdown.chars, $flags);
    my $res = mkd_compile($doc, $flags);
    my $output := StringBuf.new();
    #takes a MMIOT pointer plus a **char buffer
    $res = mkd_document($doc, $output);
    return $output.text;
}

my sub flags(*@flags) {
    my $flag-mask = 0;
    for @flags -> $flag-name {
        if $flag-name {
            if %flag-mapping{$flag-name}:exists {
                $flag-mask +|= %flag-mapping{$flag-name};
            } else {
                die "unknown discount flag name \"$flag-name\". \nValid flags: \n\t{%flag-mapping.keys.join("\n\t")}";
            }
        }
    }

    return $flag-mask;
}

multi sub markdown-to-html(Str $markdown, Str :flags($flag) = '') is export {
    return build-and-compile($markdown, flags($flag));
}

multi markdown-to-html(Str $markdown, :@flags = ()) is export {
    return build-and-compile($markdown, flags(@flags));
}
